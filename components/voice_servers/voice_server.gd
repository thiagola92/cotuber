class_name VoiceServer
extends Node


@warning_ignore("unused_signal")
signal voice_connected(voice_id: String)

@warning_ignore("unused_signal")
signal voice_disconnected(voice_id: String)

@warning_ignore("unused_signal")
signal volume_changed(voice_id: String, peak: float)

@warning_ignore("unused_signal")
signal voice_started(voice_id: String)

@warning_ignore("unused_signal")
signal voice_stopped(voice_id: String)

var id: String = ""

var users: Dictionary[String, CharacterData] = {}

var speaking: Dictionary[String, bool] = {}


func create_user(voice_id: String, character_data: CharacterData) -> void:
	users[voice_id] = character_data
	speaking[voice_id] = false


func delete_user(voice_id: String) -> void:
	users.erase(voice_id)
	speaking.erase(voice_id)
