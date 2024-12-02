## CharacterData represents all data about a character in the screen.
class_name CharacterData
extends Resource


@export var id: String = ""

## Minimum volume to start using speaking image.
@export var minimum_volume: float = 0.25

## Position for both images.
@export var image_position: Vector2

## Size for both images.
@export var image_size: Vector2

## Color to be used as background.
@export var background_color: Color

## All possible states.
@export var _states: Array[StateData] = [StateData.new()]


## Get a state.
func get_state(index: int) -> StateData:
	return _states[index]


## Add a new state using another as base.
func add_state(state: StateData) -> void:
	_states.append(state.duplicate(true))


## Remove a state but guarantee at least one state.
func remove_state(index: int) -> void:
	_states.remove_at(index)
	
	if _states.is_empty():
		_states = [StateData.new()]
