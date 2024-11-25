extends Button


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://windows/window_main/window_main.tscn")
