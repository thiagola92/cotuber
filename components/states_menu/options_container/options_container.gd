extends HBoxContainer


signal delete_requested(index: int)

var target: StateButton:
	set(t):
		if target:
			target.tree_exiting.disconnect(_on_target_tree_exiting)
		
		target = t
		
		if target:
			target.tree_exiting.connect(_on_target_tree_exiting)


func _process(_delta: float) -> void:
	if visible and target:
		global_position.y = (target.global_position.y + target.size.y / 4)


func _on_target_tree_exiting() -> void:
	target = null
	hide()


func _on_delete_button_pressed() -> void:
	if target:
		delete_requested.emit(target.index)
		hide()
