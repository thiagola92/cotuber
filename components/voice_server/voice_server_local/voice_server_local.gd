extends VoiceServer


@export var voice_bar: VoiceBar

var _id := ""

@onready var _bus_index: int = AudioServer.get_bus_index("Microphone")


func _ready() -> void:
	speaking[_id] = false


func _process(_delta: float) -> void:
	var peak = db_to_linear(AudioServer.get_bus_peak_volume_left_db(_bus_index, 0))
	
	voice_bar.update_volume(peak)
	
	if peak >= voice_bar.min_volume and not speaking[_id]:
		speaking[_id] = true
		voice_started.emit(_id)
	elif peak < voice_bar.min_volume and speaking[_id]:
		speaking[_id] = false
		_stop_later(_id)
