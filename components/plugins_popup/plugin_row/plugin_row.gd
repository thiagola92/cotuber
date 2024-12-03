extends VBoxContainer


signal removing_plugin(plugin: PluginData)

const ARROW_RIGHT := preload("res://components/plugins_popup/plugin_row/arrow_right.svg")

const ARROW_DOWN := preload("res://components/plugins_popup/plugin_row/arrow_down.svg")

var _plugin: PluginData

@onready var arrow_button := %ArrowButton

@onready var name_label := %NameLabel

@onready var plugin_settings := %PluginSettings


func _ready() -> void:
	name_label.text = _plugin.plugin_name()
	_add_settings()


func init(plugin: PluginData):
	_plugin = plugin
	return self


func _add_settings() -> void:
	for property in _plugin.get_script().get_script_property_list():
		if property["usage"] & PROPERTY_USAGE_STORAGE:
			var property_name: String = property["name"]
			var property_type: int = property["type"]
			var label := Label.new()
			var line_edit := LineEdit.new()
			
			label.text = property_name.capitalize()
			line_edit.text = type_convert(_plugin.get(property_name), TYPE_STRING)
			line_edit.text_changed.connect(
				func(text: String):
					_plugin.set(property_name, type_convert(text, property_type))
			)
			
			plugin_settings.add_child(label)
			plugin_settings.add_child(line_edit)


func _on_arrow_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		arrow_button.icon = ARROW_DOWN
		plugin_settings.show()
	else:
		arrow_button.icon = ARROW_RIGHT
		plugin_settings.hide()


func _on_remove_button_pressed() -> void:
	removing_plugin.emit(_plugin)
	queue_free()
