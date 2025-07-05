extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"meta_upgrade_points": 0,
	"meta_upgrade_list": {
		#"item_id": {
			#"quantity": 1
		#}
	}
}


func _ready() -> void:
	GameEvents.collect_experience_vial.connect(on_collect_experience_vial)
	load_save_file()



func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	print("save_data:", save_data)


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_metadata_upgrade_item(upgrade_item: MetadataUpgradeItem):
	if !save_data["meta_upgrade_list"].has(upgrade_item.id):
		save_data["meta_upgrade_list"][upgrade_item.id] = {
			"quantity": 0
		}
	
	save_data["meta_upgrade_list"][upgrade_item.id]["quantity"] += 1


func on_collect_experience_vial(number: int):
	save_data["meta_upgrade_points"] += number
	save()
