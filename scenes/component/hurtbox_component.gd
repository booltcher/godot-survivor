extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

var floating_text_scene = preload("res://scenes/ui/float_text.tscn")

func _ready():
	pass

func _on_area_entered(other_area: Area2D) -> void:
	
	
	if not other_area is HitboxComponent:
		return
		
	if health_component.current_health == null:
		return
	
	var hitbox_component = other_area as HitboxComponent
	
	health_component.damage(hitbox_component.damage)
	
	# display damage number
	var floating_text_instance = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text_instance)
	
	floating_text_instance.global_position = global_position 
	floating_text_instance.start(str(int(hitbox_component.damage)))
