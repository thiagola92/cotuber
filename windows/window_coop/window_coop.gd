class_name WindowCoop
extends Control


const AvatarFriendScene := preload("res://components/avatar_friend/avatar_friend.tscn")

## Voice server to be used.
var voice_server: VoiceServer

## Current loaded character.
var _character := CharacterData.new()

## Current state index.
var _state_index := 0

@onready var _ui := $UI

@onready var _avatar := %Avatar

@onready var _friends := %Friends


# Called when scene enters the tree, so make sure that voice_server is setted.
func _ready() -> void:
	voice_server.create_user(voice_server.id, _character)
	voice_server.voice_connected.connect(_on_voice_server_voice_connected)
	voice_server.voice_disconnected.connect(_on_voice_server_voice_disconnected)
	
	_reload()
	_reload_friends()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			_ui.hide()
			_avatar.hide_tools()
			
			for friend: AvatarFriend in _friends.get_children():
				friend.hide_tools()
			
			BackgroundColor.live = true
		NOTIFICATION_APPLICATION_FOCUS_IN:
			_ui.show()
			_avatar.show_tools()
			
			for friend: AvatarFriend in _friends.get_children():
				friend.show_tools()
			
			BackgroundColor.live = false


func _reload() -> void:
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


func _on_voice_server_voice_connected(voice_id: String) -> void:
	var avatar := AvatarFriendScene.instantiate()
	avatar.name = voice_id
	
	_friends.add_child(avatar, true)
	_reload_friends()


func _on_voice_server_voice_disconnected(voice_id: String) -> void:
	for friend in _friends.get_children():
		if friend.name == voice_id:
			friend.queue_free()
			return
