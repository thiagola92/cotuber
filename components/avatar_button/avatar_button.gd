extends Button


func _ready() -> void:
	get_window().files_dropped.connect(_on_window_files_dropped)


func _on_window_files_dropped(files: PackedStringArray) -> void:
	# Check if is dropping at this Control.
	if not Rect2(global_position, size).has_point(get_global_mouse_position()):
		return
	
	if len(files) != 1:
		return ErrorPopup.show_message("AVATAR_BUTTON_ERROR_DROPPED")
	
	var image := Image.new()
	var error := image.load(files[0])
	
	if error:
		return ErrorPopup.show_message("AVATAR_BUTTON_ERROR_FORMAT")
	
	icon = ImageTexture.create_from_image(image)
