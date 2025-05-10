class_name VoiceServerDiscord
extends VoiceServer


var client: DiscordppClient

var lobby_id: int

var _call: DiscordppCall


func _ready() -> void:
	id = str(client.GetCurrentUser().Id())
	_call = client.StartCall(lobby_id)
	
	_call.SetSpeakingStatusChangedCallback(_on_speaking_status_changed)
	_call.SetParticipantChangedCallback(_on_participant_changed)


func _process(_delta: float) -> void:
	Discordpp.RunCallbacks()


func _on_speaking_status_changed(user_id: int, is_playing_sound: bool) -> void:
	if is_playing_sound:
		speaking[str(user_id)] = true
		voice_started.emit(str(user_id))
	else:
		speaking[str(user_id)] = false
		voice_stopped.emit(str(user_id))


func _on_participant_changed(user_id: int, added: bool) -> void:
	if str(user_id) == id:
		return
	
	if added:
		create_user(str(user_id), CharacterData.new())
		voice_connected.emit(str(user_id))
	else:
		delete_user(str(user_id))
		voice_disconnected.emit(str(user_id))


func _on_tree_exiting() -> void:
	client.Disconnect()
	client = null
