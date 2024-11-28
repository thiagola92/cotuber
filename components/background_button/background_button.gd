extends Button


@onready var _background_window := $BackgroundWindow

@onready var _color_picker := %ColorPicker


func _ready() -> void:
	_background_window.hide()


func _on_pressed() -> void:
	_background_window.popup_centered()
	_background_window.grab_focus()


func _on_background_window_close_requested() -> void:
	_background_window.hide()


func _on_background_window_focus_exited() -> void:
	if not _color_picker.has_focus():
		_background_window.hide()


func _on_color_button_toggled(color: Color) -> void:
	BackgroundColor.live_color = color


func _on_custom_button_pressed() -> void:
	BackgroundColor.live_color = _color_picker.color


func _on_color_picker_color_changed(color: Color) -> void:
	BackgroundColor.live_color = _color_picker.color


func _on_color_picker_popup_closed() -> void:
	_background_window.grab_focus()
