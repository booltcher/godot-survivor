extends Node

signal collect_experience_vial(number: int)
signal update_ability_upgrades(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_hurt

func emit_collect_experience_vial(number: int):
	collect_experience_vial.emit(number)

func emit_update_ability_upgrades(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	update_ability_upgrades.emit(upgrade, current_upgrades)

func emit_player_hurt():
	player_hurt.emit()
