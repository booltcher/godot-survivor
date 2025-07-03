extends CharacterBody2D

@onready var visual: Node2D = $Visual
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready():
	hurtbox_component.real_hurt.connect(on_real_hurt)
	

func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visual.scale = Vector2(-move_sign, 1)


func on_real_hurt():
	audio_stream_player_2d.play()
