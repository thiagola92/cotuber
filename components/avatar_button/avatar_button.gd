extends Button


signal image_received(image: Image)

signal mouse_moved

@onready var _file_dialog := $FileDialog

@onready var _load_input: LoadInput = $LoadInput


func _ready() -> void:
	if OS.get_name() == "Web":
		_load_input.init()
	
	_file_dialog.hide()
	
	if OS.get_name() == "Web":
		get_tree().root.window_input.connect(_on_window_input)
		get_window().files_dropped.connect(_on_web_window_files_dropped)
	else:
		get_window().files_dropped.connect(_on_os_window_files_dropped)


func _set_image(file: String) -> void:
	var image := Image.new()
	var error := image.load(file)
	
	if error:
		return ErrorPopup.show_message("AVATAR_BUTTON_ERROR_FORMAT")
	
	image_received.emit(image)


func _on_window_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_moved.emit()


func _on_os_window_files_dropped(files: PackedStringArray) -> void:
	# Check if is dropping at this Control.
	if not Rect2(global_position, size).has_point(get_global_mouse_position()):
		return
	
	if len(files) != 1:
		return ErrorPopup.show_message("AVATAR_BUTTON_ERROR_DROPPED")
	
	_set_image(files[0])


func _on_web_window_files_dropped(files: PackedStringArray) -> void:
	# INFO: On web, global mouse position is NOT updated while you are dragging a file,
	# only after you drop it. 
	# HACK: To solve this, we await any input into window so we can get
	# the global mouse position.
	# INFO: On web, files dropped are temporary and can be excluded right after
	# we receive the files_dropped signal.
	# HACK: To avoid losing the file dropped while awaiting the timer,
	# we store it content on a variable and recreate it later.
	var filepath: String = files[0]
	var filename: String = filepath.get_file()
	var filebytes := FileAccess.get_file_as_bytes(filepath)
	
	if filebytes.is_empty():
		return push_error("Failed to get file bytes (error: %s)", FileAccess.get_open_error())
	
	await mouse_moved
	
	var error := TmpDir.create_file_with_bytes(filename, filebytes)
	
	if error:
		return push_error("Failed to create temporary file (error: %s)", error)
	
	_on_os_window_files_dropped(PackedStringArray([TmpDir.path(filename)]))


func _on_pressed() -> void:
	if OS.get_name() == "Web":
		return _load_input.click()
	
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	_set_image(path)


func _on_load_input_file_received(file: PackedByteArray, filename: String) -> void:
	var error := TmpDir.create_file_with_bytes(filename, file)
	
	if error:
		return push_error("Failed to create temporary file (error: %s)", error)
	
	_set_image(TmpDir.path(filename))
