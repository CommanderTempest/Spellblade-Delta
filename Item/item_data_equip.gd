extends ItemData
class_name ItemDataEquip

enum EquipLocation {
	Head = 1,
	Chest = 2,
	Legs = 3
}

@export var defence: int
@export var equip_location: EquipLocation
