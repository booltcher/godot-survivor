extends Node
class_name HealthComponent

signal died
signal health_change

@export var max_health = 100.0
var current_health: float
var current_health_percent: float

func _ready() -> void:
	current_health = max_health
	health_change.emit(current_health)
	
	

func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	current_health_percent = min(current_health / max_health, 1)
	health_change.emit(current_health)
	Callable(excute_died).call_deferred()


func excute_died():
	if current_health == 0:
		died.emit()
		owner.queue_free()
