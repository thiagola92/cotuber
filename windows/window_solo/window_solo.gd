class_name WindowSolo
extends Control


var _character_data := CharacterData.new()

@onready var _voice_bar := %VoiceBar

@onready var _voice_server := $VoiceServerOffline


func _ready() -> void:
	_voice_server.create_user("", _character_data)


func _on_save_button_save_requested(path: String) -> void:
	_character_data.background_color = BackgroundColor.live_color
	
	var error := ResourceSaver.save(_character_data, path)
	
	if error:
		return ErrorPopup.show_message("ERROR_WINDOW_SOLO_SAVE_CHARACTER")


func _on_background_button_background_changed(color: Color) -> void:
	_character_data.background_color = color


func _on_voice_bar_minimum_changed(value: float) -> void:
	_character_data.minimum_volume = value


func _on_voice_server_offline_volume_changed(_voice_id: String, peak: float) -> void:
	_voice_bar.value = peak


func _on_voice_server_offline_voice_started(_voice_id: String) -> void:
	$IdleAvatar.hide()
	$SpeakingAvatar.show()


func _on_voice_server_offline_voice_stopped(_voice_id: String) -> void:
	$IdleAvatar.show()
	$SpeakingAvatar.hide()
