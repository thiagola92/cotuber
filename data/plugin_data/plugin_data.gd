class_name PluginData
extends Resource


## Virtual method
func plugin_name() -> String:
	return "NOT IMPLEMENTED"


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
