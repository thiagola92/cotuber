class_name WindowSolo
extends Control


## Current loaded character.
var _character_data := CharacterData.new()

## Current state index.
var _state_index := 0

@onready var _ui := $UI

@onready var _voice_bar := %VoiceBar

@onready var _voice_server := $VoiceServerOffline

@onready var _avatar := $Avatar

@onready var _plugins_popup := $PluginsPopup


func _ready() -> void:
	_voice_server.create_user("", _character_data)


func _process(_delta: float) -> void:
	for plugin in _character_data.get_state(_state_index).plugins:
		plugin.process(
			_avatar.get_idle_texture(),
			_avatar.get_speaking_texture(),
		)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			_ui.hide()
			BackgroundColor.live = true
		NOTIFICATION_APPLICATION_FOCUS_IN:
			_ui.show()
			BackgroundColor.live = false


func _on_save_button_save_requested(path: String) -> void:
	_character_data.background_color = BackgroundColor.live_color
	
	var error := ResourceSaver.save(_character_data, path)
	
	if error:
		return ErrorPopup.show_message("WINDOW_SOLO_ERROR_SAVE_CHARACTER")


func _on_background_button_background_changed(color: Color) -> void:
	_character_data.background_color = color


func _on_voice_bar_minimum_changed(value: float) -> void:
	_character_data.minimum_volume = value


func _on_plugin_button_plugins_popup_requested() -> void:
	_plugins_popup.open(_character_data.get_state(_state_index).plugins)


func _on_plugins_popup_adding_plugin(plugin: PluginData) -> void:
	_character_data.get_state(_state_index).plugins.append(plugin)
	_avatar.reset_avatar()
	_plugins_popup.fill_plugins_list(_character_data.get_state(_state_index).plugins)


func _on_plugins_popup_removing_plugin(plugin: PluginData) -> void:
	_character_data.get_state(_state_index).plugins.erase(plugin)
	_avatar.reset_avatar()
	_plugins_popup.fill_plugins_list(_character_data.get_state(_state_index).plugins)


func _on_voice_server_offline_volume_changed(_voice_id: String, peak: float) -> void:
	_voice_bar.value = peak


func _on_voice_server_offline_voice_started(_voice_id: String) -> void:
	_avatar.show_speaking_avatar()
	
	for plugin in _character_data.get_state(_state_index).plugins:
		plugin.start_speaking(
			_avatar.get_idle_texture(),
			_avatar.get_speaking_texture(),
		)


func _on_voice_server_offline_voice_stopped(_voice_id: String) -> void:
	_avatar.show_idle_avatar()
	
	for plugin in _character_data.get_state(_state_index).plugins:
		plugin.stop_speaking(
			_avatar.get_idle_texture(),
			_avatar.get_speaking_texture(),
		)
