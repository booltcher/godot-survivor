class_name WeightedTable

var items: Array[Dictionary] = []
var total_weight = 0


func add_item(item, weight: int):
	items.append({"item": item, "weight": weight})
	total_weight += weight
	
	
func remove_item(item_to_remove):
	items = items.filter(func (element): return element["item"] != item_to_remove)
	total_weight = 0
	for item in items:
		total_weight += item["weight"]
	

func pick_item(exclude: Array = []):
	# remove repeated item
	var adjust_items: Array[Dictionary] = items
	var adjuest_total_weight = total_weight
	
	if exclude.size() > 0:
		adjust_items = []
		adjuest_total_weight = 0
		
		for item in items:
			if item["item"] in exclude:
				continue
			adjust_items.append(item)
			adjuest_total_weight += item["weight"]
	

	var random = randf_range(1, adjuest_total_weight)
	var iteration = 0
	
	for element in adjust_items:
		iteration += element["weight"]
		if random < iteration:
			return element["item"]
