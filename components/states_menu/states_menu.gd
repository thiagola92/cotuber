extends MarginContainer


signal pressed(index: int)

signal create_request

const StateButton := preload("res://components/states_menu/state_button/state_button.tscn")

const AddButton := preload("res://components/states_menu/add_button/add_button.tscn")

@onready var states_list := %StatesList


func fill_states_list(states: Array[StateData], current_index: int) -> void:
	# Clear before adding all states.
	for child in states_list.get_children():
		child.queue_free()
	
	for index in states.size():
		var state := states[index]
		var state_button: Button = StateButton.instantiate()
		
		state_button.pressed.connect(_on_state_button_pressed.bind(index))
		state_button.set_images(state.idle_image, state.speaking_image)
		states_list.add_child(state_button)
		
		if index == current_index:
			state_button.make_shiny()
	
	var add_button: Button = AddButton.instantiate()
	add_button.pressed.connect(_on_add_button_pressed)
	states_list.add_child(add_button)


func _on_state_button_pressed(index: int) -> void:
	pressed.emit(index)


func _on_add_button_pressed() -> void:
	create_request.emit()
