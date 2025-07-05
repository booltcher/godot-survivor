extends PanelContainer


@onready var name_label: Label = $%NameLabel
@onready var desc_label: Label = $%DescLabel
@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var cost_label: Label = %CostLabel
@onready var purchase_button: Button = %PurchaseButton
@onready var level_label: Label = %LevelLabel

var upgrade: MetadataUpgradeItem = null

func set_meta_data(upgrade: MetadataUpgradeItem):
	self.upgrade = upgrade
	update_display()
	


func update_display():
	var currency = GameMetadata.get_currency()
	var current_level = GameMetadata.save_data["meta_upgrade_list"][upgrade.id]["quantity"]
	name_label.text = upgrade.title
	desc_label.text = upgrade.description
	cost_label.text = str(currency) + "/" + str(upgrade.currency_cost)
	level_label.text = "lv" + str(current_level)
	var enough_currency = upgrade.currency_cost <= currency
	var not_max_level = current_level < upgrade.max_quantity
	var available = enough_currency && not_max_level
	purchase_button.disabled = !available
	if available:
		cost_label.add_theme_color_override("font_color", Color.WHITE)
	else:
		cost_label.add_theme_color_override("font_color", Color("#b1b1b1"))

	purchase_button.text = "Purchase" if not_max_level else "Max"


func select_card():
	$AnimationPlayer.play("select")


func _on_purchase_button_pressed() -> void:
	if(upgrade):
		select_card()
		click_sound.play()
		GameMetadata.add_metadata_upgrade_item(upgrade)
		GameMetadata.set_currency(GameMetadata.get_currency() - upgrade.currency_cost)
		GameMetadata.save()
		get_tree().call_group("meta_cards", "update_display")
		GameEvents.emit_purchase_meta_upgrade(upgrade)
		
