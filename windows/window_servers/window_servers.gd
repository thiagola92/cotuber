extends MarginContainer


const WindowCoopScene := preload("res://windows/window_coop/window_coop.tscn")

@onready var _tab_container := %TabContainer


func _on_network_pressed() -> void:
	_tab_container.current_tab = 0


func _on_voice_server_created(voice_server: VoiceServer) -> void:
	var window_coop: WindowCoop = WindowCoopScene.instantiate() as WindowCoop
	window_coop.add_child(voice_server)
	window_coop.voice_server = voice_server
	
	get_parent().add_child(window_coop)
	get_tree().current_scene = window_coop
	queue_free()
