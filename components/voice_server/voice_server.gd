class_name VoiceServer
extends Node


signal voice_started(voice_id: String)

signal voice_stopped(voice_id: String)

var speaking: Dictionary[String, bool] = {}

var tweens: Dictionary[String, Tween] = {}


# Add a little delay before before stop speaking.
func _stop_later(id) -> void:
	if id in tweens:
		tweens[id].kill()
	
	tweens[id] = create_tween()
	tweens[id].tween_interval(0.2).finished.connect(
		func():
			if not speaking[id]:
				voice_stopped.emit("")
	)
