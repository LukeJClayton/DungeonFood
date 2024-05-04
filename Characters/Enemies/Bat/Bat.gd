@icon("res://Art/o_lobster/enemies/flying creature/fly_anim_f0.png")

extends Enemy

@onready var hitbox: Area2D = get_node("Hitbox")


func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()
