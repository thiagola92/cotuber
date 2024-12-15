extends PluginData


## Delay in milliseconds
var delay: int = 500

var _timer_start: int = 0

var _is_timer_running := false


func process(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	if _is_timer_running and Time.get_ticks_msec() - _timer_start > delay:
		_is_timer_running = false
		idle_texture.visible = true
		speaking_texture.visible = false


func start_speaking(_idle_texture: TextureRect, _speaking_texture: TextureRect) -> void:
	_is_timer_running = false


func stop_speaking(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	_is_timer_running = true
	idle_texture.visible = false
	speaking_texture.visible = true
	_timer_start = Time.get_ticks_msec()


func save_plugin(_zip: ZIPPacker, _path: String) -> Dictionary:
	return {
		"delay": delay
	}


func load_plugin(_zip: ZIPReader, _path: String, data: Dictionary) -> void:
	delay = data["delay"]


func create_view() -> Control:
	var container := HBoxContainer.new()
	var label := Label.new()
	var line_edit := LineEdit.new()
	
	label.text = "Delay: "
	line_edit.text = str(delay)
	line_edit.text_changed.connect(
		func(text: String):
			delay = int(text)
	)
	
	container.add_child(label)
	container.add_child(line_edit)
	
	return container
