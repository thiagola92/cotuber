extends Button


signal save_requested(path: String)

@onready var _file_dialog := $FileDialog


func _on_pressed() -> void:
	_file_dialog.popup_centered()


# Don't save here because all information necessary is with the main Window.
func _on_file_dialog_file_selected(path: String) -> void:
	if not path.ends_with(".tres"):
		path = "%s.tres" % path
	
	save_requested.emit(path)
