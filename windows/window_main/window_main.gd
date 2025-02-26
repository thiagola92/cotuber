extends MarginContainer


@onready var _coop := %Coop


func _ready() -> void:
	if OS.get_name() == "Web":
		_coop.hide()


func _on_solo_button_pressed() -> void:
	get_tree().change_scene_to_file("res://windows/window_solo/window_solo.tscn")


func _on_coop_button_pressed() -> void:
	get_tree().change_scene_to_file("res://windows/window_servers/window_servers.tscn")
