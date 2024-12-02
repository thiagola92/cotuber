class_name PluginsPopup
extends Window


const PluginRow := preload("res://components/plugins_popup/plugin_row/PluginRow.tscn")


@onready var _options := %Options

@onready var _plugins_list := %PluginsList


func _ready() -> void:
	hide()


func open(plugins: Array[PluginData]) -> void:
	_refresh_options()
	_clear_list()
	_fill_list(plugins)
	popup_centered()


func _refresh_options() -> void:
	_options.clear()
	
	for plugin in PluginsDir.get_plugins():
		_options.add_item(plugin.plugin_name())


func _clear_list() -> void:
	for child in _plugins_list.get_children():
		_plugins_list.remove_child(child)


func _fill_list(plugins: Array[PluginData]) -> void:
	for plugin in plugins:
		add_to_list(plugin)


func add_to_list(plugin: PluginData) -> void:
	var node: Node = PluginRow.instantiate().init(plugin)
	_plugins_list.add_child(node)


func _on_close_requested() -> void:
	hide()


func _on_add_button_pressed() -> void:
	pass
