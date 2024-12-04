extends PluginData


## Delay in milliseconds
@export var delay: int = 500

var _timer_start: int = 0

var _is_timer_running := false

var _backup: Texture2D


func process(idle_texture: TextureRect, _speaking_texture: TextureRect) -> void:
	if _is_timer_running and Time.get_ticks_msec() - _timer_start > delay:
		_is_timer_running = false
		idle_texture.texture = _backup
		_backup = null


func start_speaking(_idle_texture: TextureRect, _speaking_texture: TextureRect) -> void:
	_is_timer_running = false


func stop_speaking(idle_texture: TextureRect, speaking_texture: TextureRect) -> void:
	_is_timer_running = true
	
	# Don't backup if you already have a backup,
	# because idle_texture.texture would be speaking_texture.texture.
	if not _backup:
		_backup = idle_texture.texture
		idle_texture.texture = speaking_texture.texture
	
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
