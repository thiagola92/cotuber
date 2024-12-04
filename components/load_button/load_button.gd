extends Button


signal character_loaded(character: CharacterData)

@onready var _file_dialog := $FileDialog


func _on_pressed() -> void:
	_file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	var zip := ZIPReader.new()
	var error := zip.open(path)
	
	if error:
		return push_error("Failed to open zip file")
	
	if not zip.file_exists("character.json"):
		return push_error("Missing character.json in zip")
	
	var json = zip.read_file("character.json").get_string_from_utf8()
	var c = JSON.parse_string(json)
	
	if not c or not c is Dictionary:
		return push_error("Failed to parse character.json")
	
	var character := CharacterData.new()
	character.minimum_volume = c["minimum_volume"]
	character.image_position = type_convert(c["image_position"], TYPE_VECTOR2)
	character.image_size =  type_convert(c["image_size"], TYPE_VECTOR2)
	character.background_color = Color.from_string(c["background_color"], Color.YELLOW)
	character.states.clear()
	
	for s in c["states"]:
		var state := StateData.new()
		state.idle_image = Image.new()
		state.speaking_image = Image.new()
		state.shortcut = s["shortcut"]
		state.plugins.clear()
		
		if not zip.file_exists(s["idle_image"]):
			return push_error("Missing idle image in zip")
		
		if not zip.file_exists(s["speaking_image"]):
			return push_error("Missing speaking image in zip")
		
		error = state.idle_image.load_png_from_buffer(zip.read_file(s["idle_image"]))
		
		if error:
			return push_error("Failed to load idle image")
		
		error = state.speaking_image.load_png_from_buffer(zip.read_file(s["speaking_image"]))
		
		if error:
			return push_error("Failed to load speaking image")
		
		for p in s["plugins"]:
			var plugin := PluginData.new()
			var plugin_path := "%s/%s" % [character.states.size(), state.plugins.size()]
			
			if not zip.file_exists(p["source_code"]):
				return push_error("Missing plugin source code: ", p["source_code"])
			
			# Create temporary script file so we can load with ResourceLoader.
			var source_code := zip.read_file(p["source_code"]).get_string_from_utf8()
			error = TmpDir.create_tmp_file("plugin.gd", source_code)
			
			if error:
				return push_error("Failed to create temporary plugin file: ", p["source_code"])
			
			var script = ResourceLoader.load(TmpDir.path("plugin.gd"), "Script")
			
			if not script is Script:
				return push_error("Failed to load plugin script: ", p["source_code"])
			
			plugin.set_script(script)
			plugin.load_plugin(zip, plugin_path, p["data"])
			
			state.plugins.append(plugin)
		
		character.states.append(state)
	
	character_loaded.emit(character)
