extends VBoxContainer


var _plugin_data: PluginData

@onready var name_label := %NameLabel


func _ready() -> void:
	name_label.text = _plugin_data.plugin_name()


func init(plugin_data: PluginData):
	_plugin_data = plugin_data
	return self


func _on_remove_button_pressed() -> void:
	queue_free()
