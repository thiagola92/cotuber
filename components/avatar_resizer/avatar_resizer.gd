extends VBoxContainer


@export var avatar_texture: TextureRect

var _dragging_top_left: bool = false

var _dragging_top_right: bool = false

var _dragging_bottom_left: bool = false

var _dragging_bottom_right: bool = false

var _dragging_center: bool = false


func _ready() -> void:
	avatar_texture.visibility_changed.connect(_on_avatar_texture_visibility_changed)


func _on_avatar_texture_visibility_changed() -> void:
	if not avatar_texture.visible:
		_dragging_top_left = false
		_dragging_top_right = false
		_dragging_bottom_left = false
		_dragging_bottom_right = false
		_dragging_center = false


func _on_top_left_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_top_left_mouse_button(event)
	elif event is InputEventMouseMotion:
		_on_top_left_mouse_motion(event)


func _on_top_left_mouse_button(mouse_button: InputEventMouseButton) -> void:
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and mouse_button.pressed:
		_dragging_top_left = true
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and not mouse_button.pressed:
		_dragging_top_left = false


func _on_top_left_mouse_motion(mouse_motion: InputEventMouseMotion) -> void:
	if not _dragging_top_left:
		return
	
	avatar_texture.size -= mouse_motion.relative
	avatar_texture.global_position += mouse_motion.relative


func _on_top_right_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_top_right_mouse_button(event)
	elif event is InputEventMouseMotion:
		_on_top_right_mouse_motion(event)


func _on_top_right_mouse_button(mouse_button: InputEventMouseButton) -> void:
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and mouse_button.pressed:
		_dragging_top_right = true
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and not mouse_button.pressed:
		_dragging_top_right = false


func _on_top_right_mouse_motion(mouse_motion: InputEventMouseMotion) -> void:
	if not _dragging_top_right:
		return
	
	avatar_texture.size += Vector2(mouse_motion.relative.x, -mouse_motion.relative.y)
	avatar_texture.global_position.y += mouse_motion.relative.y


func _on_bottom_left_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_bottom_left_mouse_button(event)
	elif event is InputEventMouseMotion:
		_on_bottom_left_mouse_motion(event)


func _on_bottom_left_mouse_button(mouse_button: InputEventMouseButton) -> void:
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and mouse_button.pressed:
		_dragging_bottom_left = true
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and not mouse_button.pressed:
		_dragging_bottom_left = false


func _on_bottom_left_mouse_motion(mouse_motion: InputEventMouseMotion) -> void:
	if not _dragging_bottom_left:
		return
	
	avatar_texture.size += Vector2(-mouse_motion.relative.x, mouse_motion.relative.y)
	avatar_texture.global_position.x += mouse_motion.relative.x


func _on_bottom_right_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_bottom_right_mouse_button(event)
	elif event is InputEventMouseMotion:
		_on_bottom_right_mouse_motion(event)


func _on_bottom_right_mouse_button(mouse_button: InputEventMouseButton) -> void:
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and mouse_button.pressed:
		_dragging_bottom_right = true
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and not mouse_button.pressed:
		_dragging_bottom_right = false


func _on_bottom_right_mouse_motion(mouse_motion: InputEventMouseMotion) -> void:
	if not _dragging_bottom_right:
		return
	
	avatar_texture.size += mouse_motion.relative


func _on_center_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_center_mouse_button(event)
	elif event is InputEventMouseMotion:
		_on_center_mouse_motion(event)


func _on_center_mouse_button(mouse_button: InputEventMouseButton) -> void:
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and mouse_button.pressed:
		_dragging_center = true
	if mouse_button.button_index == MOUSE_BUTTON_LEFT and not mouse_button.pressed:
		_dragging_center = false


func _on_center_mouse_motion(mouse_motion: InputEventMouseMotion) -> void:
	if not _dragging_center:
		return
	
	avatar_texture.position += mouse_motion.relative
