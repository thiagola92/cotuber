extends MarginContainer


signal voice_server_created(voice_server: VoiceServer)

@onready var _tab_container := %TabContainer


func _on_server_button_pressed() -> void:
	_tab_container.current_tab = 0


func _on_client_button_pressed() -> void:
	_tab_container.current_tab = 1


func _on_voice_server_created(voice_server: VoiceServer) -> void:
	voice_server_created.emit(voice_server)
