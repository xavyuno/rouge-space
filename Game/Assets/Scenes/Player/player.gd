extends CharacterBody2D

@onready var gun:  = $Guns
@onready var animation: AnimationPlayer = $Animation

var MinPos := Vector2(32, 32)
var MaxPos := Vector2(1248, 672)

var Accel := 1.0

var Reloading := false
var Rolling := false

func _ready():
	global_position = Vector2(
			randf_range(MinPos.x, MaxPos.x),
			randf_range(MinPos.y, MaxPos.y)
		)

func GetInputVel():
	var motion := Vector2.ZERO
	motion.y = Input.get_axis("Up", "Down")
	motion.x = Input.get_axis("Left", "Right")
	return motion.normalized() * User.Speed

func Movement(delta):
	velocity = lerp(velocity, GetInputVel(), Accel * delta)
	move_and_slide()

func Shoot():
	User.CurrentMag -= 1
	for i in User.Guns:
		var Bullet = preload("res://Game/Assets/Scenes/Bullet/bullet.tscn").instantiate()
		Bullet.global_position = get_node("Guns/Gun" + str(i + 1) + "/Marker").global_position
		Bullet.transform = get_node("Guns/Gun" + str(i + 1) + "/Marker").global_transform
		Bullet.Damage = User.Damage  * User.Multiplier
		Bullet.PlayerBullet = true
		get_tree().root.add_child(Bullet)

func Reload():
	if User.MagSize >= User.MaxMag:
		for i in User.MaxMag:
			User.CurrentMag += 1
			User.MagSize -= 1
	else :
		for i in User.MagSize:
			User.CurrentMag += 1
			User.MagSize -= 1
	Reloading = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Shoot"):
		if User.CurrentMag >= 1:
			if !Reloading and !animation.current_animation == "Shoot":
				animation.play("Shoot", -1, User.ShootSpeed * User.Multiplier)
				Shoot()
		else :
			if !Reloading:
				Reloading = true
				animation.play("Reload", -1, User.ReloadSpeed * User.Multiplier)
	User.PlayerPostion = global_position
	gun.look_at(get_global_mouse_position())
	if User.WaveWon:
		Rolling = false
	if !User.WaveWon and !Rolling:
		Rolling = true
		for i in gun.get_children():
			i.get_child(1).visible = User.AimSight
			if int(i.name.trim_prefix("Gun")) > User.Guns:
				i.visible = false
			else :
				i.visible = true
	Movement(delta)

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		if !body.PlayerBullet:
			User.Health -= body.Damage
			body.queue_free()
