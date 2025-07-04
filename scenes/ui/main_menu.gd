extends CanvasLayer

var option_board = preload("res://scenes/ui/options_menu.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_options_button_pressed() -> void:
	var option_board_instance = option_board.instantiate()
	add_child(option_board_instance)
	option_board_instance.back_to_before.connect(on_back_to_before.bind(option_board_instance)) 


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func on_back_to_before(option_board_instance: Node):
	print("123")
	option_board_instance.queue_free()
