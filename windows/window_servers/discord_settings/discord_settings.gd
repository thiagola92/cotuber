extends VBoxContainer


signal voice_server_created(voice_server: VoiceServer)

var VoiceServerScene = preload("res://components/voice_servers/discord/voice_server_discord.tscn")

var client: DiscordppClient

@onready var _window_form := $WindowForm

@onready var _app_id_edit := %AppIdEdit

@onready var _lobby_edit := %LobbyEdit

@onready var _connect_error := %Error

@onready var _connect_button := %ConnectButton


func _ready() -> void:
	set_process(false)


func _can_connect(app_id: String, lobby: String) -> bool:
	_connect_error.text = ""
	
	if not app_id.is_valid_int():
		_connect_error.text = "DISCORD_SETTINGS_INVALID_APP_ID"
		return false
	
	if lobby.is_empty():
		_connect_error.text = "DISCORD_SETTINGS_INVALID_LOBBY"
		return false
	
	return true


# Block/allow user to change fields and retrying connect.
func _set_lock(locked: bool) -> void:
	_app_id_edit.editable = not locked
	_lobby_edit.editable = not locked
	_connect_button.disabled = locked


func _cancel_connection_attempt(result: DiscordppClientResult) -> void:
	_connect_error.text = "[%s] %s" % [result.ErrorCode(), result.Error()]
	client = null
	
	_set_lock(false)
	set_process(false)


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
	if client:
		return
	
	client = DiscordppClient.new()
	var code_verifier := client.CreateAuthorizationCodeVerifier()
	var args := DiscordppAuthorizationArgs.new()
	
	_connect_error.text = "..."
	_set_lock(true)
	
	args.SetClientId(int(_app_id_edit.text))
	args.SetScopes(DiscordppClient.GetDefaultPresenceScopes())
	args.SetCodeChallenge(code_verifier.Challenge())
	
	client.SetStatusChangedCallback(_on_status_changed)
	client.Authorize(args, _on_authorize_result.bind(code_verifier))

	set_process(true)

func _on_authorize_result(
	result: DiscordppClientResult,
	code: String,
	redirect_uri: String,
	code_verifier: DiscordppAuthorizationCodeVerifier
) -> void:
	if not result.Successful():
		_cancel_connection_attempt(result)
		_set_lock(false)
		return
	
	client.GetToken(
		int(_app_id_edit.text),
		code,
		code_verifier.Verifier(),
		redirect_uri,
		_on_token_result
	)
	
func _on_token_result(
	result: DiscordppClientResult,
	access_token: String,
	_refresh_token: String,
	_token_type: DiscordppAuthorizationTokenType.Enum,
	_expires_in: int,
	_scopes: String
) -> void:
	if not result.Successful():
		_cancel_connection_attempt(result)
		_set_lock(false)
		return
	
	client.UpdateToken(
		DiscordppAuthorizationTokenType.Bearer,
		access_token,
		_on_token_updated
	)


func _on_token_updated(result: DiscordppClientResult) -> void:
	if not result.Successful():
		_cancel_connection_attempt(result)
		_set_lock(false)
		return
	
	client.Connect()


func _on_status_changed(
	status: DiscordppClientStatus.Enum,
	_error: DiscordppClientError.Enum,
	_error_detail: int
) -> void:
	if status != DiscordppClientStatus.Ready:
		return
	
	client.CreateOrJoinLobby(_lobby_edit.text, _on_lobby_joined)


func _on_lobby_joined(result: DiscordppClientResult, lobbyId: int) -> void:
	if not result.Successful():
		client.Disconnect()
		_cancel_connection_attempt(result)
		_set_lock(false)
		return
	
	var voice_server := VoiceServerScene.instantiate() as VoiceServerDiscord
	voice_server.client = client
	voice_server.lobby_id = lobbyId
	
	_window_form.hide()
	voice_server_created.emit(voice_server)


func _process(_delta: float) -> void:
	Discordpp.RunCallbacks()
