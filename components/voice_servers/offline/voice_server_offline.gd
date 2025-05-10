class_name VoiceServerOffline
extends VoiceServer


@onready var _bus_index := AudioServer.get_bus_index("Microphone")


func _process(_delta: float) -> void:
	if id not in users:
		return
	
	var user = users[id]
	var peak = db_to_linear(AudioServer.get_bus_peak_volume_left_db(_bus_index, 0))

	volume_changed.emit(id, peak)
	
	if peak >= user.minimum_volume and not speaking[id]:
		speaking[id] = true
		voice_started.emit(id)
	elif peak < user.minimum_volume and speaking[id]:
		speaking[id] = false
		voice_stopped.emit(id)
