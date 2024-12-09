class_name StateButton
extends Button


signal switch_requested(from: int, to: int)

const button_shiny := preload("res://components/states_menu/state_button/button_shiny.tres")

const button_shiny_pressed := preload("res://components/states_menu/state_button/button_shiny_pressed.tres")

var index := 0

var _idle: Texture2D

var _speaking: Texture2D

@onready var timer := $Timer

@onready var line := $Line


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


func _get_drag_data(_at_position: Vector2) -> Variant:
	return self


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not data is StateButton:
		return false
	
	if data == self:
		return false
	
	line.show()
	
	if at_position.y <= size.y / 2:
		line.position.y = 0
	else:
		line.position.y = size.y - line.size.y
	
	return (data as StateButton).is_in_group("state_button")


func _drop_data(at_position: Vector2, data: Variant) -> void:
	data = data as StateButton
	
	if at_position.y <= size.y / 2:
		switch_requested.emit(data.index, index)
	else:
		switch_requested.emit(data.index, index + 1)


func _on_mouse_entered() -> void:
	timer.start()


func _on_mouse_exited() -> void:
	timer.stop()
	line.hide()
	icon = _idle


func _on_timer_timeout() -> void:
	if icon == _idle:
		icon = _speaking
	else:
		icon = _idle
