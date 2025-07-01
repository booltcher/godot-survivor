extends Node2D

@onready var hitbox_component = $HitboxComponent

const MAX_RADIUS = 100
var default_rotation = Vector2.RIGHT

func _ready() -> void:
	default_rotation = default_rotation.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.tween_method(excute_rotate, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)


func excute_rotate(deg: float):
	var percent = deg / 2 # 总共转2圈，现在转了第deg圈，相除就是执行的百分比
	var current_direction = default_rotation.rotated(deg * TAU)
	
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	
	if not player_node:
		return
	
	global_position = player_node.global_position + (current_direction * MAX_RADIUS)
