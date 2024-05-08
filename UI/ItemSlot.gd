extends Panel

var item_display: Sprite2D

func init(item: Area2D) -> void:
	item_display = get_node("ItemDisplay")
	var sprite = item.get_node("Sprite2D")
	item_display.texture = sprite.get_texture()
	
func _on_mouse_entered():
	pass
