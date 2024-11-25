extends OptionButton


static var _current_langauge: String = "English"


# Don't translate languages, let it as native language so the user can read
# even when is not his language.
var _options: Dictionary[String, Callable] = {
	"English": TranslationServer.set_locale.bind("en"),
	"Português (Brasil)": TranslationServer.set_locale.bind("pt"),
}


func _ready() -> void:
	var index: int = 0
	
	for language in _options:
		add_item(language)
		
		if language == _current_langauge:
			select(index)
		
		index += 1


func _on_item_selected(index: int) -> void:
	var language := get_item_text(index)
	
	_current_langauge = language
	_options[language].call()
