extends Control

@onready var holder: HBoxContainer = $Holder

var Rolling := false
var UpgradeSlot := -1
var Slots = []
var TotalSlots = 13
var UpgradeChildren = []

func _ready() -> void:
	visible = false
	UpgradeChildren = [
		$Holder/Upgrade1,
		$Holder/Upgrade2,
		$Holder/Upgrade3,
		$UpgradeBuy
	]

func _physics_process(delta: float) -> void:
	$Price.text = "Buy: " + str($UpgradeBuy.Price)
	$ReRoll.visible = User.CanReRoll
	$ReRoll.text = "ReRolls Left: " + str(User.ReRolls)
	visible = User.WaveWon
	if !User.WaveWon or User.ReRolling:
		User.ReRolling = false
		Rolling = false
	if User.WaveWon and !Rolling:
		Rolling = true
		$UpgradeBuy.Price = 5 * User.Wave
		Slots = []
		for i in TotalSlots:
			if User.Guns == 24 and i + 1 == 6:
				pass
			elif User.ShowHealth and i + 1 == 11:
				pass
			elif User.AimSight and i + 1 == 12:
				pass
			else :
				Slots.append(i + 1)
		for i in UpgradeChildren:
			randomize()
			UpgradeSlot = Slots[randi() % Slots.size()]
			Slots.erase(UpgradeSlot)
			i.visible = true
			RandUpgrade(i, UpgradeSlot)

func RandUpgrade(NODE, us):
	match UpgradeSlot:
		1:
			SetUpgrade(NODE,"Reloader",
			"Increases reloading speed \n Reload Speed: " + str(User.ReloadSpeed) + " +" + str(0.1 * User.Wave))
		2:
			SetUpgrade(NODE,"Tank", "Increases Damage\n Damage: " + str(User.Damage) + " +" + str(5 * User.Wave))
		3:
			SetUpgrade(NODE,"Hit Taker", "Increases Max Health\n Health: " + str(User.MaxHealth) + " +" + str(5 * User.Wave))
		4:
			SetUpgrade(NODE,"Shooter", "Increases Shoot Speed\n Shoot Speed: " + str(User.ShootSpeed) + " +" + str(0.05 * User.Wave))
		5:
			SetUpgrade(NODE,"Time Manipulation", "Increases the total time added for multipliers\n Multiplier Duration: " + str(User.DurAdd) + " +" + str(5 * User.Wave))
		6:
			SetUpgrade(NODE,"Gun slinger", "Increases the amount of guns attached to you \n" + str(User.Guns) + " +1")
		7:
			SetUpgrade(NODE,"Speedster", "Increases your speed \n" + str(User.Speed) + " +" + str(10 * User.Wave))
		8:
			SetUpgrade(NODE,"Magot", "Increase the max ammo per mag you can carry \n" + str(User.MaxSize) + " +" + str(1 * User.Wave))
		9:
			SetUpgrade(NODE,"Horder", "Increases your Max Mag size \n" + str(User.MaxMag) + " +" + str(10 * User.Wave))
		10:
			SetUpgrade(NODE,"Luck of the sea", "Increases the chances of enemies dropping items \n" + str(User.Luck) + " +" + str(1 * User.Wave))
		11:
			SetUpgrade(NODE,"Medic", "See the health of enemies")
		12:
			SetUpgrade(NODE,"Sniper", "Mounts a Laser to your gun")
		13:
			SetUpgrade(NODE,"Tumble weed", "Increases Max rerolls")

func SetUpgrade(NODE,Name: String, Info: String):
	NODE.title.text = Name
	NODE.info.text = Info
	NODE.UpgradeSlot = UpgradeSlot


func _on_re_roll_pressed() -> void:
	User.ReRolling = true
	User.ReRolls -= 1
	if User.ReRolls <= 0:
		User.CanReRoll = false
