extends Button


signal scene_loaded(scene_data: SceneData)

@onready var _file_dialog := $FileDialog


func _on_pressed() -> void:
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	scene_loaded.emit(path)
