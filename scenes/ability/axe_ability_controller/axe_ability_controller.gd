extends Node

@export var axe_ability_scene: PackedScene
@export var damage = 10

var base_damage_percent = 1

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	
	GameEvents.update_ability_upgrades.connect(on_emit_update_ability_upgrades)


func on_emit_update_ability_upgrades(upgrade, current_upgrades):
	if upgrade.id == "axe_damage":
		base_damage_percent = 1 + (.1 * current_upgrades["axe_damage"]["quantity"])


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
	axe_instance.hitbox_component.damage = damage * base_damage_percent
