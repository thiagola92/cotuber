extends Button


signal canvas_double_clicked


@onready var _warning_canvas := $WarningCanvas

@onready var _animation_player := $AnimationPlayer


func show_canvas() -> void:
	_animation_player.play("HIDE")


func hide_canvas() -> void:
	_warning_canvas.visible = false


func _on_click_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
			canvas_double_clicked.emit()
