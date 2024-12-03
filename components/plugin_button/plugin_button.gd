extends Button


signal plugins_popup_requested

var show_warning := true

@onready var _warning_window := $WarningWindow


func _ready() -> void:
	_warning_window.hide()


func _on_pressed() -> void:
	if show_warning:
		_warning_window.popup_centered()
	else:
		plugins_popup_requested.emit()


func _on_warning_window_close_requested() -> void:
	_warning_window.hide()


func _on_understand_check_box_toggled(toggled_on: bool) -> void:
	show_warning = !toggled_on


func _on_understand_button_pressed() -> void:
	_warning_window.hide()
	plugins_popup_requested.emit()
