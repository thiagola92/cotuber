class_name WindowCoop
extends Control


const AvatarFriendScene := preload("res://components/avatar_friend/avatar_friend.tscn")

## Voice server to be used.
var voice_server: VoiceServer

## Current loaded character.
var _character := CharacterData.new()

## Current state index.
var _state_index := 0

@onready var _visibility_button := $%VisibilityButton

@onready var _ui := $UI

@onready var _avatar := %Avatar

@onready var _friends := %Friends


# Called when scene enters the tree, so make sure that voice_server is setted.
func _ready() -> void:
	OSShortcut.target_focus = self
	
	voice_server.create_user(voice_server.id, _character)
	voice_server.voice_connected.connect(_on_voice_server_voice_connected)
	voice_server.voice_disconnected.connect(_on_voice_server_voice_disconnected)
	voice_server.voice_started.connect(_on_voice_server_voice_started)
	voice_server.voice_stopped.connect(_on_voice_server_voice_stopped)
	_reload_yourself()
	_reload_friends()


func _process(_delta: float) -> void:
	_process_yourself()
	_process_friends()


func _process_yourself() -> void:
	for plugin in _character.states[_state_index].plugins:
		plugin.process(_avatar.get_idle_texture(), _avatar.get_speaking_texture())


func _process_friends() -> void:
	for friend: AvatarFriend in _friends.get_children():
		if friend.name not in voice_server.users:
			continue
		
		var character := voice_server.users[friend.name]
		
		# NOTE: Friends avatar only use the first state.
		for plugin in character.states[0].plugins:
			plugin.process(
				friend.avatar.get_idle_texture(),
				friend.avatar.get_speaking_texture()
			)


func _unhandled_key_input(event: InputEvent) -> void:
	event = event as InputEventKey
	
	if event.pressed:
		_unhandled_key_press(event)


func _unhandled_key_press(event: InputEventKey) -> void:
	for index in _character.states.size():
		var state = _character.states[index]
		
		if state.shortcut and state.shortcut.as_text() == event.as_text():
			_state_index = index
			_reload_yourself()
			return


func _reload_yourself() -> void:
	var idle_texture := ImageTexture.create_from_image(
		_character.states[_state_index].idle_image
	)
	
	var speaking_texture := ImageTexture.create_from_image(
		_character.states[_state_index].speaking_image
	)
	
	# Update every place where images are used.
	_avatar.set_textures(idle_texture, speaking_texture)
	_avatar.show_idle_avatar()
	
	# Initialize all plugins.
	for plugin in _character.states[_state_index].plugins:
		plugin.init(_avatar.get_idle_texture(), _avatar.get_speaking_texture())


func _reload_friends() -> void:
	for friend: AvatarFriend in _friends.get_children():
		if friend.name not in voice_server.users:
			continue
		
		var character := voice_server.users[friend.name]
		
		# NOTE: Friends avatar only use the first state.
		var idle_texture := ImageTexture.create_from_image(
			character.states[0].idle_image
		)
		
		var speaking_texture := ImageTexture.create_from_image(
			character.states[0].speaking_image
		)
	
		# Update every place where images are used.
		friend.avatar.set_textures(idle_texture, speaking_texture)
		friend.avatar.show_idle_avatar()
	
		# Initialize all plugins.
		for plugin in character.states[0].plugins:
			plugin.init(
				friend.avatar.get_idle_texture(),
				friend.avatar.get_speaking_texture()
			)


func _on_load_button_character_loaded(character: CharacterData) -> void:
	_character = character
	_state_index = 0
	voice_server.users[voice_server.id] = _character
	BackgroundColor.live_color = _character.background_color
	
	_reload_yourself()


func _on_visibility_button_pressed() -> void:
	_ui.hide()
	_avatar.hide_tools()
	_visibility_button.show_canvas()
	
	for friend: AvatarFriend in _friends.get_children():
		friend.hide_tools()
	
	BackgroundColor.live = true


func _on_visibility_button_canvas_double_clicked() -> void:
	_ui.show()
	_avatar.show_tools()
	_visibility_button.hide_canvas()
	
	for friend: AvatarFriend in _friends.get_children():
		friend.show_tools()
	
	BackgroundColor.live = false


func _on_avatar_double_clicked() -> void:
	_on_visibility_button_canvas_double_clicked()


func _on_friend_load_button_character_loaded(character: CharacterData, voice_id: String) -> void:
	voice_server.users[voice_id] = character
	_reload_friends()


func _on_voice_server_voice_connected(voice_id: String) -> void:
	var friend := AvatarFriendScene.instantiate()
	friend.name = voice_id
	
	friend.character_loaded.connect(
		_on_friend_load_button_character_loaded.bind(voice_id)
	)
	
	friend.double_clicked.connect(
		_on_visibility_button_canvas_double_clicked
	)
	
	_friends.add_child(friend, true)
	_reload_friends()


func _on_voice_server_voice_disconnected(voice_id: String) -> void:
	for friend in _friends.get_children():
		if friend.name == voice_id:
			friend.queue_free()
			return


func _on_voice_server_voice_started(voice_id: String) -> void:
	if voice_server.id == voice_id:
		_on_your_voice_started()
	else:
		_on_friend_voice_started(_friends.get_node(voice_id))


func _on_your_voice_started() -> void:
	_avatar.show_speaking_avatar()
	
	for plugin in _character.states[_state_index].plugins:
		plugin.start_speaking(_avatar.get_idle_texture(), _avatar.get_speaking_texture())


func _on_friend_voice_started(friend: Variant) -> void:
	if not friend:
		return
	
	friend.avatar.show_speaking_avatar()
	
	var character := voice_server.users[friend.name]
	
	for plugin in character.states[0].plugins:
		plugin.start_speaking(
			friend.avatar.get_idle_texture(),
			friend.avatar.get_speaking_texture()
		)


func _on_voice_server_voice_stopped(voice_id: String) -> void:
	if voice_server.id == voice_id:
		_on_your_voice_stopped()
	else:
		_on_friend_voice_stopped(_friends.get_node(voice_id))


func _on_your_voice_stopped() -> void:
	_avatar.show_idle_avatar()
	
	for plugin in _character.states[_state_index].plugins:
		plugin.stop_speaking(_avatar.get_idle_texture(), _avatar.get_speaking_texture())


func _on_friend_voice_stopped(friend: Variant) -> void:
	if not friend:
		return
	
	friend.avatar.show_idle_avatar()
	
	var character := voice_server.users[friend.name]
	
	for plugin in character.states[0].plugins:
		plugin.stop_speaking(
			friend.avatar.get_idle_texture(),
			friend.avatar.get_speaking_texture()
		)
