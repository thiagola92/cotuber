## StateData represents one of many states which a character can have.
##
## Normally a character can have many states,
## so each one can represents one emotion (angry/sad/happy...)
class_name StateData
extends Resource


const PluginDelay := preload("res://data/plugin_data/plugins/delay.gd")

## Image to be used when not speaking.
@export var idle_image: Image = preload("res://data/state_data/template_idle.svg").get_image()

## Image to be used when speaking.
@export var speaking_image: Image = preload("res://data/state_data/template_speaking.svg").get_image()

## Shortcut to trigger this state.
@export var shortcut: InputEventKey = null

## Plugins to be used during this state.
@export var plugins: Array[PluginData] = [PluginDelay.new()]
