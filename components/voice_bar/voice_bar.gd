class_name VoiceBar
extends Control


var min_volume: float

var _is_dragging: bool = false

@onready var _arrow := %Arrow

@onready var _arrow_width: float = %Arrow.get_minimum_size().x

@onready var _volume_bar := %VolumeBar

@onready var _volume_bar_width: float = %VolumeBar.get_minimum_size().x


func _ready() -> void:
	_move_arrow(_volume_bar_width / 4)


func update_volume(volume: float) -> void:
	_volume_bar.value = volume


func _move_arrow(relative_x: float) -> void:
	# Position inside volume bar.
	relative_x = clampf(relative_x, 0, _volume_bar_width)
	
	# Arrow pointing to click position.
	_arrow.position.x = clampf(
		relative_x - _arrow_width / 2,
		- _arrow_width / 2,
		_volume_bar_width - _arrow_width / 2
	)
	
	# Obtain percentage relative to volume bar max_value.
	min_volume = (relative_x / _volume_bar_width) * _volume_bar.max_value


func _on_volume_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_volume_bar_mouse_button(event)
	elif event is InputEventMouseMotion:
		_on_volume_bar_mouse_motion(event)


func _on_volume_bar_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_on_volume_bar_left_click_pressed(event)
	elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_on_volume_bar_left_click_released(event)


func _on_volume_bar_left_click_pressed(event: InputEventMouseButton) -> void:
	_move_arrow(event.position.x)
	_is_dragging = true


func _on_volume_bar_left_click_released(event: InputEventMouseButton) -> void:
	_move_arrow(event.position.x)
	_is_dragging = false


func _on_volume_bar_mouse_motion(event: InputEventMouseMotion) -> void:
	if _is_dragging:
		_move_arrow(event.position.x)
