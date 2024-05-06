extends Node

var cur_player

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(cur_player)

func get_global_position() -> Vector3:
	return cur_player.global_position
