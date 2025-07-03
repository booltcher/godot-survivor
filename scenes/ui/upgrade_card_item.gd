extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var desc_label: Label = $%DescLabel
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var click_sound: AudioStreamPlayer = $ClickSound

signal select

var disabled = false

func set_upgrade_data(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	desc_label.text = upgrade.description


func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")


func select_card():
	disabled = true
	$AnimationPlayer.play("select")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_cards"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	select.emit()


func play_discard():
	$AnimationPlayer.play("discard")


func _on_gui_input(event: InputEvent) -> void:
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()
		click_sound.play()
		
		

func _on_mouse_entered() -> void:
	$HoverAnimationPlayer.play("hover")
	hover_sound.play()
