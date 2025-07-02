extends CanvasLayer

@export var upgrade_card_item_scene: PackedScene
@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer

signal select_upgrade(upgrade: AbilityUpgrade)

func _ready() -> void:
	get_tree().paused = true
	

func set_upgrade_list(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	
	for upgradeItem in upgrades:
		var card_instance = upgrade_card_item_scene.instantiate()
		h_box_container.add_child(card_instance)
		card_instance.play_in(delay)
		card_instance.set_upgrade_data(upgradeItem)
		card_instance.select.connect(on_select_upgrade.bind(upgradeItem))
		delay += 0.2

func on_select_upgrade(upgrade: AbilityUpgrade):
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	select_upgrade.emit(upgrade)
	get_tree().paused = false
	queue_free()
