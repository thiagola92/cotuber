## StateData represents one of many states which a character can have.
##
## Normally a character can have many states,
## so each one can represents one emotion (angry/sad/happy...)
class_name StateData
extends Resource


## Image to be used when not speaking.
@export var idle_image: Image = Image.new()

## Image to be used when speaking.
@export var speaking_image: Image = Image.new()

## TODO: Shortcut to trigger this state.
@export var shortcut = null

## TODO: Plugins to be used during this state.
@export var plugins: Array[PluginData]
