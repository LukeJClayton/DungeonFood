extends Area2D

class_name Item

@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")

@export var health: int = 1;
@export var attack: int = 1;
@export var attack_speed: int = 1;
@export var move_speed: int = 1;

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
