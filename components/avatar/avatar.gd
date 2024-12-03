class_name Avatar
extends Control


@onready var _idle_avatar := $IdleAvatar

@onready var _speaking_avatar := $SpeakingAvatar


func show_idle_avatar() -> void:
	_idle_avatar.show()
	_speaking_avatar.hide()


func show_speaking_avatar() -> void:
	_speaking_avatar.show()
	_idle_avatar.hide()


func reset_avatar() -> void:
	_idle_avatar.create_clone()
	_speaking_avatar.create_clone()


func get_idle_texture() -> TextureRect:
	return _idle_avatar.clone


func get_speaking_texture() -> TextureRect:
	return _speaking_avatar.clone


func set_idle_texture(texture: Texture2D) -> void:
	_idle_avatar.set_texture(texture)


func set_speaking_texture(texture: Texture2D) -> void:
	_speaking_avatar.set_texture(texture)
