extends Button


@onready var _file_dialog := $FileDialog


func _on_pressed() -> void:
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	
	file.store_string(JSON.stringify({
		"microphone": AudioServer.input_device,
	}))
