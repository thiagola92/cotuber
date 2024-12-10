class_name PluginRow
extends VBoxContainer


signal move_requested(from: int, to : int)

signal remove_requested(plugin: PluginData)

const ARROW_RIGHT := preload("res://components/plugins_popup/plugin_row/arrow_right.svg")

const ARROW_DOWN := preload("res://components/plugins_popup/plugin_row/arrow_down.svg")

var _index: int

var _plugin: PluginData

@onready var _arrow_button := %ArrowButton

@onready var _name_label := %NameLabel

@onready var _plugin_settings := $PluginSettings

@onready var _line := %Line


func _ready() -> void:
	_name_label.text = _plugin.filename()
	_plugin_settings.add_child(_plugin.create_view())


func init(index: int, plugin: PluginData):
	_plugin = plugin
	_index = index
	return self


func _get_drag_data(_at_position: Vector2) -> Variant:
	return self


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not data is PluginRow:
		return false
	
	if data == self:
		return false
	
	_line.show()
	
	if at_position.y <= size.y / 2:
		_line.position.y = -size.y - _line.size.y
	else:
		_line.position.y = 0
	
	return (data as PluginRow).is_in_group("plugin_row")


func _drop_data(at_position: Vector2, data: Variant) -> void:
	return


func _on_mouse_exited() -> void:
	_line.hide()


func _on_arrow_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_arrow_button.icon = ARROW_DOWN
		_plugin_settings.show()
	else:
		_arrow_button.icon = ARROW_RIGHT
		_plugin_settings.hide()


func _on_remove_button_pressed() -> void:
	remove_requested.emit(_plugin)
	queue_free()
