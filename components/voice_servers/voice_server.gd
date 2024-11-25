class_name VoiceServer
extends Node


signal volume_changed(voice_id: String, peak: float)

signal voice_started(voice_id: String)

signal voice_stopped(voice_id: String)

var users: Dictionary[String, UserData] = {}

var speaking: Dictionary[String, bool] = {}


func start_speaking(id: String) -> void:
	voice_started.emit(id)


func stop_speaking(id: String) -> void:
	voice_stopped.emit(id)
