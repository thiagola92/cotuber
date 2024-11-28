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
@export var states: Array[StateData] = []
