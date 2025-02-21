class_name AvatarTexture
extends Control


## TextureRect which plugins and user can interact.
var clone: TextureRect

## TextureRect after image being imported, shouldn't be changed by user or plugins.
@onready var _original := $OriginalTexture

## Nodes that holds the clone and any extra nodes that plugins would want to add.
@onready var _clone_area: Control = $CloneArea


func set_texture(texture: Texture2D) -> void:
	_original.texture = texture
	_original.hide()
	_clone_area.show()
	create_clone()


func update_size(s: Vector2) -> void:
	if clone:
		_original.size = s
		create_clone()


## Free previous clone and create a new one.[br]
## Used when loading a character or adding/removing plugins,
## because this cases you need to reapply all plugins to the base texture.
func create_clone() -> TextureRect:
	var was_visible: bool = true
	
	if clone:
		was_visible = clone.visible
		
		for child in _clone_area.get_children():
			child.hide()
			child.queue_free()
	
	clone = _original.duplicate()
	clone.visible = was_visible
	
	_clone_area.add_child(clone)
	
	return clone
