extends Node

@export var valid_range: float = 150

@export var sword_ability: PackedScene
@export var damage = 100

var base_wait_time = 1.5
var base_damage_percent = 1

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	
	GameEvents.update_ability_upgrades.connect(on_emit_update_ability_upgrades)
	

func on_emit_update_ability_upgrades(upgrade, current_upgrades):
	if upgrade.id == "sword_rate":
		var new_wait_time = base_wait_time * (1 - (current_upgrades[upgrade.id]["quantity"] * .1))
		$Timer.wait_time = new_wait_time
		$Timer.start()
	
	if upgrade.id == "sword_damage":
		base_damage_percent = 1 + (.15 * current_upgrades["sword_damage"]["quantity"])
	
	
	

func on_timer_timeout():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	
	if not player_node:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy").filter(
		func (item: Node2D):
			return item.global_position.distance_squared_to(player_node.global_position) < pow(valid_range, 2)
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(
		func (a: Node2D, b: Node2D):
			var a_distance = a.global_position.distance_squared_to(player_node.global_position)
			var b_distance = b.global_position.distance_squared_to(player_node.global_position)
			return a_distance <  b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var target_directon: Vector2 = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = target_directon.angle()
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	
	foreground_layer.add_child(sword_instance)

	sword_instance.hitbox_component.damage = damage * base_damage_percent
