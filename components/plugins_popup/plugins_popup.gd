class_name PluginsPopup
extends Window


signal adding_plugin(plugin: PluginData)

signal removing_plugin(plugin: PluginData)

const PluginRow := preload("res://components/plugins_popup/plugin_row/plugin_row.tscn")

@onready var _plugin_options := %PluginOptions

@onready var _plugins_list := %PluginsList


func _ready() -> void:
	hide()


func open(plugins: Array[PluginData]) -> void:
	_refresh_options()
	fill_plugins_list(plugins)
	popup_centered()


func fill_plugins_list(plugins: Array[PluginData]) -> void:
	# Clear before filling.
	for child in _plugins_list.get_children():
		_plugins_list.remove_child(child)
	
	# Fill with all used plugins.
	for plugin in plugins:
		var plugin_row = PluginRow.instantiate().init(plugin)
		plugin_row.removing_plugin.connect(_on_plugin_row_removing_plugin)
		_plugins_list.add_child(plugin_row)


func _refresh_options() -> void:
	if not _plugin_options:
		return
	
	_plugin_options.clear()
	
	for plugin in PluginsDir.get_plugins():
		_plugin_options.add_item(plugin.plugin_name())


func _on_close_requested() -> void:
	hide()


func _on_add_button_pressed() -> void:
	var index: int = _plugin_options.selected
	var plugin_name: String = _plugin_options.get_item_text(index)
	
	# Search plugin requested in the plugins directory.
	for plugin in PluginsDir.get_plugins():
		if plugin.plugin_name() == plugin_name:
			adding_plugin.emit(plugin.duplicate())
			return


func _on_plugin_row_removing_plugin(plugin: PluginData) -> void:
	removing_plugin.emit(plugin)
