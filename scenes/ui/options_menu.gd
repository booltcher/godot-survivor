extends CanvasLayer

@onready var sfx_slider: HSlider = %SfxSlider
@onready var bgm_slider: HSlider = %BgmSlider
@onready var fullscreen_button: CheckBox = %FullscreenButton

signal back_to_before


func _ready() -> void:
	sync_options_display()


func get_audio_bus_volumn_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	#var db = AudioServer.get_bus_volume_db(bus_index)
	#return db_to_linear(db)
	return AudioServer.get_bus_volume_linear(bus_index)


func sync_options_display():
	sfx_slider.value = get_audio_bus_volumn_percent("sfx")
	bgm_slider.value = get_audio_bus_volumn_percent("bgm")
	var isFullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	fullscreen_button.button_pressed = isFullscreen


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back_button_pressed() -> void:
	back_to_before.emit()


func set_bus_volumn(bus_name: String, value: float):
	var bus = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


func _on_bgm_slider_value_changed(value: float) -> void:
	set_bus_volumn("bgm", value)


func _on_sfx_slider_value_changed(value: float) -> void:
	set_bus_volumn("sfx", value)
