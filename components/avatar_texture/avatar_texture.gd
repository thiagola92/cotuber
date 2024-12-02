class_name AvatarTexture
extends Control


## Default avatar to be used when no avatar has being defined.
@export var default: Texture2D

## TextureRect which plugins and user can interact.
var clone: TextureRect

## TextureRect after image being imported, shouldn't be changed by user or plugins.
@onready var _original := $OriginalTexture


func _ready() -> void:
	_original.texture = default
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
