extends CanvasLayer

@onready var panel_container: PanelContainer = %PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var option_board = preload("res://scenes/ui/options_menu.tscn")

var is_closing = false

func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3).from(Vector2.ZERO).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		close_pause()
		get_tree().root.set_input_as_handled()
	

func close_pause():
	if is_closing:
		return
	
	is_closing = true
	animation_player.play_backwards("pause")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3).from(Vector2.ONE).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	get_tree().paused = false
	queue_free()


func _on_resume_button_pressed() -> void:
	close_pause()


func _on_options_button_pressed() -> void:
	var option_board_instance = option_board.instantiate() as Node
	add_child(option_board_instance)
	option_board_instance.back_to_before.connect(on_back_to_before.bind(option_board_instance)) 


func on_back_to_before(option_board_instance: Node):
	option_board_instance.queue_free()


func _on_return_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	
