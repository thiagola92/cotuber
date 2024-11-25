extends MarginContainer


func _on_solo_button_pressed() -> void:
	get_tree().change_scene_to_file("res://windows/window_solo/window_solo.tscn")


func _on_coop_button_pressed() -> void:
	get_tree().change_scene_to_file("res://windows/window_coop/window_coop.tscn")
