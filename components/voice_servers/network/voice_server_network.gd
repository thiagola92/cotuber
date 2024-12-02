class_name VoiceServerNetwork
extends VoiceServer


var id := ""

@onready var _bus_index := AudioServer.get_bus_index("Microphone")


func _ready() -> void:
	id = str(multiplayer.get_unique_id())


func _process(_delta: float) -> void:
	var user = users[id]
	var peak = db_to_linear(AudioServer.get_bus_peak_volume_left_db(_bus_index, 0))
	
	volume_changed.emit(id, peak)
	
	if peak >= user.minimum_volume and not speaking[id]:
		speaking[id] = true
		_start_speaking.rpc()
	elif peak < user.minimum_volume and speaking[id]:
		speaking[id] = false
		_stop_speaking.rpc()


@rpc("any_peer", "call_local", "unreliable")
func _start_speaking() -> void:
	start_speaking(str(multiplayer.get_remote_sender_id()))


@rpc("any_peer", "call_local", "unreliable")
func _stop_speaking() -> void:
	stop_speaking(str(multiplayer.get_remote_sender_id()))
