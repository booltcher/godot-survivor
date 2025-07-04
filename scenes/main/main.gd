extends Node

@export var defeat_view_scene: PackedScene


func _ready() -> void:
	$%Player.health_component.died.connect(on_player_died)


func on_player_died():
	print("died")
	var defeat_view_instance = defeat_view_scene.instantiate()
	add_child(defeat_view_instance)
	defeat_view_instance.set_defeat()
