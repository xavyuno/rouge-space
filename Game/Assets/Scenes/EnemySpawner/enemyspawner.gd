extends Node2D

@onready var progress: Polygon2D = $Progress

var Amount := 0.01
var MinPos := Vector2(32, 32)
var MaxPos := Vector2(1248, 672)

func _ready() -> void:
	progress.scale = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if progress.scale < Vector2(1, 1):
		progress.scale += Vector2(Amount, Amount)
	if progress.scale >= Vector2(1, 1):
		var Enemy = preload("res://Game/Assets/Scenes/Enemy/enemy.tscn").instantiate()
		Enemy.global_position = global_position
		Enemy.Health += User.Wave * 5
		Enemy.Damage += User.Wave * 2
		Enemy.Speed += User.Wave * 2
		Enemy.ShootSpeed += User.Wave / 500
		Enemy.ReloadSpeed += User.Wave / 500
		get_tree().current_scene.get_node("World/Enemies").add_child(Enemy)
		queue_free()
