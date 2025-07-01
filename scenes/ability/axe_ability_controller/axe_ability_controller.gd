extends Node

@export var axe_ability_scene: PackedScene
@export var damage = 10

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	
	if not player_node:
		return
		
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	
	if foreground_layer == null:
		return
	
	foreground_layer.add_child(axe_instance)
	axe_instance.global_position = player_node.global_position
	axe_instance.hitbox_component.damage = damage
