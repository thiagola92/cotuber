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
	# HACK: This only works because "GDScript Export Mode" is "Text".
	# As mentioned in Script.has_source_code(), you lose access to the
	# source code when exporting as binary tokens.
	for plugin in _defaults:
		var filename := plugin.filename()
		var filepath := "%s/%s" % [PATH, filename]
		var error: Error
		
		if FileAccess.file_exists(filepath):
			error = DirAccess.remove_absolute(filepath)
		
		if error:
			push_error("Fail to delete the default plugin %s (error: %s)" % [filename, error])
		
		error = ResourceSaver.save(plugin.get_script(), filepath)
		
		if error:
			push_error("Fail to create the default plugin %s (error: %s)" % [filename, error])


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
