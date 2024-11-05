extends Button


signal file_dropped(texture: ImageTexture)

@onready var _popup := $Popup


func _ready() -> void:
	get_window().files_dropped.connect(_on_window_files_dropped)


func _on_files_dropped(files: PackedStringArray) -> void:
	if len(files) == 1:
		var image := Image.new()
		var error := image.load(files[0])
		
		if error == OK:
			file_dropped.emit(ImageTexture.create_from_image(image))
			return
		
		_popup.dialog_text = "Not a valid format"
	elif len(files) > 1:
		_popup.dialog_text = "Can't drag multiple files"
	else:
		_popup.dialog_text = "How did you drag less than one file?!"
	
	_popup.popup_centered()


func _on_file_dropped(texture: ImageTexture) -> void:
	icon = texture


func _on_window_files_dropped(files: PackedStringArray) -> void:
	if Rect2(global_position, size).has_point(get_global_mouse_position()):
		_on_files_dropped(files)
