class_name WindowCoop
extends Control


const AvatarFriendScene := preload("res://components/avatar_friend/avatar_friend.tscn")

## Voice server to be used.
var voice_server: VoiceServer

## Current loaded character.
var _character := CharacterData.new()

## Current state index.
var _state_index := 0

@onready var _avatar := %Avatar

@onready var _friends := %Friends


# Called when scene enters the tree, so make sure that voice_server is setted.
func _ready() -> void:
	voice_server.create_user(voice_server.id, _character)
	voice_server.voice_connected.connect(_on_voice_server_voice_connected)
	voice_server.voice_disconnected.connect(_on_voice_server_voice_disconnected)
	
	_reload()


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


func _on_voice_server_voice_connected(voice_id: String) -> void:
	var avatar := AvatarFriendScene.instantiate()
	avatar.name = voice_id
	
	_friends.add_child(avatar, true)


func _on_voice_server_voice_disconnected(voice_id: String) -> void:
	for child in _friends.get_children():
		if child.name == voice_id:
			child.queue_free()
			return
