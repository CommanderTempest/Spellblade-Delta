extends Node3D

var inventory: Array[String]


func add_item(item: String):
	# maybe do a check if it's in JSON
	inventory.append(item)

func remove_item(item:String):
	if inventory.has(item):
		inventory.erase(item)
