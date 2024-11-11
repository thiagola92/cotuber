class_name AvatarTexture
extends Node


@export var id := ""

@export var voice_server: VoiceServer:
	set(v):
		if voice_server:
			voice_server.voice_started.disconnect(_on_voice_server_voice_started)
			voice_server.voice_stopped.disconnect(_on_voice_server_voice_stopped)
		
		if v:
			v.voice_started.connect(_on_voice_server_voice_started)
			v.voice_stopped.connect(_on_voice_server_voice_stopped)
		
		voice_server = v

@onready var _avatar_idle := %AvatarIdle

@onready var _idle_resizer := %IdleResizer

@onready var _avatar_speaking := %AvatarSpeaking

@onready var _speaking_resizer := %SpeakingResizer


func get_idle_avatar() -> Texture2D:
	return _avatar_idle.texture


func get_speaking_avatar() -> Texture2D:
	return _avatar_speaking.texture


func hide_resizers() -> void:
	_idle_resizer.hide()
	_speaking_resizer.hide()


func set_idle_avatar(texture: ImageTexture) -> void:
	_avatar_idle.texture = texture


func set_speaking_avatar(texture: ImageTexture) -> void:
	_avatar_speaking.texture = texture


func _on_voice_server_voice_started(voice_id: String) -> void:
	if voice_id != id:
		return
	
	_avatar_idle.visible = false
	_avatar_speaking.visible = true


func _on_voice_server_voice_stopped(voice_id: String) -> void:
	if voice_id != id:
		return
	
	_avatar_idle.visible = true
	_avatar_speaking.visible = false
