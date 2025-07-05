extends CanvasLayer

var option_board = preload("res://scenes/ui/options_menu.tscn")
var upgrade_board = preload("res://scenes/ui/meta_menu.tscn")

func _on_play_button_pressed() -> void:
	TransitionView.transition()
	await TransitionView.transition_done
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_options_button_pressed() -> void:
	var option_board_instance = option_board.instantiate()
	add_child(option_board_instance)
	option_board_instance.back_to_before.connect(on_back_to_before.bind(option_board_instance)) 


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func on_back_to_before(current_view: Node):
	current_view.queue_free()


func _on_upgrade_button_pressed() -> void:
	var upgrade_board_instance = upgrade_board.instantiate()
	add_child(upgrade_board_instance)
	upgrade_board_instance.back_to_before.connect(on_back_to_before.bind(upgrade_board_instance)) 
