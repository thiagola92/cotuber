extends MarginContainer


@onready var _avatar_texture := %AvatarTexture


func _on_voice_bar_idle_texture_dropped(texture: ImageTexture) -> void:
	_avatar_texture.set_idle_avatar(texture)


func _on_voice_bar_speak_texture_dropped(texture: ImageTexture) -> void:
	_avatar_texture.set_speaking_avatar(texture)
