extends TextureProgressBar


signal minimum_changed(value: float)

var _minimum_volume: float

var _is_dragging := false

@onready var _marker := $Marker


func _ready() -> void:
	set_minimum_volume(0.05)


func get_minimum_volume() -> float:
	return _minimum_volume


func set_minimum_volume(v: float) -> void:
	var voice_bar_width: float = get_minimum_size().x
	
	# Make sure that is inside bounds
	_minimum_volume = clampf(v, min_value, max_value)
	
	# Percentage relative to voice_bar_width.
	_marker.position.x = (_minimum_volume / max_value) * voice_bar_width


func _move_arrow(x: float) -> void:
	var voice_bar_width: float = get_minimum_size().x
	var marker_width: float = _marker.get_minimum_size().x
	
	# Make sure that is inside voice bar.
	x = clampf(x, 0, voice_bar_width)
	
	# Arrow pointing to click position.
	_marker.position.x = clampf(
		x - marker_width / 2,
		- marker_width / 2,
		voice_bar_width - marker_width / 2
	)
	
	# Percentage relative to max_value.
	_minimum_volume = (x / voice_bar_width) * max_value


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_mouse_button(event)
	elif event is InputEventMouseMotion:
		_on_mouse_motion(event)


func _on_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_move_arrow(event.position.x)
		_is_dragging = true
	elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_move_arrow(event.position.x)
		_is_dragging = false


func _on_mouse_motion(event: InputEventMouseMotion) -> void:
	if _is_dragging:
		_move_arrow(event.position.x)
