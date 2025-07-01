extends Node
class_name VelocityComponent

@export var max_speed: int = 40
@export var acceleration: float = 5

var current_velocity = Vector2.ZERO


func accelerate_to_player():
	var owner_node = owner as Node2D
	if owner_node == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return
	
	var direction = (player.global_position - owner_node.global_position).normalized()
	accelerate_in_direction(direction)
	

# 这个方法使得对象的移动不是立即的，而是有起势和收势，更符合物理规律，如果设置加速度acceleration=max_speed就表示能对方向和速度的改变立即响应
func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	current_velocity = current_velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	
	
func move(character_body: CharacterBody2D):
	character_body.velocity = current_velocity
	character_body.move_and_slide()
	current_velocity = character_body.velocity
