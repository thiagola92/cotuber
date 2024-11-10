extends Button


@export var avatar_texture: AvatarTexture

@onready var _file_dialog := $FileDialog

@onready var _accept_dialog := $AcceptDialog


func _on_pressed() -> void:
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	var zip_reader := ZIPReader.new()
	var error := zip_reader.open(path)
	
	if error:
		_accept_dialog.dialog_text = "Error %s when reading zip file" % error
		_accept_dialog.popup_centered()
		return
	
	if not zip_reader.file_exists("config.json"):
		_accept_dialog.dialog_text = "File config.json not found in zip"
		_accept_dialog.popup_centered()
		return
	
	if not zip_reader.file_exists("img0.png"):
		_accept_dialog.dialog_text = "File img0.png not found in zip"
		_accept_dialog.popup_centered()
		return
	
	if not zip_reader.file_exists("img1.png"):
		_accept_dialog.dialog_text = "File img1.png not found in zip"
		_accept_dialog.popup_centered()
		return
	
	var config = JSON.parse_string(
		zip_reader.read_file("config.json").get_string_from_utf8()
	)
	
	if config == null:
		_accept_dialog.dialog_text = "Invalid config.json" % error
		_accept_dialog.popup_centered()
		return
	
	var image0 := Image.new()
	var img0 := zip_reader.read_file("img0.png")
	error = image0.load_png_from_buffer(img0)
	
	if error == null:
		_accept_dialog.dialog_text = "Error %s when loading img0.png" % error
		_accept_dialog.popup_centered()
		return
	
	var image1 := Image.new()
	var img1 := zip_reader.read_file("img1.png")
	error = image1.load_png_from_buffer(img1)
	
	if error == null:
		_accept_dialog.dialog_text = "Error %s when loading img1.png" % error
		_accept_dialog.popup_centered()
		return
	
	avatar_texture.set_idle_avatar(ImageTexture.create_from_image(image0))
	avatar_texture.set_speaking_avatar(ImageTexture.create_from_image(image1))
