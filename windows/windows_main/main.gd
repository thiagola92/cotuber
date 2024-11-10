extends MarginContainer


func _ready() -> void:
	BackgroundColor.live = false


func _on_maker_button_pressed() -> void:
	get_tree().change_scene_to_file("res://windows/window_maker/window_maker.tscn")


func _on_solo_button_pressed() -> void:
	get_tree().change_scene_to_file("res://windows/window_solo/window_solo.tscn")


func _on_coop_button_pressed() -> void:
	pass # Replace with function body.
