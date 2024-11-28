extends PluginNode


var timer := Timer.new()

var change_to_idle: bool = false


func _init() -> void:
	timer.one_shot = true
	timer.wait_time = 1
	timer.timeout.connect(_on_timer_timeout)
	
	add_child(timer)


func start_speaking() -> void:
	change_to_idle = false
	timer.stop()


func stop_speaking() -> void:
	timer.start()


func _on_timer_timeout() -> void:
	change_to_idle = true
