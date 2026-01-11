extends Control

@onready var volume_label = $MainContainer/ContentVBox/VolumeLabel
@onready var volume_slider = $MainContainer/ContentVBox/VolumeSlider

func _ready():
	# Set initial volume to 100%
	var current_volume = db_to_linear(AudioServer.get_bus_volume_db(0))
	volume_slider.value = current_volume * 100
	volume_label.text = str(int(volume_slider.value)) + "%"

func _on_x_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu_lepsze.tscn")

func _on_volume_value_changed(value: float) -> void:
	# Convert 0-100 percentage to decibels
	# 0% = -80db (essentially muted), 100% = 0db (full volume)
	var db_value = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(0, db_value)
	volume_label.text = str(int(value)) + "%"
