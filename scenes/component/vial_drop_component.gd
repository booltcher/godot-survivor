extends Node


@export var vial_scene: PackedScene
@export var health_component: HealthComponent
@export_range(0, 1) var drop_percent: float = .5

func _ready() -> void:
	health_component.died.connect(on_died)


func _process(delta: float) -> void:
	pass
	
func on_died():
	if randf() > drop_percent:
		return
	
	if vial_scene == null:
		print("vial scene is null")
		return
	
	var vial_instance = vial_scene.instantiate() as Node2D
	 
	if not owner is Node2D:
		print("invalid vial drop component owner")
		return
	
	vial_instance.global_position = (owner as Node2D).global_position
	var entities_layer = get_tree().get_first_node_in_group("foreground_layer")
	entities_layer.add_child(vial_instance)
