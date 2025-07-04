extends Node

@export var defeat_view_scene: PackedScene

var pause_view = preload("res://scenes/ui/pause_menu.tscn")

func _ready() -> void:
	$%Player.health_component.died.connect(on_player_died)

func on_player_died():
	print("died")
	var defeat_view_instance = defeat_view_scene.instantiate()
	add_child(defeat_view_instance)
	defeat_view_instance.set_defeat()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_view_instance = pause_view.instantiate()
		add_child(pause_view_instance)
