extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.player_hurt.connect(on_player_hurt)


func on_player_hurt():
	animation_player.play("flicker")
