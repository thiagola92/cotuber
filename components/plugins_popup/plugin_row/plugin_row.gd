class_name PluginRow
extends VBoxContainer


signal removing_plugin(plugin: PluginData)

const ARROW_RIGHT := preload("res://components/plugins_popup/plugin_row/arrow_right.svg")

const ARROW_DOWN := preload("res://components/plugins_popup/plugin_row/arrow_down.svg")

var _plugin: PluginData

@onready var arrow_button := %ArrowButton

@onready var name_label := %NameLabel


func _ready() -> void:
	name_label.text = _plugin.plugin_name()


func init(plugin: PluginData):
	_plugin = plugin
	return self


func _on_arrow_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		arrow_button.icon = ARROW_DOWN
	else:
		arrow_button.icon = ARROW_RIGHT


func _on_remove_button_pressed() -> void:
	removing_plugin.emit(_plugin)
	queue_free()
