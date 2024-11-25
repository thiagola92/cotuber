class_name UserData
extends RefCounted


var id: String = ""

## Minimum volume to start using speaking image.
var minimum_volume: float = 0.25

## Position for both images.
var image_position: Vector2

## Size for both images
var image_size: Vector2

## All possible states.
var states: Array[StateData] = []


func to_json() -> String:
	var s := []
	
	for i in len(states):
		s.append({
			"idle_image": "state_{}_idle.png".format(i),
			"speaking_image": "state_{}_speaking.png".format(i),
		})
	
	return JSON.stringify({
		"id": id,
		"minimum_volume": minimum_volume,
		"image_position": image_position,
		"image_size": image_size,
		"states": s,
	}, "  ")


## State is a combination of idle and speak images.
## User can have many states (images to use when angry/sad/happy...).
class StateData:
	## Image to be used when not speaking.
	var idle_image: Image = Image.new()

	## Image to be used when speaking.
	var speaking_image: Image = Image.new()
	
	## TODO: Shortcut to trigger this state.
	var shortcut = null
	
	## TODO: Plugins to be used during this state.
	var plugins = null
	
	func _init(idle: Image, speaking: Image) -> void:
		idle_image = idle
		speaking_image = speaking
