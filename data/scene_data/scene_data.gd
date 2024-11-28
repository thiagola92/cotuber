## SceneData contains everything that will be saved/loaded from/to application.
##
## Only one SceneData can be active at same time, but one scene can contain many states.[br]
## This class contains everything that is global for all states.
class_name SceneData
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


func save_to_zip(path: String) -> void:
	var zip_packer := ZIPPacker.new()
	var error := zip_packer.open(path)
	
	if error:
		return ErrorPopup.show_message("ERROR_SCENE_DATA_FAILED_TO_CREATE_ZIP")
		
	var config = JSON.stringify({
		"id": id,
		"minimum_volume": minimum_volume,
		"image_position": image_position,
		"image_size": image_size,
		"states": len(states),
	}, "  ")
	
	zip_packer.start_file("config.json")
	zip_packer.write_file(config.to_utf8_buffer())
	zip_packer.close_file()
	
	for index in len(states):
		states[index].write_into_zip(zip_packer, str(index))


func load_from_zip(path: String) -> void:
	var zip_reader := ZIPReader.new()
	var error := zip_reader.open(path)
	
	if error:
		return ErrorPopup.show_message("ERROR_SCENE_DATA_FAILED_TO_OPEN_ZIP")
	
	if not zip_reader.file_exists("config.json"):
		return ErrorPopup.show_message("ERROR_SCENE_DATA_MISSING_CONFIG_IN_ZIP")
	
	var config = JSON.parse_string(zip_reader.read_file("config.json").get_string_from_utf8())
	
	if config == null:
		return ErrorPopup.show_message("ERROR_SCENE_DATA_INVALID_CONFIG")
	
	if not config is Dictionary:
		return ErrorPopup.show_message("ERROR_SCENE_DATA_CONFIG_NOT_DICT")
	
	for f in ["id", "minimum_volume", "image_position", "image_size", "states"]:
		if not (config as Dictionary).has(f):
			return ErrorPopup.show_message("ERROR_SCENE_DATA_CONFIG_MISSING_FIELD")
