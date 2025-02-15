class_name PluginData
extends Resource


@warning_ignore("unused_signal")
signal restart_requested


func filename() -> String:
	return (get_script() as Script).resource_path.get_file()


## [i](Virtual method)[/i][br]
## [br]
## [param idle_texture]: TextureRect used when user is idle.[br]
## [param speaking_texture]: TextureRect used when user is speaking.[br]
## [br]
## Called when the plugin is loaded or reloaded. Reload happens when
## user change the idle/speaking images.
@warning_ignore("unused_parameter")
func init(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
## [param idle_texture]: TextureRect used when user is idle.[br]
## [param speaking_texture]: TextureRect used when user is speaking.[br]
## [br]
## Called by the current window [method Node._process]. Use if you need
## to pay attention to changes every frame.[br]
@warning_ignore("unused_parameter")
func process(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
## [param idle_texture]: TextureRect used when user is idle.[br]
## [param speaking_texture]: TextureRect used when user is speaking.[br]
## [br]
## Called when user start speaking.[br]
## Note that both [param idle_texture] and [param speaking_texture]
## could have been changed by others plugins.
@warning_ignore("unused_parameter")
func start_speaking(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
## [param idle_texture]: TextureRect used when user is idle.[br]
## [param speaking_texture]: TextureRect used when user is speaking.[br]
## [br]
## Called when user stop speaking.[br]
## Note that both [param idle_texture] and [param speaking_texture]
## could have been changed by others plugins.
@warning_ignore("unused_parameter")
func stop_speaking(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
## [param zip]: ZIP so the plugin can save specific files inside the final ZIP.[br]
## [param path]: Path where the plugin should save specific files.[br]
## [br]
## Returns a Dictionary with information to be stored in the JSON configuration.[br]
@warning_ignore("unused_parameter")
func save_plugin(zip: ZIPPacker, path: String) -> Dictionary:
	return {}


## [i](Virtual method)[/i][br]
## [br]
## [param zip]: ZIP so the plugin can load specific files inside the final ZIP.[br]
## [param path]: Path where the plugin should load specific files.[br]
## [param data]: Dictionary with information stored by the plugin in the JSON configuration.[br]
@warning_ignore("unused_parameter")
func load_plugin(zip: ZIPReader, path: String, data: Dictionary) -> void:
	pass


## [i](Virtual method)[/i][br]
## [br]
## Called to get a Control that will appears when user open the
## plugin configuration. Use it to give your user control over the plugin settings.
func create_view() -> Control:
	return Control.new()
