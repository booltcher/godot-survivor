extends CharacterBody2D

@onready var visual: Node2D = $Visual
@onready var velocity_component: VelocityComponent = $VelocityComponent

func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visual.scale = Vector2(-move_sign, 1)
