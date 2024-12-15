extends PluginData


var darkened := 0.3


func init(idle_texture: TextureRect, _speaking_texture: TextureRect) -> void:
	idle_texture.modulate = idle_texture.modulate.darkened(darkened)


func save_plugin(_zip: ZIPPacker, _path: String) -> Dictionary:
	return {
		"darkened": darkened
	}


func load_plugin(_zip: ZIPReader, _path: String, data: Dictionary) -> void:
	darkened = data["darkened"]


func create_view() -> Control:
	var container := HBoxContainer.new()
	var label := Label.new()
	var line_edit := LineEdit.new()
	
	label.text = "Darkened: "
	line_edit.text = str(darkened)
	
	line_edit.text_changed.connect(
		func(text: String):
			if text.is_valid_float():
				darkened = float(text)
				restart_requested.emit()
	)
	
	container.add_child(label)
	container.add_child(line_edit)
	
	return container
