extends Button


signal save_requested(path: String)

@onready var _file_dialog := $FileDialog


func save(character: CharacterData, path: String) -> void:
	var zip := ZIPPacker.new()
	var error := zip.open(path)
	
	if error:
		return push_error("Failed to create zip file")
	
	var states = []
	
	for state in character.states:
		var idle_path := "%s/idle.png" % states.size()
		var speaking_path := "%s/speaking.png" % states.size()
		var plugins = []
		var shortcut_text := ""
	
		zip.start_file(idle_path)
		zip.write_file(state.idle_image.save_png_to_buffer())
		zip.close_file()
	
		zip.start_file(speaking_path)
		zip.write_file(state.speaking_image.save_png_to_buffer())
		zip.close_file()
		
		if state.shortcut:
			shortcut_text = state.shortcut.as_text()
		
		for plugin in state.plugins:
			var script := (plugin.get_script() as Script)
			var plugin_path := "%s/%s" % [states.size(), plugins.size()]
			var source_code_path := "%s/%s" % [plugin_path, plugin.filename()]
			
			plugins.append({
				"source_code": source_code_path,
				"data": plugin.save_plugin(zip, plugin_path),
			})
			
			zip.start_file(source_code_path)
			zip.write_file(script.source_code.to_utf8_buffer())
			zip.close_file()
		
		states.append({
			"idle_image": idle_path,
			"speaking_image": speaking_path,
			"shortcut": shortcut_text,
			"plugins": plugins,
		})
	
	var json = JSON.stringify({
		"minimum_volume": character.minimum_volume,
		"image_position": JSON.from_native(character.image_position),
		"image_size": JSON.from_native(character.image_size),
		"background_color": JSON.from_native(character.background_color),
		"states": states
	}, "  ", false)
	
	zip.start_file("character.json")
	zip.write_file(json.to_utf8_buffer())
	zip.close_file()
	
	zip.close()


func _on_pressed() -> void:
	_file_dialog.popup_centered()


# Don't save here because all information necessary is in the main Window.
func _on_file_dialog_file_selected(path: String) -> void:
	if not path.ends_with(".zip"):
		path = "%s.zip" % path
	
	save_requested.emit(path)
