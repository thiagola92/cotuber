class_name WindowSolo
extends Control


## Current loaded character.
var _character := CharacterData.new()

## Current state index.
var _state_index := 0

@onready var _ui := $UI

@onready var _save_button := %SaveButton

@onready var _states_menu := %StatesMenu

@onready var _idle_avatar_button := %IdleAvatarButton

@onready var _voice_bar := %VoiceBar

@onready var _speaking_avatar_button := %SpeakingAvatarButton

@onready var _visibility_button := %VisibilityButton

@onready var _plugins_popup := $PluginsPopup

@onready var _voice_server := $VoiceServerOffline

@onready var _avatar := $Avatar


func _ready() -> void:
	_voice_server.create_user("", _character)
	_update_idle_image(_character.states[_state_index].idle_image)
	_update_speaking_image(_character.states[_state_index].speaking_image)


func _process(_delta: float) -> void:
	for plugin in _character.states[_state_index].plugins:
		plugin.process(
			_avatar.get_idle_texture(),
			_avatar.get_speaking_texture(),
		)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			if _visibility_button.button_pressed:
				_ui.hide()
			
			BackgroundColor.live = true
		NOTIFICATION_APPLICATION_FOCUS_IN:
			if _visibility_button.button_pressed:
				_ui.show()
			
			BackgroundColor.live = false


func _update_idle_image(image: Image) -> void:
	var texture := ImageTexture.create_from_image(image)
	
	_character.states[_state_index].idle_image = image
	_idle_avatar_button.icon = texture
	_avatar.set_idle_texture(texture)
	_states_menu.fill_states_list(_character.states, _state_index)
	_plugins_popup.fill_plugins_list(_character.states[_state_index].plugins)


func _update_speaking_image(image: Image) -> void:
	var texture := ImageTexture.create_from_image(image)
	
	_character.states[_state_index].speaking_image = image
	_speaking_avatar_button.icon = texture
	_avatar.set_speaking_texture(texture)
	_states_menu.fill_states_list(_character.states, _state_index)
	_plugins_popup.fill_plugins_list(_character.states[_state_index].plugins)


func _on_load_button_character_loaded(character: CharacterData) -> void:
	_character = character
	_state_index = 0
	BackgroundColor.live_color = _character.background_color
	
	_update_idle_image(_character.states[_state_index].idle_image)
	_update_speaking_image(_character.states[_state_index].speaking_image)
	_states_menu.fill_states_list(_character.states, _state_index)
	_plugins_popup.fill_plugins_list(_character.states[_state_index].plugins)


func _on_save_button_save_requested(path: String) -> void:
	_save_button.save(_character, path)


func _on_background_button_background_changed(color: Color) -> void:
	_character.background_color = color


func _on_states_menu_switch_requested(from: int, to: int) -> void:
	var state := _character.states[_state_index]
	
	_character.states.insert(to, _character.states[from])
	
	if from < to:
		# When inserted in front of "from" position,
		# the "from" position is not affected by reorder.
		_character.states.remove_at(from)
	else:
		# When inserted behind the current position,
		# the "from" position will shift one position.
		_character.states.remove_at(from + 1)
	
	_state_index = _character.states.find(state)
	
	_states_menu.fill_states_list(_character.states, _state_index)


func _on_states_menu_create_requested() -> void:
	var clone := _character.states[_state_index].duplicate()
	_character.states.append(clone)
	_state_index = _character.states.size() - 1
	
	_update_idle_image(_character.states[_state_index].idle_image)
	_update_speaking_image(_character.states[_state_index].speaking_image)
	_states_menu.fill_states_list(_character.states, _state_index)
	_plugins_popup.fill_plugins_list(_character.states[_state_index].plugins)


func _on_states_menu_pressed(index: int) -> void:
	_state_index = index
	
	_update_idle_image(_character.states[_state_index].idle_image)
	_update_speaking_image(_character.states[_state_index].speaking_image)
	_states_menu.fill_states_list(_character.states, _state_index)
	_plugins_popup.fill_plugins_list(_character.states[_state_index].plugins)


func _on_idle_avatar_button_image_received(image: Image) -> void:
	_update_idle_image(image)


func _on_voice_bar_minimum_changed(value: float) -> void:
	_character.minimum_volume = value


func _on_speaking_avatar_button_image_received(image: Image) -> void:
	_update_speaking_image(image)


func _on_plugin_button_plugins_popup_requested() -> void:
	_plugins_popup.open(_character.states[_state_index].plugins)


func _on_plugins_popup_adding_plugin(plugin: PluginData) -> void:
	_character.states[_state_index].plugins.append(plugin)
	_avatar.reset_avatar()
	_plugins_popup.fill_plugins_list(_character.states[_state_index].plugins)


func _on_plugins_popup_removing_plugin(plugin: PluginData) -> void:
	_character.states[_state_index].plugins.erase(plugin)
	_avatar.reset_avatar()
	_plugins_popup.fill_plugins_list(_character.states[_state_index].plugins)


func _on_voice_server_offline_volume_changed(_voice_id: String, peak: float) -> void:
	_voice_bar.value = peak


func _on_voice_server_offline_voice_started(_voice_id: String) -> void:
	_avatar.show_speaking_avatar()
	
	for plugin in _character.states[_state_index].plugins:
		plugin.start_speaking(
			_avatar.get_idle_texture(),
			_avatar.get_speaking_texture(),
		)


func _on_voice_server_offline_voice_stopped(_voice_id: String) -> void:
	_avatar.show_idle_avatar()
	
	for plugin in _character.states[_state_index].plugins:
		plugin.stop_speaking(
			_avatar.get_idle_texture(),
			_avatar.get_speaking_texture(),
		)
