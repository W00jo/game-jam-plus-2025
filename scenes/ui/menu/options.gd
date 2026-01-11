extends Control

@onready var volume_label = $MainContainer/ContentVBox/VolumeLabel
@onready var volume_slider = $MainContainer/ContentVBox/VolumeSlider
@onready var flag_pl = $MainContainer/ContentVBox/LanguageFlags/FlagPL
@onready var flag_en = $MainContainer/ContentVBox/LanguageFlags/FlagEN
@onready var flag_es = $MainContainer/ContentVBox/LanguageFlags/FlagES
@onready var flag_pt = $MainContainer/ContentVBox/LanguageFlags/FlagPT

func _ready():
	GameManager.play_menu_music()
	# Start volume = 100%
	var current_volume = db_to_linear(AudioServer.get_bus_volume_db(0))
	volume_slider.value = current_volume * 100
	volume_label.text = str(int(volume_slider.value)) + "%"
	
	# Highlight current language
	_update_language_selection(TranslationServer.get_locale())

func _on_x_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu_lepsze.tscn")

func _on_volume_value_changed(value: float) -> void:
	var db_value = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(0, db_value)
	volume_label.text = str(int(value)) + "%"


func _on_language_selected(language_code: String) -> void:
	print("Język: ", language_code)
	TranslationServer.set_locale(language_code)
	_update_translations(get_tree().root)
	_update_language_selection(language_code)


func _update_language_selection(locale: String) -> void:
	flag_pl.modulate = Color(1, 1, 1, 0.5)
	flag_en.modulate = Color(1, 1, 1, 0.5)
	flag_es.modulate = Color(1, 1, 1, 0.5)
	flag_pt.modulate = Color(1, 1, 1, 0.5)
	
	# Wybrana flaga zmienia kolor
	match locale:
		"pl":
			flag_pl.modulate = Color(1, 1, 1, 1)
		"en":
			flag_en.modulate = Color(1, 1, 1, 1)
		"es":
			flag_es.modulate = Color(1, 1, 1, 1)
		"pt":
			flag_pt.modulate = Color(1, 1, 1, 1)


func _update_translations(node: Node) -> void:
	if node is Label or node is Button or node is RichTextLabel:
		if node.auto_translate_mode == Node.AUTO_TRANSLATE_MODE_ALWAYS:
			node.notification(NOTIFICATION_TRANSLATION_CHANGED)
	
	for child in node.get_children():
		_update_translations(child)
