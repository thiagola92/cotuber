class_name Avatar
extends Control


var _is_dragging := false

@onready var _idle_avatar := %IdleAvatar

@onready var _speaking_avatar := %SpeakingAvatar


func _ready() -> void:
	_move_to_center()


func show_idle_avatar() -> void:
	_idle_avatar.show()
	_speaking_avatar.hide()


func show_speaking_avatar() -> void:
	_speaking_avatar.show()
	_idle_avatar.hide()


func get_idle_texture() -> TextureRect:
	return _idle_avatar.clone


func get_speaking_texture() -> TextureRect:
	return _speaking_avatar.clone


func set_textures(idle: Texture2D, speaking: Texture2D) -> void:
	_idle_avatar.set_texture(idle)
	_speaking_avatar.set_texture(speaking)


func _move_to_center() -> void:
	var center := (get_window().size as Vector2) / 2 - size / 2
	
	global_position = center


func _on_top_left_gui_input(event: InputEvent) -> void:
	pass


func _on_top_right_gui_input(event: InputEvent) -> void:
	pass


func _on_middle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_is_dragging = true
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_is_dragging = false
	elif event is InputEventMouseMotion:
		if _is_dragging:
			global_position += event.relative


func _on_bottom_left_gui_input(event: InputEvent) -> void:
	pass


func _on_bottom_right_gui_input(event: InputEvent) -> void:
	pass
