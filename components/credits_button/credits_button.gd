extends Button


@onready var window := $Window


func _on_pressed() -> void:
	window.popup_centered()


func _on_window_close_requested() -> void:
	window.hide()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
