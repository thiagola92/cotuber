extends MarginContainer


signal voice_server_created(voice_server: VoiceServer)

const VoiceServerScene := preload("res://components/voice_servers/network/voice_server_network.tscn")

@onready var _ip_edit := %IPEdit

@onready var _ip_error := %IPError

@onready var _port_edit := %PortEdit

@onready var _port_error := %PortError

@onready var _start_button := %StartButton

@onready var _accept_dialog := %AcceptDialog


func _cannot_start_client() -> bool:
	return _port_error.text != "" or _ip_error.text != ""


func _on_ip_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_ip_address():
		_ip_error.text = ""
	else:
		_ip_error.text = "NETWORK_CONTAINER_INVALID_IP"
	
	_start_button.disabled = _cannot_start_client()


func _on_port_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		_port_error.text = ""
	else:
		_port_error.text = "NETWORK_CONTAINER_INVALID_PORT"
	
	_start_button.disabled = _cannot_start_client()


func _on_start_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(_ip_edit.text, int(_port_edit.text))
	
	match error:
		ERR_CANT_CREATE:
			_accept_dialog.dialog_text = "CLIENT_CONTAINER_UNKNOWN_ERROR"
			_accept_dialog.popup_centered()
			return
		ERR_ALREADY_IN_USE:
			_accept_dialog.dialog_text = "CLIENT_CONTAINER_CONNECTION_IN_USE"
			_accept_dialog.popup_centered()
			return
	
	multiplayer.multiplayer_peer = peer
	
	voice_server_created.emit(VoiceServerScene.instantiate())
