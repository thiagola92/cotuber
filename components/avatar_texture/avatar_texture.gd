extends Control


@export var default_avatar: Texture2D

## Texture which plugins and user can interact.
var clone_texture: TextureRect

## Texture after image being imported, shouldn't be changed by user or plugins.
@onready var _original_texture := $OriginalTexture


func _ready() -> void:
	_original_texture.texture = default_avatar
	_original_texture.hide()
	
	create_clone()


## Free previous clone and create a new one.[br]
## Used when loading a character or adding/removing plugins,
## because this cases you need to reapply all plugins to the base texture.
func create_clone() -> TextureRect:
	if clone_texture:
		clone_texture.hide()
		clone_texture.queue_free()
		clone_texture = null
	
	clone_texture = _original_texture.duplicate()
	clone_texture.show()
	
	add_child(clone_texture)
	
	return clone_texture
