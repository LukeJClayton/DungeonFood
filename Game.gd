extends Node2D

@export var player: CharacterBody2D;
@export var level: int = 1: set = set_level
@onready var ui: CanvasLayer = get_node("UI")

signal level_changed(new_level)

var current_room;
var room_list = [preload("res://Rooms/Room1.tscn"),preload("res://Rooms/Room2.tscn")];
var crafting_menu = preload("res://UI/CraftingMenu.tscn")

func _ready() -> void:
	player = preload("res://Characters/Player/Player.tscn").instantiate()
	ui.init(player)
	change_level()
	
func next_level() -> void:
	var inventory = player.get_node("Inventory")
	player.set_hp(player.max_hp)
	for child in inventory.get_children():
		inventory.remove_child(child)
		child.queue_free()
	set_level(level + 1)
	change_level()
	ui.init(player)
	ui.show()
	
func change_level() -> void:
	if current_room:
		current_room = false

	var random = RandomNumberGenerator.new()
	random.randomize()
	var index: int = random.randi_range(1, room_list.size()) - 1
	var room = room_list[index].instantiate()
	current_room = room;
	call_deferred("add_child", room)
	room.connect("end_level", end_level)

func set_level(new_level: int) -> void:
	level = new_level
	emit_signal("level_changed", level)
	
func end_level() -> void:
	ui.hide()
	var menu = crafting_menu.instantiate()
	call_deferred("add_child", menu)
	menu.init(player, player.get_node('Inventory').duplicate())
	menu.connect("end_level", next_level)
