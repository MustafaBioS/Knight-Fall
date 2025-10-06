extends Node

var coins: int = 0
var inventory: Array = ["Peasant's Sword", "Medicine", "Legendary Sword"]

func remove_item(item_name: String) -> void:
	var index = inventory.find(item_name)
	if index != -1:
		inventory.remove_at(index)
