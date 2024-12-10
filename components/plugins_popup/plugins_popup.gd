class_name PluginsPopup
extends Window


signal adding_plugin(plugin: PluginData)

signal move_requested(from: int, to: int)

signal remove_requested(plugin: PluginData)

const PluginRowScene := preload("res://components/plugins_popup/plugin_row/plugin_row.tscn")

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
	for index in plugins.size():
		var plugin := plugins[index]
		var plugin_row = PluginRowScene.instantiate().init(plugin, index)
		plugin_row.move_requested.connect(_on_plugin_row_move_requested)
		plugin_row.remove_requested.connect(_on_plugin_row_remove_requested)
		plugin_row.add_to_group("plugin_row")
		_plugins_list.add_child(plugin_row)


func _refresh_options() -> void:
	if not _plugin_options:
		return
	
	_plugin_options.clear()
	
	for plugin in PluginsDir.get_plugins():
		_plugin_options.add_item(plugin.filename())


func _on_close_requested() -> void:
	hide()


func _on_add_button_pressed() -> void:
	var index: int = _plugin_options.selected
	var text: String = _plugin_options.get_item_text(index)
	
	# Search plugin requested in the plugins directory.
	for plugin in PluginsDir.get_plugins():
		if plugin.filename() == text:
			adding_plugin.emit(plugin.duplicate())
			return


func _on_plugin_row_move_requested(from: int, to: int) -> void:
	move_requested.emit(from, to)


func _on_plugin_row_remove_requested(plugin: PluginData) -> void:
	remove_requested.emit(plugin)
