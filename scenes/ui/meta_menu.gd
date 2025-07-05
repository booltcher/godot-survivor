extends CanvasLayer

@export var meta_upgrade_list: Array[MetadataUpgradeItem] = []
@onready var grid_container: GridContainer = %GridContainer
@onready var currency_label: Label = %CurrencyLabel

signal back_to_before

var meta_card_item_scene = preload("res://scenes/ui/meta_card_item.tscn")

func _ready() -> void:
	init_meta_upgrade_display()
	GameEvents.purchase_meta_upgrade.connect(on_purchase_meta_upgrade)


func update_currency_display():
	currency_label.text = str(GameMetadata.get_currency())
	


func init_meta_upgrade_display():
	update_currency_display()
	for item in meta_upgrade_list:
		var meta_card_item_instance = meta_card_item_scene.instantiate()
		grid_container.add_child(meta_card_item_instance)
		meta_card_item_instance.set_meta_data(item)


func on_purchase_meta_upgrade(upgrade):
	update_currency_display()


func _on_sound_button_pressed() -> void:
	back_to_before.emit()
