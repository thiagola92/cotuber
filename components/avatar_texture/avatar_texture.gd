class_name AvatarTexture
extends Control


## TextureRect which plugins and user can interact.
var clone: TextureRect

## TextureRect after image being imported, shouldn't be changed by user or plugins.
@onready var _original := $OriginalTexture


func set_texture(texture: Texture2D) -> void:
	_original.texture = texture
	_original.hide()
	
	create_clone()


## Free previous clone and create a new one.[br]
## Used when loading a character or adding/removing plugins,
## because this cases you need to reapply all plugins to the base texture.
func create_clone() -> TextureRect:
	if clone:
		clone.hide()
		clone.queue_free()
		clone = null
	
	clone = _original.duplicate()
	clone.show()
	
	add_child(clone)
	
	return clone
