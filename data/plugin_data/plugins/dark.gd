extends PluginData


var _is_dark := false


func start_speaking(_idle_texture: TextureRect, _speaking_texture: TextureRect) -> void:
	pass


func stop_speaking(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	if _is_dark:
		return
	
	_is_dark = true
	idle_texture.modulate = idle_texture.modulate.darkened(0.2)


func save_plugin(_zip: ZIPPacker, _path: String) -> Dictionary:
	return {
	}


func load_plugin(_zip: ZIPReader, _path: String, data: Dictionary) -> void:
	pass


func create_view() -> Control:
	return Control.new()
