extends Area2D

@onready var title: Label = $Title

var Type := 1
var MaxTypes := 4

func _ready() -> void:
	randomize()
	Type = randi() % MaxTypes + 1
	match Type:
		1:
			title.text = "M"
		2:
			title.text = "C"
		3:
			title.text = "K"
		4:
			title.text = "F"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		match Type:
			1:
				User.Multiplier += 1
				User.multiplierDur += User.DurAdd
			2:
				User.Coins += 25
			3:
				User.KillEnemy = true
			4:
				User.Freeze = true
		queue_free()
