extends Control


@onready var _idle_avatar := $IdleAvatar

@onready var _speaking_avatar := $SpeakingAvatar


func show_idle_avatar() -> void:
	_idle_avatar.show()
	_speaking_avatar.hide()


func show_speaking_avatar() -> void:
	_speaking_avatar.show()
	_idle_avatar.hide()


func get_idle_texture() -> Texture2D:
	return _idle_avatar.clone_texture


func get_speaking_texture() -> Texture2D:
	return _speaking_avatar.clone_texture