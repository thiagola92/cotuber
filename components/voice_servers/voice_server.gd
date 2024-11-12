class_name VoiceServer
extends Node


signal volume_changed(voice_id: String, peak: float)

signal voice_started(voice_id: String)

signal voice_stopped(voice_id: String)

var users: Dictionary[String, UserData] = {}

var speaking: Dictionary[String, bool] = {}

var tweens: Dictionary[String, Tween] = {}


func start_speaking(id: String) -> void:
	voice_started.emit(id)


## Change speaking status from specific user (taking in count the [member UserData.speak_duration]).
func stop_speaking(id: String) -> void:
	if id in tweens:
		tweens[id].kill()
	
	var delay := users[id].speak_duration
	
	tweens[id] = create_tween()
	tweens[id].tween_interval(delay).finished.connect(
		func():
			if not speaking[id]:
				voice_stopped.emit(id)
	)
