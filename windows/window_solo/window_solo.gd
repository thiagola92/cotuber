extends MarginContainer


@onready var _top_container := %TopContainer

@onready var _avatar_texture := %AvatarTexture


func _ready() -> void:
	BackgroundColor.live = true
	
	_avatar_texture.hide_resizers()
	
	get_window().focus_entered.connect(_top_container.show)
	get_window().focus_exited.connect(_top_container.hide)


func _on_tree_exiting() -> void:
	get_window().focus_entered.disconnect(_top_container.show)
	get_window().focus_exited.disconnect(_top_container.hide)
