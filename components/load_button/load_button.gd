class_name LoadButton
extends Button


signal character_loaded(character: CharacterData)

@onready var _file_dialog := $FileDialog

@onready var _load_input: LoadInput = $LoadInput


func _ready() -> void:
	if OS.get_name() == "Web":
		_load_input.init()
	
	get_window().files_dropped.connect(_on_window_files_dropped)


func _on_pressed() -> void:
	if OS.get_name() == "Web":
		return _load_input.click()
	
	_file_dialog.popup_centered()


func _load(path: String) -> void:
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
	character.image_position = JSON.to_native(c["image_position"])
	character.image_size =  JSON.to_native(c["image_size"])
	character.background_color = JSON.to_native(c["background_color"])
	character.states.clear()
	
	for s in c["states"]:
		var state := StateData.new()
		state.idle_image = Image.new()
		state.speaking_image = Image.new()
		state.shortcut = null
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
		
		if s["shortcut"] != "":
			var keys := (s["shortcut"] as String).split("+")
			state.shortcut = InputEventKey.new()
			
			for k in keys:
				match k:
					"Alt":
						state.shortcut.alt_pressed = true
					"Ctrl":
						state.shortcut.ctrl_pressed = true
					"Meta":
						state.shortcut.meta_pressed = true
					"Shift":
						state.shortcut.shift_pressed = true
					_:
						state.shortcut.keycode = OS.find_keycode_from_string(k)
		
		for p in s["plugins"]:
			var plugin := PluginData.new()
			var plugin_path: String = p["source_code"]
			var plugin_dir := plugin_path.get_basename()
			var plugin_filename := plugin_path.get_file()
			
			if not zip.file_exists(plugin_path):
				return push_error("Missing plugin source code: ", plugin_path)
			
			# Create temporary script file so we can load with ResourceLoader.
			var source_code := zip.read_file(plugin_path).get_string_from_utf8()
			error = TmpDir.create_file(plugin_filename, source_code)
			
			if error:
				return push_error("Failed to create temporary plugin file: ", plugin_path)
			
			var script = ResourceLoader.load(
				TmpDir.path(plugin_filename),
				"Script",
				ResourceLoader.CACHE_MODE_IGNORE
			)
			
			if not script is Script:
				return push_error("Failed to load plugin script: ", plugin_path)
			
			plugin.set_script(script)
			plugin.load_plugin(zip, plugin_dir, p["data"])
			
			state.plugins.append(plugin)
		
		character.states.append(state)
	
	character_loaded.emit(character)


func _on_window_files_dropped(files: PackedStringArray) -> void:
	# Check if is dropping at this Control.
	if not Rect2(global_position, size).has_point(get_global_mouse_position()):
		return
	
	if len(files) != 1:
		return ErrorPopup.show_message("LOAD_BUTTON_ERROR_DROPPED")
	
	_load(files[0])


func _on_file_dialog_file_selected(path: String) -> void:
	_load(path)


func _on_load_input_file_received(file: PackedByteArray, filename: String) -> void:
	var error := TmpDir.create_file_with_bytes(filename, file)
	
	if error:
		return push_error("Failed to create temporary file (error: %s)", error)
	
	_load(TmpDir.path(filename))
