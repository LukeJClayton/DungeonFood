extends Panel

var item_display: Sprite2D
var mouse_over: bool
var current_item: Area2D

@onready var selected: Sprite2D = get_node("Selected")

signal selection(item, is_selected)
signal hovered(item, is_hovered)

func init(item: Area2D) -> void:
	item_display = get_node("ItemDisplay")
	var sprite = item.get_node("Sprite2D")
	item_display.texture = sprite.get_texture()
	current_item = item

func _on_gui_input(event):
	if (event is InputEventMouseButton && event.pressed) and current_item:
		if selected.visible:
			#selected.hide()
			emit_signal("selection", self, false)
		else:
			#selected.show()
			emit_signal("selection", self, true)


func _on_mouse_entered():
	emit_signal("hovered", self, true)


func _on_mouse_exited():
	emit_signal("hovered", self, false)
