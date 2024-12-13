extends PluginData


var _is_dark := false


func init(idle_texture: TextureRect, _speaking_texture: TextureRect) -> void:
	_is_dark = true
	idle_texture.modulate = idle_texture.modulate.darkened(0.3)


func create_view() -> Control:
	return Control.new()
