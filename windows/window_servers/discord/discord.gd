extends VBoxContainer


signal voice_server_created(voice_server: VoiceServer)

@onready var _window_form := $WindowForm

@onready var _app_id_edit := %AppIdEdit

@onready var _lobby_edit := %LobbyEdit

@onready var _error := %Error

@onready var _connect_button := %ConnectButton


func _can_connect(app_id: String, lobby: String) -> bool:
	_error.text = ""
	
	if not app_id.is_valid_int():
		_error.text = "DISCORD_INVALID_APP_ID"
		return false
	
	if lobby.is_empty():
		_error.text = "DISCORD_INVALID_LOBBY"
		return false
	
	return true


func _on_select_pressed() -> void:
	_window_form.popup_centered()


func _on_window_form_close_requested() -> void:
	_window_form.hide()


func _on_window_form_focus_exited() -> void:
	_window_form.hide()


func _on_app_id_edit_text_changed(new_text: String) -> void:
	_connect_button.disabled = not _can_connect(new_text, _lobby_edit.text)


func _on_lobby_edit_text_changed(new_text: String) -> void:
	_connect_button.disabled = not _can_connect(_app_id_edit.text, new_text)


func _on_connect_button_pressed() -> void:
	pass # Replace with function body.
