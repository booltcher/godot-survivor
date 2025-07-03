extends CharacterBody2D
class_name Player

var collision_bodies_count = 0
@onready var hurt_interval_timer: Timer = $HurtIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visual: Node2D = $Visual
@onready var velocity_component: VelocityComponent = $VelocityComponent

var base_speed = 0

func _ready():
	base_speed = velocity_component.max_speed
	health_component.health_change.connect(on_health_change)
	update_health_bar_display(health_component.current_health)
	GameEvents.update_ability_upgrades.connect(on_update_ability_upgrades)
	

func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x == 0 &&  movement_vector.y == 0:
		animation_player.play("RESET")
	else:
		animation_player.play("walk")
	
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visual.scale = Vector2(move_sign, 1)


func on_update_ability_upgrades(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade is AbilityUpgradeWithController:
		var new_upgrade = upgrade as AbilityUpgradeWithController
		abilities.add_child(new_upgrade.ability_controller_scene.instantiate())
	elif upgrade.id == "move_speed":
		velocity_component.max_speed = base_speed * (1 + (current_upgrades["move_speed"]["quantity"] * .2))
	
	


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
