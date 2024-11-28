extends Button


@onready var _window := $Window


func _on_pressed() -> void:
	_window.popup_centered()


func _on_window_close_requested() -> void:
	_window.hide()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
