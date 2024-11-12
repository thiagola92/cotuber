extends ColorRect


var live: bool = false:
	set(b):
		live = b
		
		if live:
			color = live_color
		else:
			color = live_color.darkened(0.3)

var live_color: Color = Color.hex(0x4d4d4dff):
	set(c):
		live_color = c
		
		if live:
			color = live_color
		else:
			color = live_color.darkened(0.3)


func _ready() -> void:
	live_color = live_color
	
	# SECURITY: Resizing window when transparent is enabled, can
	# make the window transparent while resizing (will ignore the background color).
	# This is dangerous because we don't know what the stream has behind the application,
	# and would be exposed during resizing.
	# NOTE: Why change this through code? So I can explain the reason...
	get_window().unresizable = true
