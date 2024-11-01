extends VoiceServer


@export var voice_bar: VoiceBar

@onready var _bus_index: int = AudioServer.get_bus_index("Microphone")


func _process(_delta: float) -> void:
	var peak = db_to_linear(AudioServer.get_bus_peak_volume_left_db(_bus_index, 0))
	
	voice_bar.update_volume(peak)
	
	for id in speaking:
		if peak >= voice_bar.min_volume and not speaking[id]:
			speaking[id] = true
			start_speaking.emit(id)
		elif peak < voice_bar.min_volume and speaking[id]:
			speaking[id] = false
			stop_speaking.emit(id)
