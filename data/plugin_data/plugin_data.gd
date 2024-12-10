class_name PluginData
extends Resource


func filename() -> String:
	return (get_script() as Script).resource_path.get_file()


## Virtual method
@warning_ignore("unused_parameter")
func init(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## Virtual method
@warning_ignore("unused_parameter")
func process(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## Virtual method
@warning_ignore("unused_parameter")
func start_speaking(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## Virtual method
@warning_ignore("unused_parameter")
func stop_speaking(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## Virtual method
@warning_ignore("unused_parameter")
func save_plugin(zip: ZIPPacker, path: String) -> Dictionary:
	return {}


## Virtual method
@warning_ignore("unused_parameter")
func load_plugin(zip: ZIPReader, path: String, data: Dictionary) -> void:
	pass


## Virtual method
func create_view() -> Control:
	return Control.new()
