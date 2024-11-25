extends AcceptDialog


func _ready() -> void:
	hide()


func show_message(message: String) -> void:
	dialog_text = message
	popup_centered()
