class_name AvatarFriend
extends Control


@onready var avatar := $Avatar


func _on_load_button_character_loaded(character: CharacterData) -> void:
	print("character_loaded")
