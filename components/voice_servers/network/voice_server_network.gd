class_name VoiceServerNetwork
extends VoiceServer


@onready var _bus_index := AudioServer.get_bus_index("Microphone")


func _ready() -> void:
	id = str(multiplayer.get_unique_id())
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func _process(_delta: float) -> void:
	if id not in users:
		return
	
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


func _on_peer_connected(peer: int) -> void:
	create_user(str(peer), CharacterData.new())
	voice_connected.emit(peer)


func _on_peer_disconnected(peer: int) -> void:
	delete_user(str(peer))
	voice_disconnected.emit(peer)
