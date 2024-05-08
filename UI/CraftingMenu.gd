extends Control

func init(player: CharacterBody2D) -> void:
	var inventory: Node = player.get_node("Inventory")
	var inventory_grid = get_node("GridContainer")
	var items: Array[Node] = inventory.get_children()
	var slots: Array[Node] = inventory_grid.get_children()
	if items.size() > 0:
		for i in slots.size():
			if items.size() > i and items[i]:
				slots[i].init(items[i])
