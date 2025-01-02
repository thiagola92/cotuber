class_name AvatarFriend
extends Control


@onready var avatar: Avatar = $Avatar

@onready var load_button := %LoadButton


func hide_tools() -> void:
	avatar.hide_tools()
	load_button.hide()


func show_tools() -> void:
	avatar.show_tools()
	load_button.show()


func _on_load_button_character_loaded(character: CharacterData) -> void:
	print("character_loaded")
