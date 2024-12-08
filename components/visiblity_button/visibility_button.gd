extends Button


const CLOSE_EYE := preload("res://components/visiblity_button/close_eye.svg")

const OPEN_EYE := preload("res://components/visiblity_button/open_eye.svg")


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		icon = CLOSE_EYE
	else:
		icon = OPEN_EYE
