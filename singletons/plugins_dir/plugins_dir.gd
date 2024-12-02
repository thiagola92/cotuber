extends Node


const PATH := "user://plugins"

var _defaults: Array[PluginData] = [
	preload("res://data/plugin_data/plugins/plugin_delay.gd").new(),
]


func _ready() -> void:
	_make_dir()
	_create_defaults()


func _make_dir() -> void:
	var error := DirAccess.make_dir_absolute(PATH)
	
	if error and error != 32:
		push_error("Fail to create plugins directory (error: %s)" % error)


func _create_defaults() -> void:
	for plugin in _defaults:
		var filepath := "%s/%s.tres" % [PATH, plugin.plugin_name().to_snake_case()]
		var error := ResourceSaver.save(plugin, filepath, ResourceSaver.FLAG_BUNDLE_RESOURCES)
		
		if error and error != 32:
			push_error("Fail to create a default plugin: %s", plugin.plugin_name())


func get_plugins() -> Array[PluginData]:
	var dir := DirAccess.open(PATH)
	var plugins: Array[PluginData]
	
	if not dir:
		push_error("Fail to open plugins directory")
	
	for file in dir.get_files():
		var filepath := "%s/%s" % [PATH, file]
		var plugin = ResourceLoader.load(filepath, "PluginData", ResourceLoader.CACHE_MODE_IGNORE)
		
		if plugin and plugin is PluginData:
			plugins.append(plugin)
		else:
			push_error("Fail to open plugin: %s" % file)
	
	return plugins
