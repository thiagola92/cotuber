extends Node


const PATH := "user://tmp"


func _ready() -> void:
	_make_dir()


func _make_dir() -> void:
	var error := DirAccess.make_dir_absolute(PATH)
	
	if error and error != 32:
		push_error("Fail to create temporary directory (error: %s)" % error)


func path(filename: String) -> String:
	return "%s/%s" % [PATH, filename]


func create_tmp_file(filename: String, content: String) -> Error:
	var tmp := FileAccess.open(path(filename), FileAccess.WRITE)
	
	if not tmp:
		return FileAccess.get_open_error()
	
	tmp.store_string(content)
	tmp.close()
	
	return OK


func create_tmp_file_with_bytes(filename: String, content: PackedByteArray) -> Error:
	var tmp := FileAccess.open(path(filename), FileAccess.WRITE)
	
	if not tmp:
		return FileAccess.get_open_error()
	
	tmp.store_buffer(content)
	tmp.close()
	
	return OK


# TODO
func delete_tmp_files() -> void:
	pass
