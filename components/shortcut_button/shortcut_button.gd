extends Button


signal shortcut_changed(event: InputEventKey)

@onready var _shortcut_window := $ShortcutWindow

@onready var _shortcut_line := %ShortcutLine

var state_shortcut: InputEventKey

var _visible_shortcut: InputEventKey


func _ready() -> void:
	_shortcut_window.hide()


func _set_visible_shortcut(event: InputEventKey) -> void:
	_visible_shortcut = event
	
	if _visible_shortcut:
		_shortcut_line.text = _visible_shortcut.as_text_keycode()
	else:
		_shortcut_line.text = "No shortcut"


func _on_pressed() -> void:
	_shortcut_window.popup_centered()
	_shortcut_window.grab_focus()
	_set_visible_shortcut(state_shortcut)


func _on_shortcut_window_close_requested() -> void:
	_shortcut_window.hide()


func _on_shortcut_window_window_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and get_tree().root.get_window().has_focus():
			_set_visible_shortcut(event)


func _on_save_button_pressed() -> void:
	_shortcut_window.hide()
	state_shortcut = _visible_shortcut
	shortcut_changed.emit(state_shortcut)


func _on_clear_button_pressed() -> void:
	_set_visible_shortcut(null)
