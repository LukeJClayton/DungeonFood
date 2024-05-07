@icon("res://Art/o_lobster/enemies/goblin/goblin_idle_anim_f0.png")

extends Character
class_name Enemy

const ITEM_SCENES: Dictionary = {
	"Potato": preload("res://Items/Potato/Potato.tscn"),
	"Carrot": preload("res://Items/Carrot/Carrot.tscn"),
	"Meat": preload("res://Items/Meat/Meat.tscn")
}

@onready var player: CharacterBody2D = get_tree().current_scene.player
@onready var path_timer: Timer = get_node("PathTimer")
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

@export var dropItem: bool = false
@export var itemType: String = "Meat"

func _ready() -> void:
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))


func chase() -> void:
	if not navigation_agent.is_target_reached():
		var vector_to_next_point: Vector2 = navigation_agent.get_next_path_position() - global_position
		mov_direction = vector_to_next_point

		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true


func _on_path_timer_timeout() -> void:
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		path_timer.stop()
		mov_direction = Vector2.ZERO
		
func death() -> void:
	if dropItem:
		var item: Item
		if ITEM_SCENES[itemType]:
			item = ITEM_SCENES[itemType].instantiate()

			item.position = position;
			
			get_parent().call_deferred("add_child", item)


func _get_path_to_player() -> void:
	navigation_agent.target_position = player.position
