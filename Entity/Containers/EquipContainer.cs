using Godot;
using Godot.Collections;

public partial class EquipContainer : Node3D
{
	[Export] Array<ItemDataEquip> itemsEquipped = new Array<ItemDataEquip>();

    public override void _Ready()
    {
        checkForDuplicates();
    }

	private void checkForDuplicates()
	{

	}
}

// func check_for_duplicates() -> void:
// 	var chest_found := false
// 	var head_found := false
// 	var legs_found := false
// 	for equipment in items_equipped:
// 		if equipment.equip_location == 1 and not head_found:
// 			head_found = true
// 			continue
// 		else:
// 			print_debug("Duplicate Headpiece found on " + self.name)
// 		if equipment.equip_location == 2 and not chest_found:
// 			chest_found = true
// 			continue
// 		else:
// 			print_debug("Duplicate Chestpiece found on " + self.name)
// 		if equipment.equip_location == 3 and not legs_found:
// 			legs_found = true
// 		else:
// 			print_debug("Duplicate legs found on " + self.name)
