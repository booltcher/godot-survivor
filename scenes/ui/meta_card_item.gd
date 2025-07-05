extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var desc_label: Label = $%DescLabel
@onready var click_sound: AudioStreamPlayer = $ClickSound


func set_meta_data(upgrade: MetadataUpgradeItem):
	name_label.text = upgrade.name
	desc_label.text = upgrade.description


func select_card():
	$AnimationPlayer.play("select")


func _on_purchase_button_pressed() -> void:
	select_card()
	click_sound.play()
