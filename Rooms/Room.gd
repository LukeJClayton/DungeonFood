extends Node2D

@onready var player: CharacterBody2D = get_parent().player
@onready var level: int = get_parent().level
@onready var player_spawn_position: Node2D = get_node("Map/PlayerSpawnPosition")
@onready var enemy_spawn_positions: Node = get_node("Map/EnemySpawnPositions")
@onready var exit: Area2D = get_node("Map/Exit")

@export var waves = 2;
@onready var wave_enemy_count = enemy_spawn_positions.get_child_count()
@onready var enemy_count = waves * wave_enemy_count

signal end_level()

const ENEMY_SCENES: Array = [
	preload("res://Characters/Enemies/Bat/Bat.tscn"),
	preload("res://Characters/Enemies/Slime/Slime.tscn")
]

func _ready() -> void:
	player.position = player_spawn_position.position
	call_deferred("add_child", player)
	
	spawn_enemies()
	
func spawn_enemies() -> void:
	var spawn_points = enemy_spawn_positions.get_children()
	for point in spawn_points:
		var random = RandomNumberGenerator.new()
		random.randomize()
		var index: int = random.randi_range(1, ENEMY_SCENES.size()) - 1
		var enemy = ENEMY_SCENES[index].instantiate()

		enemy.position = point.position
		call_deferred("add_child", enemy)

func _on_enemy_killed() -> void:
	enemy_count -= 1
	wave_enemy_count -= 1
	
	if enemy_count == 0:
		enable_exit()
	elif wave_enemy_count == 0:
		wave_enemy_count = enemy_spawn_positions.get_child_count()
		spawn_enemies()
		
func enable_exit() -> void:
	var animation_player: AnimationPlayer = exit.get_node("AnimationPlayer")
	animation_player.play("enable")

func _on_exit_body_entered(_body: CharacterBody2D) -> void:
	emit_signal("end_level")
	get_parent().player = _body.duplicate()
	queue_free()
