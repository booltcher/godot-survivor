extends Node


@export var experience_manager: Node
@export var upgrade_view_scene: PackedScene

var upgrade_pool = WeightedTable.new()
var current_upgrades = {}

var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")

func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)
	
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_axe, 10)
	
	

func pick_upgrades():
	var chosen_upgrade: Array[AbilityUpgrade] = []
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrade.size(): 
			break
		chosen_upgrade.append(upgrade_pool.pick_item(chosen_upgrade))
	
	return chosen_upgrade

	
func show_upgrade_view(chosen_upgrades: Array[AbilityUpgrade]):
	var upgrade_view_instance = upgrade_view_scene.instantiate()
	add_child(upgrade_view_instance)
	upgrade_view_instance.set_upgrade_list(chosen_upgrades)
	upgrade_view_instance.select_upgrade.connect(apply_upgrade)


func update_upgrade_pool(chosen_upgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)


func apply_upgrade(chosen_upgrade):
	var has_upgrade = current_upgrades.has(chosen_upgrade.id)
	if not has_upgrade:
		current_upgrades[chosen_upgrade.id] = {
			"resource": chosen_upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
		
	if chosen_upgrade.max_quantity == current_upgrades[chosen_upgrade.id]["quantity"]:
		upgrade_pool.remove_item(chosen_upgrade)
		
		
	update_upgrade_pool(chosen_upgrade)
	GameEvents.emit_update_ability_upgrades(chosen_upgrade, current_upgrades)


func on_level_up(current_level: int):
	if upgrade_pool.items.size() == 0:
		return

	show_upgrade_view(pick_upgrades())
