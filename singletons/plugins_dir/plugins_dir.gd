extends Node


const PATH := "user://plugins"

var _defaults: Array[PluginData] = [
	preload("res://data/plugin_data/plugins/delay.gd").new(),
	preload("res://data/plugin_data/plugins/dark.gd").new(),
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
		var filename := plugin.filename()
		var filepath := "%s/%s" % [PATH, filename]
		var error := ResourceSaver.save(plugin.get_script(), filepath)
		
		if error and error != 32:
			push_error("Fail to create a default plugin: %s" % filename)


func get_plugins() -> Array[PluginData]:
	var dir := DirAccess.open(PATH)
	var plugins: Array[PluginData]
	
	if not dir:
		push_error("Fail to open plugins directory")
	
	for file in dir.get_files():
		var filepath := "%s/%s" % [PATH, file]
		var script = ResourceLoader.load(filepath, "Script")
		var plugin: PluginData = PluginData.new()
		
		if not script or not script is Script:
			push_error("Fail to open plugin as Script: %s" % file)
			continue
		
		plugin.set_script(script)
		
		if not plugin is PluginData:
			push_error("Fail to load plugin as PluginData: %s" % file)
			continue
	
		plugins.append(plugin)
	
	return plugins
