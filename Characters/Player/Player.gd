extends Character

@onready var weapon: Node2D = get_node("Weapon")
@onready var weapon_hitbox: Area2D = get_node("Weapon/WeaponPivot/WeaponSprite/Hitbox")
@onready var weapon_animation_player: AnimationPlayer = weapon.get_node("WeaponAnimationPlayer")

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	weapon.rotation = mouse_direction.angle()
	weapon_hitbox.knockback_direction = mouse_direction
	if weapon.scale.y == 1 and mouse_direction.x < 0:
		weapon.scale.y = -1
	elif weapon.scale.y == -1 and mouse_direction.x > 0:
		weapon.scale.y = 1
		
	
func get_input() -> void:
	mov_direction = Vector2.ZERO
	if Input.is_action_pressed("movement_down"):
		mov_direction += Vector2.DOWN
	if Input.is_action_pressed("movement_left"):
		mov_direction += Vector2.LEFT
	if Input.is_action_pressed("movement_right"):
		mov_direction += Vector2.RIGHT
	if Input.is_action_pressed("movement_up"):
		mov_direction += Vector2.UP
		
	if Input.is_action_just_pressed("attack_primary") and not weapon_animation_player.is_playing():
		weapon_animation_player.play("attack")
