extends Button


const ICON = preload("res://components/microphone_button/circle.svg")

@onready var _popup_menu := $PopupMenu


func _on_pressed() -> void:
	_popup_menu.clear()
	
	for input_device in AudioServer.get_input_device_list():
		if input_device == AudioServer.input_device:
			_popup_menu.add_icon_item(ICON, input_device)
		else:
			_popup_menu.add_item(input_device)
	
	_popup_menu.popup_centered()


func _on_popup_menu_index_pressed(index: int) -> void:
	AudioServer.input_device = _popup_menu.get_item_text(index)
	_popup_menu.hide()
