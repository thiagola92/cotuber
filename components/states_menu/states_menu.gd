extends MarginContainer


signal pressed(index: int)

signal move_requested(from: int, to: int)

signal delete_requested(index: int)

signal create_requested

const StateButtonScene := preload("res://components/states_menu/state_button/state_button.tscn")

const AddButtonScene := preload("res://components/states_menu/add_button/add_button.tscn")

@onready var _options_container := %OptionsContainer

@onready var _states_list := %StatesList


func _ready() -> void:
	_options_container.hide()


func fill_states_list(states: Array[StateData], current_index: int) -> void:
	# Clear before adding all states.
	for child in _states_list.get_children():
		child.queue_free()
	
	for index in states.size():
		var state := states[index]
		var state_button: StateButton = StateButtonScene.instantiate()
		
		state_button.pressed.connect(_on_state_button_pressed.bind(index))
		state_button.move_requested.connect(_on_state_button_move_requested)
		state_button.options_requested.connect(_on_state_button_options_requested)
		state_button.init(state.idle_image, state.speaking_image, index)
		state_button.add_to_group("state_button")
		_states_list.add_child(state_button)
		
		if index == current_index:
			state_button.make_shiny()
	
	var add_button: Button = AddButtonScene.instantiate()
	add_button.pressed.connect(_on_add_button_pressed)
	_states_list.add_child(add_button)


func _on_options_container_delete_requested(index: int) -> void:
	delete_requested.emit(index)


func _on_state_button_pressed(index: int) -> void:
	_options_container.hide()
	pressed.emit(index)


func _on_state_button_move_requested(from: int, to: int) -> void:
	_options_container.hide()
	move_requested.emit(from, to)


func _on_state_button_options_requested(index: int) -> void:
	_options_container.target = _states_list.get_child(index)
	_options_container.show()


func _on_add_button_pressed() -> void:
	_options_container.hide()
	create_requested.emit()
