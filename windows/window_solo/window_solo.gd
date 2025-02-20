class_name WindowSolo
extends Control


## Current loaded character.
var _character := CharacterData.new()

## Current state index.
var _state_index := 0

@onready var _ui := $UI

@onready var _save_button := %SaveButton

@onready var _shortcut_button := %ShortcutButton

@onready var _states_menu := %StatesMenu

@onready var _idle_avatar_button := %IdleAvatarButton

@onready var _voice_bar := %VoiceBar

@onready var _speaking_avatar_button := %SpeakingAvatarButton

@onready var _visibility_button := %VisibilityButton

@onready var _plugins_popup := $PluginsPopup

@onready var _voice_server := $VoiceServerOffline

@onready var _avatar := %Avatar


func _ready() -> void:
	_character.image_position = _avatar.global_position
	_voice_server.create_user(_voice_server.id, _character)
	
	_reload()


func _process(_delta: float) -> void:
	for plugin in _character.states[_state_index].plugins:
		plugin.process(_avatar.get_idle_texture(), _avatar.get_speaking_texture())


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		_unhandled_key_press(event as InputEventKey)


func _unhandled_key_press(event: InputEventKey) -> void:
	for index in _character.states.size():
		var state = _character.states[index]
		
		if state.shortcut and state.shortcut.as_text() == event.as_text():
			_state_index = index
			_reload()
			return


func _reload() -> void:
	var state: StateData = _character.states[_state_index]
	
	var idle_texture := ImageTexture.create_from_image(
		_character.states[_state_index].idle_image
	)
	
	var speaking_texture := ImageTexture.create_from_image(
		_character.states[_state_index].speaking_image
	)
	
	# Update every place where images are used.
	_idle_avatar_button.icon = idle_texture
	_speaking_avatar_button.icon = speaking_texture
	_avatar.set_textures(idle_texture, speaking_texture)
	_avatar.set_avatar_size(_character.image_size)
	_avatar.show_idle_avatar()
	_states_menu.fill_states_list(_character.states, _state_index)
	_avatar.global_position = _character.image_position
	
	# Initialize all plugins.
	for plugin in state.plugins:
		plugin.init(_avatar.get_idle_texture(), _avatar.get_speaking_texture())
	
	# Reload others state settings.
	_shortcut_button.state_shortcut = state.shortcut


func _update_idle_image(image: Image) -> void:
	_character.states[_state_index].idle_image = image
	
	_reload()


func _update_speaking_image(image: Image) -> void:
	_character.states[_state_index].speaking_image = image
	
	_reload()


func _on_load_button_character_loaded(character: CharacterData) -> void:
	_character = character
	_state_index = 0
	_voice_server.users[_voice_server.id] = _character
	BackgroundColor.live_color = _character.background_color
	
	_reload()
	
	# Reaload windows/popups in case they are visible.
	_plugins_popup.reload_plugins_list(_character.states[_state_index].plugins)


func _on_save_button_save_requested(path: String) -> void:
	_save_button.save(_character, path)


func _on_background_button_background_changed(color: Color) -> void:
	_character.background_color = color


func _on_shortcut_button_shortcut_changed(event: InputEventKey) -> void:
	_character.states[_state_index].shortcut = event


func _on_states_menu_move_requested(from: int, to: int) -> void:
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
	
	_reload()


func _on_states_menu_create_requested() -> void:
	var clone := _character.states[_state_index].duplicate()
	_character.states.append(clone)
	_state_index = _character.states.size() - 1
	
	_reload()
	
	# Reaload windows/popups in case they are visible.
	_plugins_popup.reload_plugins_list(_character.states[_state_index].plugins)


func _on_states_menu_pressed(index: int) -> void:
	_state_index = index
	
	_reload()
	
	# Reaload windows/popups in case they are visible.
	_plugins_popup.reload_plugins_list(_character.states[_state_index].plugins)


func _on_visibility_button_pressed() -> void:
	_ui.hide()
	_avatar.hide_tools()
	_visibility_button.show_canvas()
	
	BackgroundColor.live = true


func _on_visibility_button_canvas_double_clicked() -> void:
	_ui.show()
	_avatar.show_tools()
	_visibility_button.hide_canvas()
	
	BackgroundColor.live = false


func _on_idle_avatar_button_image_received(image: Image) -> void:
	_character.states[_state_index].idle_image = image
	
	_reload()


func _on_voice_bar_minimum_changed(value: float) -> void:
	_character.minimum_volume = value


func _on_speaking_avatar_button_image_received(image: Image) -> void:
	_character.states[_state_index].speaking_image = image
	
	_reload()


func _on_plugin_button_plugins_popup_requested() -> void:
	_plugins_popup.open(_character.states[_state_index].plugins)


func _on_plugins_popup_adding_plugin(plugin: PluginData) -> void:
	_character.states[_state_index].plugins.append(plugin)
	
	_reload()
	
	# Reaload windows/popups in case they are visible.
	_plugins_popup.reload_plugins_list(_character.states[_state_index].plugins)


func _on_plugins_popup_move_requested(from: int, to: int) -> void:
	var plugins := _character.states[_state_index].plugins
	
	plugins.insert(to, plugins[from])
	
	if from < to:
		# When inserted in front of "from" position,
		# the "from" position is not affected by reorder.
		plugins.remove_at(from)
	else:
		# When inserted behind the current position,
		# the "from" position will shift one position.
		plugins.remove_at(from + 1)
	
	_reload()


func _on_plugins_popup_remove_requested(plugin: PluginData) -> void:
	_character.states[_state_index].plugins.erase(plugin)
	
	_reload()
	
	# Reaload windows/popups in case they are visible.
	_plugins_popup.reload_plugins_list(_character.states[_state_index].plugins)


func _on_plugins_popup_restart_requested() -> void:
	_reload()


func _on_voice_server_offline_volume_changed(_voice_id: String, peak: float) -> void:
	_voice_bar.value = peak


func _on_voice_server_offline_voice_started(_voice_id: String) -> void:
	_avatar.show_speaking_avatar()
	
	for plugin in _character.states[_state_index].plugins:
		plugin.start_speaking(_avatar.get_idle_texture(), _avatar.get_speaking_texture())


func _on_voice_server_offline_voice_stopped(_voice_id: String) -> void:
	_avatar.show_idle_avatar()
	
	for plugin in _character.states[_state_index].plugins:
		plugin.stop_speaking(_avatar.get_idle_texture(), _avatar.get_speaking_texture())


func _on_avatar_double_clicked() -> void:
	_on_visibility_button_canvas_double_clicked()


func _on_avatar_dragged() -> void:
	_character.image_position = _avatar.global_position
	_character.image_size = _avatar.size
