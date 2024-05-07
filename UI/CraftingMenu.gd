extends CanvasLayer

const ITEM_SLOT_SCENE: PackedScene = preload("res://UI/ItemSlot.tscn")

func init(player: CharacterBody2D) -> void:
	var inventory: Node = player.get_node("Inventory")
	var inventory_row = get_node("Items")
	var items: Array = inventory.get_children()
	for item in items:
		var new_inventory_item = ITEM_SLOT_SCENE.instantiate()
		new_inventory_item.init(item)
		inventory_row.add_child(new_inventory_item)
	print(inventory_row.get_children())
