## CharacterData represents all data about a character in the screen.
class_name CharacterData
extends Resource


var id: String = ""

## Minimum volume to start using speaking image.
@export var minimum_volume: float = 0.25

## Position for both images.
@export var image_position: Vector2

## Size for both images.
@export var image_size: Vector2 = Vector2(400, 400)

## Color to be used as background.
@export var background_color: Color = Color.html("#4d4d4d")

## All possible states.
@export var states: Array[StateData] = [StateData.new()]


## Add a new state using another as base.
func add_state(state: StateData) -> void:
	states.append(state.duplicate(true))


## Remove a state but guarantee at least one state.
func remove_state(index: int) -> void:
	states.remove_at(index)
	
	if states.is_empty():
		states = [StateData.new()]
