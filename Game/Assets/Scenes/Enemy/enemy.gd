extends CharacterBody2D

@onready var marker: Marker2D = $Gun/Marker
@onready var gun: Polygon2D = $Gun
@onready var animation: AnimationPlayer = $Animation
@onready var health_bar: TextureProgressBar = $HealthBar

var Health := 15

var Accel := 1.0
var Speed := 250
var Damage := 5

var ShootSpeed := 1.2
var ReloadSpeed := .8
var CurrentMag := 15
var MagSize := 150
var MaxMag := 15

var Dir : Vector2

var Reloading := false
var SHOOT := false

var LookPos : Vector2
var LookPlr := 0

func _ready() -> void:
	health_bar.max_value = Health
	randomize()
	await get_tree().create_timer(randf_range(1, 1.5)).timeout
	SHOOT = true

func Movement(delta):
	velocity = Dir
	move_and_slide()

func Shoot():
	CurrentMag -= 1
	var Bullet = preload("res://Game/Assets/Scenes/Bullet/bullet.tscn").instantiate()
	Bullet.global_position = marker.global_position
	Bullet.transform = marker.global_transform
	Bullet.Damage = Damage
	get_tree().root.add_child(Bullet)

func Reload():
	if MagSize >= MaxMag:
		for i in MaxMag:
			CurrentMag += 1
			MagSize -= 1
	else :
		for i in MagSize:
			CurrentMag += 1
			MagSize -= 1
	Reloading = false

func HealthSystem():
	if Health <= 0:
		User.Enemies -= 1
		if User.Enemies <= 0:
			User.WaveWonSignal.emit()
			User.WaveWon = true
			var start = preload("res://Game/Assets/Scenes/Start/start.tscn").instantiate()
			start.global_position = global_position
			get_tree().current_scene.get_node("World/Enviroment").add_child(start)
		randomize()
		if randi() % (100 + User.Luck) <= 15 + User.Luck:
			var Item = preload("res://Game/Assets/Scenes/Item/item.tscn").instantiate()
			Item.global_position = global_position
			get_tree().current_scene.get_node("World/Enviroment").add_child(Item)
		User.Coins += 2 * User.Wave
		User.WaveCoins += 2 * User.Wave
		queue_free()

func _physics_process(delta: float) -> void:
	HealthSystem()
	$HealthBar/Info.text = str(Health)
	health_bar.visible = User.ShowHealth
	health_bar.value = Health
	if SHOOT:
		if CurrentMag >= 1:
			if !Reloading and !animation.current_animation == "Shoot":
				animation.play("Shoot", -1, ShootSpeed)
		else :
			if !Reloading:
				Reloading = true
				animation.play("Reload", -1, ReloadSpeed)
	gun.look_at(User.PlayerPostion)
	Movement(delta)

func ChangeDir(DIR):
	Dir = DIR

func _on_dir_timer_timeout() -> void:
	if !User.Freeze:
		var RandDir = Vector2(randf_range(-200, 200),randf_range(-200, 200))
		ChangeDir(RandDir)

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		Health -= body.Damage
		body.queue_free()
