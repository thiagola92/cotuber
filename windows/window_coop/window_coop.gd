class_name WindowCoop
extends Control


## Current loaded character.
var _character := CharacterData.new()

var _voice_server: VoiceServer


func _ready() -> void:
	_voice_server.create_user(_voice_server.id, _character)
