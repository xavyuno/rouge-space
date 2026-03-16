extends Control

var MinPos := Vector2(32, 32)
var MaxPos := Vector2(1248, 672)

func _on_singleplayer_pressed() -> void:
	User.GameLoaded = true
	var Start = preload("res://Game/Assets/Scenes/Start/start.tscn").instantiate()
	Start.global_position = Vector2(
			randf_range(MinPos.x, MaxPos.x),
			randf_range(MinPos.y, MaxPos.y)
		)
	get_tree().current_scene.get_node("World/Enviroment").add_child(Start)
	queue_free()
