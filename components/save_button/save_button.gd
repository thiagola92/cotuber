extends Button


signal save_requested(path: String)

@onready var _file_dialog := $FileDialog


func _on_pressed() -> void:
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	# Don't save here because all information necessary is with the main Window.
	# Let it collect all informations and give you the data to be saved.
	save_requested.emit(path)
