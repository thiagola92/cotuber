extends Button


signal character_loaded(character_data: CharacterData)

@onready var _file_dialog := $FileDialog


func _on_pressed() -> void:
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	var resource = ResourceLoader.load(path, "CharacterData")
	
	if resource:
		character_loaded.emit(path)
