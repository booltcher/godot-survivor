extends PanelContainer


@onready var name_label: Label = $%NameLabel
@onready var desc_label: Label = $%DescLabel
@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var cost_label: Label = %CostLabel
@onready var purchase_button: Button = %PurchaseButton

var upgrade: MetadataUpgradeItem = null

func set_meta_data(upgrade: MetadataUpgradeItem):
	self.upgrade = upgrade
	update_display()
	


func update_display():
	var currency = GameMetadata.get_currency()
	name_label.text = upgrade.title
	desc_label.text = upgrade.description
	cost_label.text = str(currency) + "/" + str(upgrade.currency_cost)
	var available = upgrade.currency_cost <= currency
	purchase_button.disabled = !available
	if available:
		cost_label.add_theme_color_override("font_color", Color.WHITE)
	else:
		cost_label.add_theme_color_override("font_color", Color("#b1b1b1"))



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
		
