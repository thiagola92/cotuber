## Used, when application is running on browser, to load file from user.
class_name LoadInput
extends Node


signal file_received(file: PackedByteArray, filename: String)

## The valid file types, separated by commas. [br]
## https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/accept
@export var accept: PackedStringArray = [".zip"]

var _input: JavaScriptObject

var _on_change_callback := JavaScriptBridge.create_callback(_on_change)

var _on_array_buffer_callback: JavaScriptObject


func init() -> void:
	var document = JavaScriptBridge.get_interface("document")
	_input = document.createElement("input")
	_input.type = "file"
	_input.accept = accept
	_input.onchange = _on_change_callback


func click() -> void:
	_input.click()


func _on_change(args) -> void:
	var event = args[0]
	var files = event.target.files
	
	if files.length == 1:
		var file = files[0]
		
		_on_array_buffer_callback = JavaScriptBridge.create_callback(
			_on_array_buffer.bind(file.name)
		)
		
		file.arrayBuffer().then(_on_array_buffer_callback)


func _on_array_buffer(args, filename) -> void:
	if not JavaScriptBridge.is_js_buffer(args[0]):
		return push_error("Expected an ArrayBuffer")
	
	file_received.emit(
		JavaScriptBridge.js_buffer_to_packed_byte_array(args[0]), filename
	)
