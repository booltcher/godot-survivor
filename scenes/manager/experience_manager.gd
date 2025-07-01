extends Node

var current_experience: float = 0
var current_level = 1
var target_experience: float = 1
const LEVEL_EXPERIENCE_STEP: float = 5

signal experience_update(current_experience, target_expericence)
signal level_up(new_level: int)

func _ready() -> void:
	GameEvents.collect_experience_vial.connect(on_collect_experience_vial)


func increment_experience(number: int):
	current_experience += number
	
	if current_experience >= target_experience:
		current_level += 1
		current_experience = 0
		target_experience += LEVEL_EXPERIENCE_STEP
		level_up.emit(current_level)
	
	experience_update.emit(current_experience, target_experience)
	


func on_collect_experience_vial(number: int):
	increment_experience(number)
