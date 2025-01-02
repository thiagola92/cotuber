class_name AvatarFriend
extends Control


signal character_loaded(character: CharacterData)

@onready var avatar: Avatar = $Avatar

@onready var _load_button: LoadButton = %LoadButton


func hide_tools() -> void:
	avatar.hide_tools()
	_load_button.hide()


func show_tools() -> void:
	avatar.show_tools()
	_load_button.show()


func _on_load_button_character_loaded(character: CharacterData) -> void:
	character_loaded.emit(character)
