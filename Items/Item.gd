@icon("res://Art/Food/carrot.png")

extends Area2D

class_name Item

@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")

@export var display_name: String = 'Item';
@export var health_mult: float = 0;
@export var attack_mult: float = 0;
@export var attack_speed_mult: float = 0;
@export var move_speed_mult: float = 0;

func _ready() -> void:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var health_value: float = random.randi_range(1, get_tree().current_scene.level)
	health_mult = 1 + (health_mult * health_value)
	
	var attack_value: float = random.randi_range(1, get_tree().current_scene.level)
	attack_mult = 1 + (attack_mult * attack_value)
	
	var attack_speed_value: float = random.randi_range(1, get_tree().current_scene.level)
	attack_speed_mult = 1 + (attack_speed_mult * attack_speed_value)
	
	var move_speed_value: float = random.randi_range(1, get_tree().current_scene.level)
	move_speed_mult = 1 + (move_speed_mult * move_speed_value)

func _on_item_body_entered(player: CharacterBody2D) -> void:
	collision_shape.set_deferred("disabled", true)
	#player.hp += 1 #test - send to inv
	
	var inventory: Node = player.get_node("Inventory")
	
	get_parent().call_deferred("remove_child", self)
	#position = Vector2(0, 0)
	inventory.call_deferred("add_child", self)
	
	var tween: Tween = create_tween().set_parallel()
	modulate.a = 1
	tween.tween_property(self, "modulate:a", 0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", position.y - 16, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.connect("finished", on_tween_finished)


func on_tween_finished() -> void:
	#queue_free()
	pass
