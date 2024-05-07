extends CanvasLayer

const MIN_HEALTH: int = 23

var max_hp: int = 4

@export var player: CharacterBody2D
@onready var health_bar: TextureProgressBar = get_node("HealthBar")

func init(playerRef) -> void:
	player = playerRef
	max_hp = player.max_hp
	_update_health_bar(100)
	player.connect("hp_changed", _on_player_hp_changed)


func _update_health_bar(new_value: int) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(health_bar, "value", new_value, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)


func _on_player_hp_changed(new_hp: int) -> void:
	var new_health: int = int((100 - MIN_HEALTH) * float(new_hp) / max_hp) + MIN_HEALTH
	_update_health_bar(new_health)
