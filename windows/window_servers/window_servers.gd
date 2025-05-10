extends MarginContainer


const WindowCoopScene := preload("res://windows/window_coop/window_coop.tscn")

@onready var _tab_container := %TabContainer


func change_to_window_coop(voice_server: VoiceServer) -> void:
	var window_coop: WindowCoop = WindowCoopScene.instantiate() as WindowCoop
	window_coop.add_child(voice_server)
	window_coop.voice_server = voice_server
	
	get_parent().add_child(window_coop)
	get_tree().current_scene = window_coop
	queue_free()


func _on_network_pressed() -> void:
	_tab_container.current_tab = 1


func _on_discord_pressed() -> void:
	_tab_container.current_tab = 2


func _on_network_voice_server_created(voice_server: VoiceServer) -> void:
	change_to_window_coop(voice_server)


func _on_discord_voice_server_created(voice_server: VoiceServer) -> void:
	change_to_window_coop(voice_server)
