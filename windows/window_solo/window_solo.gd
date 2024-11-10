extends MarginContainer


func _ready() -> void:
	BackgroundColor.live = true
	
	get_window().focus_entered.connect(show)
	get_window().focus_exited.connect(hide)


func _on_tree_exiting() -> void:
	get_window().focus_entered.disconnect(show)
	get_window().focus_exited.disconnect(hide)
