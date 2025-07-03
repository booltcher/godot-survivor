extends Node

signal arena_diffculty_increased(diffculty: int)

const DIFFCULTY_INTERVAL = 5

@export var victory_view_scene: PackedScene
@onready var timer: Timer = $Timer

var arena_diffculty = 0

func get_lapsed_time():
	return timer.wait_time - timer.time_left

func _process(delta: float) -> void:
	var next_time_target = timer.wait_time - (arena_diffculty + 1) * DIFFCULTY_INTERVAL
	if timer.time_left <= next_time_target:
		arena_diffculty += 1
		arena_diffculty_increased.emit(arena_diffculty)

func _on_timer_timeout() -> void:
	var victory_view_instance = victory_view_scene.instantiate()
	add_child(victory_view_instance)
	victory_view_instance.play_sound()
