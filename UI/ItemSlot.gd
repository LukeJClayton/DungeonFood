extends TextureRect

@onready var border: ReferenceRect = get_node("ReferenceRect")
@onready var item_display: TextureRect

func init(item: Area2D) -> void:
	item_display = get_node("Item")
	var sprite = item.get_node("Sprite2D")
	item_display.texture = sprite.get_texture()
	
func select() -> void:
	border.show()

func deselect() -> void:
	border.hide()
