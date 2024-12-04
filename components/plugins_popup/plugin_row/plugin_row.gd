extends VBoxContainer


signal removing_plugin(plugin: PluginData)

const ARROW_RIGHT := preload("res://components/plugins_popup/plugin_row/arrow_right.svg")

const ARROW_DOWN := preload("res://components/plugins_popup/plugin_row/arrow_down.svg")

var _plugin: PluginData

@onready var _arrow_button := %ArrowButton

@onready var _name_label := %NameLabel

@onready var _plugin_settings := $PluginSettings


func _ready() -> void:
	_name_label.text = _plugin.filename()
	_plugin_settings.add_child(_plugin.create_view())


func init(plugin: PluginData):
	_plugin = plugin
	return self


func _on_arrow_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_arrow_button.icon = ARROW_DOWN
		_plugin_settings.show()
	else:
		_arrow_button.icon = ARROW_RIGHT
		_plugin_settings.hide()


func _on_remove_button_pressed() -> void:
	removing_plugin.emit(_plugin)
	queue_free()
