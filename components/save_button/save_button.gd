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
		var plugins = []
		var idle_path := "%s/idle.png" % states.size()
		var speaking_path := "%s/speaking.png" % states.size()
	
		zip.start_file(idle_path)
		zip.write_file(state.idle_image.save_png_to_buffer())
		zip.close_file()
	
		zip.start_file(speaking_path)
		zip.write_file(state.speaking_image.save_png_to_buffer())
		zip.close_file()
		
		for plugin in state.plugins:
			var properties = []
			var script := (plugin.get_script() as Script)
			var filename := script.resource_path.get_file()
			var plugin_path := "%s/%s" % [states.size(), filename]
			
			for property in script.get_script_property_list():
				if not property["usage"] & PROPERTY_USAGE_STORAGE:
					continue
				
				properties.append({
					"name": property["name"],
					"value": plugin.get(property["name"])
				})
			
			plugins.append({
				"source_code": plugin_path,
				"properties": properties,
			})
			
			zip.start_file(plugin_path)
			zip.write_file(script.source_code.to_utf8_buffer())
			zip.close_file()
		
		states.append({
			"idle_image": idle_path,
			"speaking_image": speaking_path,
			"shortcut": state.shortcut,
			"plugins": plugins,
		})
	
	var json = JSON.stringify({
		"minimum_volume": character.minimum_volume,
		"image_position": character.image_position,
		"image_size": character.image_size,
		"background_color": character.background_color,
		"states": states
	}, "  ")
	
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
