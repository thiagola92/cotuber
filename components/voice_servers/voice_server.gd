class_name VoiceServer
extends Node


signal volume_changed(voice_id: String, peak: float)

signal voice_started(voice_id: String)

signal voice_stopped(voice_id: String)

var users: Dictionary[String, CharacterData] = {}

var speaking: Dictionary[String, bool] = {}


func create_user(id: String, character_data: CharacterData) -> void:
	users[id] = character_data
	speaking[id] = false


func start_speaking(id: String) -> void:
	voice_started.emit(id)


func stop_speaking(id: String) -> void:
	voice_stopped.emit(id)
