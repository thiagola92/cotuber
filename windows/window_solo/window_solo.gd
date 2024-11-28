class_name WindowSolo
extends Control


var _scene_data := SceneData.new()


func _on_save_button_save_requested(path: String) -> void:
	#var zip_packer := ZIPPacker.new()
	#var error := zip_packer.open(path)
	#
	#if error:
		#return ErrorPopup.show_message("ERROR_SAVE_BUTTON_CREATE_FAIL")
	
	####
	_scene_data.background_color = BackgroundColor.live_color
	
	var error := ResourceSaver.save(
		_scene_data, path, ResourceSaver.FLAG_BUNDLE_RESOURCES
	)
	
	if error:
		printerr(error)
		return ErrorPopup.show_message("ERROR_SAVING_SCENE")
	
	#zip_packer.close()
