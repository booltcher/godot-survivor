extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func collect():
	Callable(queue_free).call_deferred()
	GameEvents.emit_collect_experience_vial(1)
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true
	

func play_sound():
	audio_stream_player_2d.play()


func fly(percent, start_position):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))

func _on_area_2d_area_entered(area: Area2D) -> void:
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(fly.bind(global_position), 0.0, 1.0, .5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
	tween.chain()
	tween.tween_callback(collect)
	play_sound()
	
	
