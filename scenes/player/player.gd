extends CharacterBody2D
class_name Player

const MAX_SPEED = 125
const ACC = 25
var collision_bodies_count = 0
@onready var hurt_interval_timer: Timer = $HurtIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visual: Node2D = $Visual

func _ready():
	health_component.health_change.connect(on_health_change)
	update_health_bar_display(health_component.current_health)
	GameEvents.update_ability_upgrades.connect(on_update_ability_upgrades)
	

func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var target_velocity = movement_vector * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACC))
	
	move_and_slide()
	
	if movement_vector.x == 0 &&  movement_vector.y == 0:
		animation_player.play("RESET")
	else:
		animation_player.play("walk")
	
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visual.scale = Vector2(move_sign, 1)


func on_update_ability_upgrades(upgrade: AbilityUpgrade, _other):
	if not upgrade is AbilityUpgradeWithController:
		return
	var new_upgrade = upgrade as AbilityUpgradeWithController
	abilities.add_child(new_upgrade.ability_controller_scene.instantiate())


func on_health_change(value):
	update_health_bar_display(health_component.current_health_percent)


func get_movement_vector():
	var movement_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	return movement_vector
	

func check_deal_damage():
	if collision_bodies_count == 0 ||!hurt_interval_timer.is_stopped():
		print("hurt_interval_timer", hurt_interval_timer.time_left)
		return

	health_component.damage(1)
	
	hurt_interval_timer.start()
	
func update_health_bar_display(value):
	health_bar.value = value
	


func _on_hurt_area_body_entered(body: Node2D) -> void:
	collision_bodies_count += 1
	check_deal_damage()


func _on_hurt_area_body_exited(body: Node2D) -> void:
	collision_bodies_count -= 1


func _on_hurt_interval_timer_timeout() -> void:
	check_deal_damage()
