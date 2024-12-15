class_name PluginData
extends Resource


@warning_ignore("unused_signal")
signal restart_requested


func filename() -> String:
	return (get_script() as Script).resource_path.get_file()


## [i](Virtual method)[/i][br]
## [br]
@warning_ignore("unused_parameter")
func init(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
@warning_ignore("unused_parameter")
func process(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
@warning_ignore("unused_parameter")
func start_speaking(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
@warning_ignore("unused_parameter")
func stop_speaking(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
## [b]zip[/b]: ZIP so the plugin can save specific files inside the final ZIP.[br]
## [b]path[/b]: Path where the plugin should save specific files.[br]
## [br]
## Return a Dictionary with information to be stored in the JSON configuration.[br]
@warning_ignore("unused_parameter")
func save_plugin(zip: ZIPPacker, path: String) -> Dictionary:
	return {}


## [i](Virtual method)[/i][br]
## [br]
## [b]zip[/b]: ZIP so the plugin can load specific files inside the final ZIP.[br]
## [b]path[/b]: Path where the plugin should load specific files.[br]
## [b]data[/b]: Dictionary with information stored by the plugin in the JSON configuration.[br]
@warning_ignore("unused_parameter")
func load_plugin(zip: ZIPReader, path: String, data: Dictionary) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
func create_view() -> Control:
	return Control.new()
