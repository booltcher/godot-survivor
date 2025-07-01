extends Node

@export var mouse_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var carb_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

const BASE_SPAWN_TIME = 1.0

const SPAWN_RADIUS = 375

var enemy_weighted_table = WeightedTable.new()

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_diffculty_increased.connect(on_arena_diffculty_increased)
	enemy_weighted_table.add_item(mouse_enemy_scene, 10)
	

func get_spawn_position():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if not player_node:
		return Vector2.ZERO
	
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player_node.global_position + (random_direction * SPAWN_RADIUS)
		var raycast_instance = PhysicsRayQueryParameters2D.create(player_node.global_position, spawn_position, 1)
		var raycase_result = get_tree().root.world_2d.direct_space_state.intersect_ray(raycast_instance)
		
		if raycase_result.is_empty():
			return spawn_position
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))

	
func on_timer_timeout():
	var random_enemy = enemy_weighted_table.pick_item()
	var enemy_instance = random_enemy.instantiate() as Node2D
	enemy_instance.global_position = get_spawn_position()
	
	var entities_layer = get_tree().get_first_node_in_group("foreground_layer")
	entities_layer.add_child(enemy_instance)
	
func on_arena_diffculty_increased(difficulty):
	var time_off = (.1 / 12) * difficulty # 当一分钟后刚好难度12，这时候 time_off为0.1，也就是1分钟后间隔时间变化0.9
	time_off = min(.7, time_off) # 限制最少 .7,也就是间隔最小.3
	timer.wait_time = 1 - time_off
	
	if difficulty == 3:
		enemy_weighted_table.add_item(carb_enemy_scene, 20)
		
	if difficulty == 6:
		enemy_weighted_table.add_item(wizard_enemy_scene, 30)
