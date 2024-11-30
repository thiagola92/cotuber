class_name VoiceServerOffline
extends VoiceServer


@onready var _bus_index := AudioServer.get_bus_index("Microphone")


func _process(_delta: float) -> void:
	for id in users:
		var user = users[id]
		var peak = db_to_linear(AudioServer.get_bus_peak_volume_left_db(_bus_index, 0))
	
		volume_changed.emit(id, peak)
		
		if peak >= user.minimum_volume and not speaking[id]:
			speaking[id] = true
			start_speaking(id)
		elif peak < user.minimum_volume and speaking[id]:
			speaking[id] = false
			stop_speaking(id)
