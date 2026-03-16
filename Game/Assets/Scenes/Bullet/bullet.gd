extends StaticBody2D

var Speed := 1500
var Damage := 15.0

var PlayerBullet := false

func _physics_process(delta: float) -> void:
	position += transform.x * Speed * delta
