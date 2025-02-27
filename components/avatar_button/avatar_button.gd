extends Button


signal image_received(image: Image)

@onready var _file_dialog := $FileDialog

@onready var _load_input: LoadInput = $LoadInput


func _ready() -> void:
	if OS.get_name() == "Web":
		_load_input.init()
	
	_file_dialog.hide()
	get_window().files_dropped.connect(_on_window_files_dropped)


func _set_image(file: String) -> void:
	var image := Image.new()
	var error := image.load(file)
	
	if error:
		return ErrorPopup.show_message("AVATAR_BUTTON_ERROR_FORMAT")
	
	image_received.emit(image)


func _on_window_files_dropped(files: PackedStringArray) -> void:
	# Check if is dropping at this Control.
	if not Rect2(global_position, size).has_point(get_global_mouse_position()):
		return
	
	if len(files) != 1:
		return ErrorPopup.show_message("AVATAR_BUTTON_ERROR_DROPPED")
	
	_set_image(files[0])


func _on_pressed() -> void:
	if OS.get_name() == "Web":
		return _load_input.click()
	
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	_set_image(path)


func _on_load_input_file_received(file: PackedByteArray, filename: String) -> void:
	var error := TmpDir.create_tmp_file_with_bytes(filename, file)
	
	if error:
		return push_error("Failed to create temporary ZIP (error: %s)", error)
	
	_set_image(TmpDir.path(filename))
