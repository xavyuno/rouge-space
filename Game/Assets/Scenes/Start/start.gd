extends Area2D

var MinPos := Vector2(32, 32)
var MaxPos := Vector2(1248, 672)

func _ready() -> void:
	User.WaveStartedSignal.connect(WaveStarted)

func WaveStarted():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		User.NewWave = true
		queue_free()
