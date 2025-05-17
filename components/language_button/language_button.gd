extends OptionButton


# Don't translate dictionary keys, let it as native language so the user can read
# even when is not his language.
var _options: Dictionary[String, String] = {
	"English": "en",
	"Português (Brasil)": "pt",
}


func _ready() -> void:
	TranslationServer.set_locale("en") # Default to english.
	
	var index: int = 0
	
	for lang in _options:
		add_item(lang)
		
		if _options[lang] == OS.get_locale_language():
			select(index)
		
		index += 1


func _on_item_selected(index: int) -> void:
	var lang := get_item_text(index)
	
	TranslationServer.set_locale(_options[lang])
