class_name UserData
extends RefCounted


var id: String = ""

## Minimum volume to start using speaking image.
var minimum_volume: float = 0.25

## Delay before switch back to not speaking.
var speak_duration: int = 0

## Position for both images.
var image_position: Vector2

## Size for both images
var image_size: Vector2

## All possible states.
var states: Array[StateData] = []


func add_state(idle: Image, speaking: Image) -> void:
	states.append(StateData.new(idle, speaking))


## NOTE: JSON doesn't contain full path to file image,
## so all it does is clear the array states.
func from_json(d: Dictionary) -> void:
	id = d["id"]
	minimum_volume = d["minimum_volume"]
	speak_duration = d["speak_duration"]
	image_position = d["image_position"]
	image_size = d["image_size"]
	states = []


func to_json() -> String:
	var s := []
	
	for i in len(states):
		s.append({
			"idle_image": "state_{}_idle.png".format(i),
			"speaking_image": "state_{}_speaking.png".format(i),
		})
	
	var d := {
		"id": id,
		"minimum_volume": minimum_volume,
		"speak_duration": speak_duration,
		"image_position": image_position,
		"image_size": image_size,
		"states": s,
	}
	
	return JSON.stringify(d, "  ")


## State is a combination of idle and speak images.
## User can have many states (images to use when angry/sad/happy...).
class StateData:
	## Image to be used when not speaking.
	var idle_image: Image = Image.new()

	## Image to be used when speaking.
	var speaking_image: Image = Image.new()
	
	func _init(idle: Image, speaking: Image) -> void:
		idle_image = idle
		speaking_image = speaking
