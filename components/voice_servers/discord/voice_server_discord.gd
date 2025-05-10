class_name VoiceServerDiscord
extends VoiceServer


var client: DiscordppClient

var lobby_id: int

var _call: DiscordppCall


func _ready() -> void:
	_call = client.StartCall(lobby_id)
	
	_call.SetParticipantChangedCallback(_on_participant_changed)
	_call.SetSpeakingStatusChangedCallback(_on_speaking_status_changed)


func _on_participant_changed(user_id: int, added: bool) -> void:
	print("user: %s\nadded: %s" % [user_id, added])


func _on_speaking_status_changed(user_id: int, isPlayingSound: bool) -> void:
	print("user: %s\nspeaking: %s" % [user_id, isPlayingSound])


func _on_tree_exiting() -> void:
	client.Disconnect()
	client = null


func _process(_delta: float) -> void:
	Discordpp.RunCallbacks()
