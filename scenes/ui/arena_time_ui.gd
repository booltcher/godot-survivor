extends CanvasLayer

@export var arena_time_manager: Node
@onready var label: Label = $%Label


func _process(delta: float) -> void:
	if arena_time_manager == null:
		return
	var lapsed_time = arena_time_manager.get_lapsed_time()
	
	label.text = format_seconds(lapsed_time)
	

func format_seconds(seconds: float):
	var mins: int = floor(seconds / 60)
	var remaining_seconds = seconds - (mins * 60)
	
	return str(mins) + ":" + ("%02d" % floor(remaining_seconds))
