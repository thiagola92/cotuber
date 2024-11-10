extends Button


@onready var _microphones_menu: PopupMenu = $MicrophonesMenu


func _on_pressed() -> void:
	_microphones_menu.clear()
	
	for input_device in AudioServer.get_input_device_list():
		if input_device == AudioServer.input_device:
			_microphones_menu.add_icon_item(load("res://components/microphone_button/arrow.svg"), input_device)
		else:
			_microphones_menu.add_item(input_device)
	
	_microphones_menu.popup_centered()


func _on_microphones_menu_index_pressed(index: int) -> void:
	AudioServer.input_device = _microphones_menu.get_item_text(index)
	_microphones_menu.hide()
