extends Button


const button_shiny := preload("res://components/states_menu/state_button/button_shiny.tres")

const button_shiny_pressed := preload("res://components/states_menu/state_button/button_shiny_pressed.tres")

var _idle: Texture2D

var _speaking: Texture2D

@onready var timer := $Timer


func set_images(idle: Image, speaking: Image) -> void:
	_idle = ImageTexture.create_from_image(idle)
	_speaking = ImageTexture.create_from_image(speaking)
	
	icon = _idle


func make_shiny() -> void:
	add_theme_stylebox_override("focus", button_shiny)
	add_theme_stylebox_override("disabled", button_shiny)
	add_theme_stylebox_override("hover_pressed", button_shiny)
	add_theme_stylebox_override("hover", button_shiny)
	add_theme_stylebox_override("pressed", button_shiny_pressed)
	add_theme_stylebox_override("normal", button_shiny)


func _on_mouse_entered() -> void:
	timer.start()


func _on_mouse_exited() -> void:
	timer.stop()
	icon = _idle


func _on_timer_timeout() -> void:
	if icon == _idle:
		icon = _speaking
	else:
		icon = _idle
