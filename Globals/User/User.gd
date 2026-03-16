extends Node

signal WaveWonSignal
signal WaveStartedSignal

var PlayerPostion : Vector2

var Coins := 0
var WaveCoins := 0

var Multiplier = 1
var multiplierDur := 0
var DurAdd := 5
var Luck := 0
var ReRolls := 1
var MaxReRolls := 1

var GameLoaded := false
var Restart := false
var NewWave := false
var WaveWon := false
var ReRolling := false
var CanReRoll := true
var Wave := 1
var Enemies := 0

var Health := 100
var MaxHealth := 100
var Speed := 250
var Damage := 15

var ShootSpeed := 1.2
var ReloadSpeed := .5
var CurrentMag := 5
var MagSize := 50
var MaxMag := 5
var MaxSize := 50
var Guns := 1

var KillEnemy := false
var Freeze := false
var ShowHealth := false
var AimSight := false

func _ready() -> void:
	Health = MaxHealth

func _physics_process(delta: float) -> void:
	if multiplierDur <= 0:
		Multiplier = 1
	if Health <= 0:
		Health = MaxHealth
		Enemies = 0
		Restart = true
		if User.WaveCoins >= 1:
			User.Coins -= User.WaveCoins
			User.WaveCoins = 0
		User.multiplierDur = 0
