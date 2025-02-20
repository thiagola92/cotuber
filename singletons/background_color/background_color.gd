extends ColorRect


var default_color := Color.hex(0x4d4d4dff)

## Variable to toggle between live color and darkened color.
var live: bool = false:
	set(b):
		live = b
		
		if live:
			color = live_color
		else:
			color = live_color.darkened(0.4)

## Color to be used when going live.
var live_color: Color = Color.hex(0x4d4d4dff):
	set(c):
		live_color = c
		
		# When the user change the live color,
		# you may need to darkneded it if the user is not live.
		if live:
			color = live_color
		else:
			color = live_color.darkened(0.4)


func _ready() -> void:
	live_color = live_color
	
	# SECURITY: Resizing window when transparent is enabled, can
	# make the window transparent while resizing (will ignore the background color).
	# This is dangerous because we don't know what the stream has behind the application,
	# and would be exposed during resizing.
	# NOTE: Why change this through code? So I can explain the reason...
	get_window().unresizable = true
