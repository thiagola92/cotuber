extends Button


@export var avatar_texture: AvatarTexture

@onready var _file_dialog := $FileDialog

@onready var _accept_dialog := $AcceptDialog


func _on_pressed() -> void:
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	var zip_packer := ZIPPacker.new()
	var error := zip_packer.open(path)
	
	if error:
		_accept_dialog.dialog_text = "Error %s when creating zip file" % error
		_accept_dialog.popup_centered()
		return
	
	var config := JSON.stringify({
		"microphone": AudioServer.input_device,
	})
	
	var img0 := avatar_texture.get_idle_avatar().get_image()
	var img1 := avatar_texture.get_speaking_avatar().get_image()
	
	zip_packer.start_file("config.json")
	zip_packer.write_file(config.to_utf8_buffer())
	zip_packer.close_file()
	
	zip_packer.start_file("img0.png")
	zip_packer.write_file(img0.save_png_to_buffer())
	zip_packer.close_file()
	
	zip_packer.start_file("img1.png")
	zip_packer.write_file(img1.save_png_to_buffer())
	zip_packer.close_file()
	
	zip_packer.close()
