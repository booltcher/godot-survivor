extends Node

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var hit_flash_component_material: ShaderMaterial

var flash_tween: Tween


func _ready() -> void:
	health_component.health_change.connect(on_health_change)
	sprite.material = hit_flash_component_material


func on_health_change(current_health):
	if flash_tween != null && flash_tween.is_valid():
		flash_tween.kill()
	
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	flash_tween = create_tween()
	flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
