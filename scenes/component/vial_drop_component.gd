extends Node

@export var health_component: HealthComponent
@export_range(0, 1) var drop_percent: float = .5

var vial_scene = preload("res://scenes/game_object/experience_vial/experience_vial.tscn")
var large_vial_scene = preload("res://scenes/game_object/large_experience_vial/large_experience_vial.tscn")
var large_percent = 0.0

func _ready() -> void:
	health_component.died.connect(on_died)
	GameEvents.purchase_meta_upgrade.connect(on_purchase_meta_upgrade)
	update_large_experience_percent()


func update_large_experience_percent():
	if GameMetadata.save_data["meta_upgrade_list"].has("experience_gain"):
		large_percent = GameMetadata.save_data["meta_upgrade_list"]["experience_gain"]["quantity"] * 0.05
		print("current large percent:", large_percent)


func on_purchase_meta_upgrade(upgrade: MetadataUpgradeItem):
	update_large_experience_percent()

	
func on_died():
	if randf() > drop_percent:
		return
	
	var target_vial = large_vial_scene if randf() < large_percent else vial_scene
	
	var vial_instance = target_vial.instantiate() as Node2D
	 
	if not owner is Node2D:
		print("invalid vial drop component owner")
		return
	
	vial_instance.global_position = (owner as Node2D).global_position
	var entities_layer = get_tree().get_first_node_in_group("foreground_layer")
	entities_layer.add_child(vial_instance)
