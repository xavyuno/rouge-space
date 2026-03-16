extends Node2D

func _ready() -> void:
	AddPlayer(1)

func AddPlayer(Id: int):
	var Player = preload("res://Game/Assets/Scenes/Player/player.tscn").instantiate()
	Player.name = str(Id)
	add_child(Player)
