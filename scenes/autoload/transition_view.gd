extends CanvasLayer

signal transition_done

var skip_emit = false

func _ready() -> void:
	pass # Replace with function body.


func transition():
	$AnimationPlayer.play("transition")
	await transition_done
	skip_emit = true
	$AnimationPlayer.play_backwards("transition")
	

func emit_transition_done():
	if skip_emit:
		skip_emit = false
		return
	transition_done.emit()
