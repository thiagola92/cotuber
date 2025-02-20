extends Button


func _on_pressed() -> void:
	BackgroundColor.live_color = BackgroundColor.default_color
	
	get_tree().change_scene_to_file("res://windows/window_main/window_main.tscn")
