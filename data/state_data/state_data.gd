## StateData is a combination of idle and speak images.
##
## User can have many states (images to use when angry/sad/happy...).[br]
## Each state can be triggered by specific shortcuts and can contain many plugins.
class_name StateData
extends Resource


## Image to be used when not speaking.
@export var idle_image: Image = Image.new()

## Image to be used when speaking.
@export var speaking_image: Image = Image.new()

## TODO: Shortcut to trigger this state.
@export var shortcut = null

## TODO: Plugins to be used during this state.
@export var plugins = null


func _init(idle: Image, speaking: Image) -> void:
	idle_image = idle
	speaking_image = speaking


func save_to_zip(zip_packer: ZIPPacker, dir: String) -> void:
	var config = JSON.stringify({
		"shortcut": null, # TODO: Support for shortcut
		"plugins": 0, # TODO: Support for plugins
	})
	
	# Try this:
	# ResourceSaver.save(self, "user://test")
	
	zip_packer.start_file("%s/config.json" % dir)
	zip_packer.write_file(config.to_utf8_buffer())
	zip_packer.close_file()
	
	zip_packer.start_file("%s/idle.png" % dir)
	zip_packer.write_file(idle_image.save_png_to_buffer())
	zip_packer.close_file()
	
	zip_packer.start_file("%s/speaking.png" % dir)
	zip_packer.write_file(speaking_image.save_png_to_buffer())
	zip_packer.close_file()


func load_from_zip(zip_reader: ZIPReader, dir: String) -> void:
	pass
