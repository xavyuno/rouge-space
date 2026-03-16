extends Timer

func _on_timeout() -> void:
	if User.multiplierDur >= 1:
		User.multiplierDur -= 1
