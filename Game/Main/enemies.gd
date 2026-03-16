extends Node2D

var MinPos := Vector2(32, 32)
var MaxPos := Vector2(1248, 672)

func _ready() -> void:
	if User.WaveCoins >= 1:
		User.Coins -= User.WaveCoins
		User.WaveCoins = 0
	User.multiplierDur = 0

func SpawnEnemies():
	User.Health = User.MaxHealth
	User.CurrentMag = User.MaxMag
	User.MagSize = User.MaxSize
	User.Freeze = false
	User.CanReRoll = true
	User.WaveCoins = 0
	User.ReRolls = User.MaxReRolls
	for i in User.Wave:
		User.Enemies += 1
		var EnemySpawner = preload("res://Game/Assets/Scenes/EnemySpawner/enemyspawner.tscn").instantiate()
		randomize()
		await get_tree().create_timer(randf_range(1, 2)).timeout
		EnemySpawner.global_position = Vector2(
			randf_range(MinPos.x, MaxPos.x),
			randf_range(MinPos.y, MaxPos.y)
		)
		add_child(EnemySpawner)

func _physics_process(delta: float) -> void:
	if User.Enemies <= 0 and User.NewWave and !User.WaveWon:
		User.WaveStartedSignal.emit()
		User.NewWave = false
		User.Wave += 1
		var SpawnPoint := Vector2(
			randf_range(MinPos.x, MaxPos.x),
			randf_range(MinPos.y, MaxPos.y)
		)
		SpawnEnemies()
	if User.Restart:
		User.Restart = false
		if get_child_count() >= 1:
			for i in get_children():
				i.queue_free()
		SpawnEnemies()
	if User.KillEnemy:
		User.KillEnemy = false
		if get_child_count() > 1:
			get_child(randi() % get_child_count()).Health = 0
		else :
			if get_child_count() == 1:
				if get_child(0).has_meta("Health"):
					get_child(0).Health = 0
