extends MarginContainer


signal voice_server_created(voice_server: VoiceServer)

const VoiceServerScene := preload("res://components/voice_servers/network/voice_server_network.tscn")

@onready var _port_edit := %PortEdit

@onready var _port_error := %PortError

@onready var _start_button := %StartButton

@onready var _accept_dialog := %AcceptDialog


func _cannot_start_server() -> bool:
	return _port_error.text != ""


func _on_port_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		_port_error.text = ""
	else:
		_port_error.text = "NETWORK_CONTAINER_INVALID_PORT"
	
	_start_button.disabled = _cannot_start_server()


func _on_start_button_pressed() -> void:
	var port := int(_port_edit.text)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 32)
	
	match error:
		ERR_CANT_CREATE:
			_accept_dialog.dialog_text = "NETWORK_CONTAINER_UNKNOWN_ERROR"
			_accept_dialog.popup_centered()
			return
		ERR_ALREADY_IN_USE:
			_accept_dialog.dialog_text = "NETWORK_CONTAINER_CONNECTION_IN_USE"
			_accept_dialog.popup_centered()
			return
	
	multiplayer.multiplayer_peer = peer
	
	var voice_server := VoiceServerScene.instantiate() as VoiceServer
	
	voice_server_created.emit(voice_server)


func _on_explanation_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
