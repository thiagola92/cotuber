class_name LoadButton
extends Button


signal character_loaded(character: CharacterData)

# On Web, we only have access to a temporary location,
# so we can only receive files if the user interact
# with an input and select it through browser prompt.
var _html_input: JavaScriptObject

var _on_html_input_change_callback := JavaScriptBridge.create_callback(
	_on_html_input_change
)

var _on_array_buffer_callback := JavaScriptBridge.create_callback(
	_on_array_buffer
)

@onready var _file_dialog := $FileDialog


func _ready() -> void:
	if OS.get_name() == "Web":
		var document = JavaScriptBridge.get_interface("document")
		_html_input = document.createElement("input")
		_html_input.type = "file"
		_html_input.accept = ".zip"
		_html_input.onchange = _on_html_input_change_callback


func _on_pressed() -> void:
	if OS.get_name() == "Web":
		return _html_input.click()
	
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
			error = TmpDir.create_tmp_file(plugin_filename, source_code)
			
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


func _on_html_input_change(args) -> void:
	var window = JavaScriptBridge.get_interface("window")
	var event = args[0]
	var files = event.target.files
	var file = files[0]
	file.arrayBuffer().then(_on_array_buffer_callback)


func _on_array_buffer(args) -> void:
	if not JavaScriptBridge.is_js_buffer(args[0]):
		return
	
	var zip := JavaScriptBridge.js_buffer_to_packed_byte_array(args[0])
	var error := TmpDir.create_tmp_file_with_bytes(
		"character.zip", zip
	)
	
	_on_file_dialog_file_selected(TmpDir.path("character.zip"))
