extends Button


@onready var background_window := $BackgroundWindow

@onready var color_picker_button := %ColorPickerButton


func _update_color(color: Color) -> void:
	color_picker_button.color = color
	BackgroundColor.live_color = color


func _on_pressed() -> void:
	background_window.popup_centered()


func _on_window_close_requested() -> void:
	background_window.hide()


func _on_color_picker_button_color_changed(color: Color) -> void:
	_update_color(color)


func _on_default_pressed() -> void:
	_update_color(Color.hex(0x4d4d4dff))


func _on_green_pressed() -> void:
	_update_color(Color.GREEN)


func _on_red_pressed() -> void:
	_update_color(Color.RED)


func _on_blue_pressed() -> void:
	_update_color(Color.BLUE)


func _on_transparent_pressed() -> void:
	_update_color(Color.TRANSPARENT)
