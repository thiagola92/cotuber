extends Button


signal new_image(image: Image)

@onready var _file_dialog := $FileDialog


func _ready() -> void:
	_file_dialog.hide()
	get_window().files_dropped.connect(_on_window_files_dropped)


func _set_image(file: String) -> void:
	var image := Image.new()
	var error := image.load(file)
	
	if error:
		return ErrorPopup.show_message("AVATAR_BUTTON_ERROR_FORMAT")
	
	new_image.emit(image)


func _on_window_files_dropped(files: PackedStringArray) -> void:
	# Check if is dropping at this Control.
	if not Rect2(global_position, size).has_point(get_global_mouse_position()):
		return
	
	if len(files) != 1:
		return ErrorPopup.show_message("AVATAR_BUTTON_ERROR_DROPPED")
	
	_set_image(files[0])


func _on_pressed() -> void:
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	_set_image(path)
