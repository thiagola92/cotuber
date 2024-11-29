class_name WindowSolo
extends Control


var _character_data := CharacterData.new()

@onready var _voice_bar := %VoiceBar


func _on_save_button_save_requested(path: String) -> void:
	_character_data.background_color = BackgroundColor.live_color
	
	var error := ResourceSaver.save(_character_data, path)
	
	if error:
		return ErrorPopup.show_message("ERROR_WINDOW_SOLO_SAVE_CHARACTER")


func _on_voice_server_offline_volume_changed(voice_id: String, peak: float) -> void:
	_voice_bar.value = peak
