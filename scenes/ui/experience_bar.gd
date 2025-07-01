extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar

func _ready() -> void:
	experience_manager.experience_update.connect(on_experience_update)
	progress_bar.value = 0


func on_experience_update(current_experience: float, target_experience: float):
	progress_bar.value = current_experience / target_experience
