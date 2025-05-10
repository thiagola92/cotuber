extends VBoxContainer


signal voice_server_created(voice_server: VoiceServer)

var VoiceServerScene = preload("res://components/voice_servers/network/voice_server_network.tscn")

@onready var _window_form := $WindowForm

@onready var _server_port_edit := %ServerPortEdit

@onready var _server_error := %ServerError

@onready var _host_button := %HostButton

@onready var _client_ip_edit := %ClientIPEdit

@onready var _client_port_edit := %ClientPortEdit

@onready var _client_error := %ClientError

@onready var _connect_button := %ConnectButton


func _can_host(port: String) -> bool:
	_server_error.text = ""
	
	if not port.is_valid_int():
		_server_error.text = "NETWORK_INVALID_PORT"
		return false
	
	return true


func _can_connect(ip: String, port: String) -> bool:
	_client_error.text = ""
	
	if not ip.is_valid_ip_address():
		_client_error.text = "NETWORK_INVALID_IP"
		return false
	
	if not port.is_valid_int():
		_client_error.text = "NETWORK_INVALID_PORT"
		return false
	
	return true


func _on_select_pressed() -> void:
	_window_form.popup_centered()


func _on_window_form_close_requested() -> void:
	_window_form.hide()


func _on_window_form_focus_exited() -> void:
	_window_form.hide()


func _on_server_port_edit_text_changed(new_text: String) -> void:
	_host_button.disabled = not _can_host(new_text)


func _on_host_button_pressed() -> void:
	var port := int(_server_port_edit.text)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 32)
	
	_server_error.text = "..."
	
	match error:
		ERR_CANT_CREATE:
			_server_error.text = "NETWORK_SETTINGS_UNKNOWN_ERROR"
			return
		ERR_ALREADY_IN_USE:
			_server_error.text = "NETWORK_SETTINGS_CONNECTION_IN_USE"
			return
	
	multiplayer.multiplayer_peer = peer
	
	var voice_server := VoiceServerScene.instantiate() as VoiceServerNetwork
	
	_window_form.hide()
	voice_server_created.emit(voice_server)


func _on_client_ip_edit_text_changed(new_text: String) -> void:
	_connect_button.disabled = not _can_connect(new_text, _client_port_edit.text)


func _on_client_port_edit_text_changed(new_text: String) -> void:
	_connect_button.disabled = not _can_connect(_client_ip_edit.text, new_text)


func _on_connect_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(_client_ip_edit.text, int(_client_port_edit.text))
	
	_client_error.text = "..."
	
	match error:
		ERR_CANT_CREATE:
			_client_error.text = "NETWORK_SETTINGS_UNKNOWN_ERROR"
			return
		ERR_ALREADY_IN_USE:
			_client_error.text = "NETWORK_SETTINGS_CONNECTION_IN_USE"
			return
	
	multiplayer.multiplayer_peer = peer
	
	_window_form.hide()
	voice_server_created.emit(VoiceServerScene.instantiate())
