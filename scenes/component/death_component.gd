extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D
@export var sfx: AudioStream
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	gpu_particles_2d.texture = sprite.texture
	health_component.died.connect(on_died)
	audio_stream_player_2d.stream = sfx


func on_died():
	var spawn_position = owner.global_position
	
	var entities = get_tree().get_first_node_in_group("entities_layer")
	
	get_parent().remove_child(self)
	entities.add_child(self)
	animation_player.play('death')
	
	global_position = spawn_position
	audio_stream_player_2d.play()
