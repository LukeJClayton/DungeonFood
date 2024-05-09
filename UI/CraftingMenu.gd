extends Control

@onready var player: CharacterBody2D = get_tree().current_scene.player

var selected_items: Array
const text_template = "{{ NAME }}
Attack: {{ ATTACK }}%
Attack Speed: {{ ATTACK SPEED }}%
Speed: {{ SPEED }}%"

var display_name = "Total"
var attack
var attack_speed
var move_speed

var tooltip: Node
var cook_button: Node

signal end_level()

func init(_player: CharacterBody2D, inventory: Node) -> void:
	attack = 1
	attack_speed = 1
	move_speed = 1

	tooltip = get_node("ItemTooltip")
	cook_button = get_node("CookButton")

	var inventory_grid = get_node("GridContainer")
	var items: Array[Node] = inventory.get_children()
	var slots: Array[Node] = inventory_grid.get_children()
	if items.size() > 0:
		for i in slots.size():
			if items.size() > i and items[i]:
				slots[i].init(items[i])
				
	for slot in slots:
		slot.connect("selection", item_selected)
		slot.connect("hovered", hover_slot)
		
	replace_tooltip(display_name, attack, attack_speed, move_speed)
		
func item_selected(slot, state) -> void:
	if slot.current_item:
		var item = slot.current_item
		cook_button.disabled = false
		if state and selected_items.size() < 3:
			slot.selected.show()
			
			selected_items.append(item)
			
			attack += item.attack_mult - 1
			attack_speed += item.attack_speed_mult - 1
			move_speed += item.move_speed_mult - 1
			if selected_items.size() == 3:
				cook_button.disabled = false
			else:
				cook_button.disabled = true
		elif not state and selected_items.has(item):
			cook_button.disabled = true
			slot.selected.hide()
			
			selected_items.erase(item)
			attack -= item.attack_mult - 1
			attack_speed -= item.attack_speed_mult - 1
			move_speed -= item.move_speed_mult - 1

func hover_slot(slot, state):
	if state:
		var item = slot.current_item
		if item:
			replace_tooltip(item.display_name, item.attack_mult, item.attack_speed_mult, item.move_speed_mult)
	else:
		replace_tooltip(display_name, attack, attack_speed, move_speed)

func replace_tooltip(tooltip_name, tooltip_attack, tooltip_attack_speed, tooltip_speed) -> void:
	var display_text = text_template

	display_text = display_text.replace('{{ NAME }}', tooltip_name)
	display_text = display_text.replace('{{ ATTACK }}', str(to_percent(tooltip_attack)))
	display_text = display_text.replace('{{ ATTACK SPEED }}', str(to_percent(tooltip_attack_speed)))
	display_text = display_text.replace('{{ SPEED }}', str(to_percent(tooltip_speed)))
	
	tooltip.text = display_text

func to_percent(value) -> float:
	value = (value - 1) * 100
	return value

func _on_cook_button_pressed():
	if not cook_button.disabled:
		player.damage = player.damage * attack
		player.attack_speed *= attack_speed
		player.max_speed *= move_speed
		emit_signal("end_level")
		queue_free()
