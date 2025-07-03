extends CanvasLayer

@onready var panel_container: PanelContainer = %PanelContainer


func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	#tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).from(Vector2.ZERO)
	
	
func play_sound(isDefeat: bool = false):
	if isDefeat:
		$DefeatSound.play()
	else:
		$VictorySound.play()
	
func set_defeat():
	$%TitleLabel.text = "Defeat"
	$%SubtitleLabel.text = "You lost"
	play_sound(true)


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
