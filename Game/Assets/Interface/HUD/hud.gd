extends Control

@onready var health: Label = $Holder/Health
@onready var bullets: Label = $Holder/Bullets
@onready var wave: Label = $Holder/Wave
@onready var mutliplier: Label = $Holder/Mutliplier
@onready var coins: Label = $Holder/Coins

var Spawned := false

func _ready() -> void:
	User.WaveWonSignal.connect(WaveWon)

func WaveWon():
	var UpgradeUI = preload("res://Game/Assets/Interface/Upgrade/upgrades.tscn").instantiate()
	UpgradeUI.position = Vector2(256, 192)
	add_child(UpgradeUI)

func _physics_process(delta: float) -> void:
	visible = User.GameLoaded
	health.text = "Health: " + str(User.Health)
	coins.text = "Coins: " + str(User.Coins)
	wave.text = "Wave: " + str(User.Wave)
	if User.multiplierDur <= 0:
		mutliplier.visible = false
	else :
		mutliplier.visible = true
		mutliplier.text = "Multiplier: " + str(User.Multiplier) + " | " + str(User.multiplierDur)
	if User.CurrentMag <= 0:
		bullets.text = "Reloading..."
	else :
		bullets.text = "Bullets: " + str(User.CurrentMag) + " | " + str(User.MagSize)
