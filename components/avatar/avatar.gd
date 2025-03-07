class_name Avatar
extends Control


signal double_clicked

signal dragged

var _is_dragging := false

var _dragging_limit: Vector2

@onready var _top_left := %TopLeft

@onready var _top_right := %TopRight

@onready var _idle_avatar := %IdleAvatar

@onready var _speaking_avatar := %SpeakingAvatar

@onready var _bottom_left := %BottomLeft

@onready var _bottom_right := %BottomRight


func _ready() -> void:
	_move_to_center()


func show_idle_avatar() -> void:
	_idle_avatar.clone.show()
	_speaking_avatar.clone.hide()


func show_speaking_avatar() -> void:
	_speaking_avatar.clone.show()
	_idle_avatar.clone.hide()


func get_idle_texture() -> TextureRect:
	return _idle_avatar.clone


func get_speaking_texture() -> TextureRect:
	return _speaking_avatar.clone


func set_textures(idle: Texture2D, speaking: Texture2D) -> void:
	_idle_avatar.set_texture(idle)
	_speaking_avatar.set_texture(speaking)


func set_avatar_size(s: Vector2) -> void:
	size = s
	
	_idle_avatar.update_size(size - _top_left.size * 2)
	_speaking_avatar.update_size(size - _top_left.size * 2)


func hide_tools() -> void:
	_top_left.hide()
	_top_right.hide()
	_bottom_left.hide()
	_bottom_right.hide()


func show_tools() -> void:
	_top_left.show()
	_top_right.show()
	_bottom_left.show()
	_bottom_right.show()


func _move_to_center() -> void:
	var center := (get_window().size as Vector2) / 2 - size / 2
	
	global_position = center


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
			double_clicked.emit()


func _on_top_left_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_is_dragging = true
			_dragging_limit = global_position + size
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_is_dragging = false
			dragged.emit()
	elif event is InputEventMouseMotion:
		if _is_dragging:
			global_position = Vector2(
				min(global_position.x + event.relative.x, _dragging_limit.x),
				min(global_position.y + event.relative.y, _dragging_limit.y),
			)
			
			set_avatar_size(size - event.relative)


func _on_top_right_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_is_dragging = true
			_dragging_limit = Vector2(
				global_position.x,
				global_position.y + size.y
			)
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_is_dragging = false
			dragged.emit()
	elif event is InputEventMouseMotion:
		if _is_dragging:
			global_position = Vector2(
				_dragging_limit.x,
				min(global_position.y + event.relative.y, _dragging_limit.y),
			)
			
			set_avatar_size(Vector2(
				size.x + event.relative.x,
				size.y - event.relative.y
			))


func _on_middle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_is_dragging = true
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_is_dragging = false
			dragged.emit()
	elif event is InputEventMouseMotion:
		if _is_dragging:
			global_position += event.relative


func _on_bottom_left_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_is_dragging = true
			_dragging_limit = Vector2(
				global_position.x + size.x,
				global_position.y
			)
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_is_dragging = false
			dragged.emit()
	elif event is InputEventMouseMotion:
		if _is_dragging:
			global_position = Vector2(
				min(global_position.x + event.relative.x, _dragging_limit.x),
				_dragging_limit.y,
			)
			
			set_avatar_size(Vector2(
				size.x - event.relative.x,
				size.y + event.relative.y
			))


func _on_bottom_right_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_is_dragging = true
			_dragging_limit = global_position
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_is_dragging = false
			dragged.emit()
	elif event is InputEventMouseMotion:
		if _is_dragging:
			set_avatar_size(size + event.relative)
