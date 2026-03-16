extends Button

@onready var title: Label = $Title
@onready var info: Label = $Info

var UpgradeSlot := 0
var Price := 0

func Upgrade():
	match UpgradeSlot:
		1:
			User.ReloadSpeed += 0.1 * User.Wave
		2:
			User.Damage += 5 * User.Wave
		3:
			User.MaxHealth += 5 * User.Wave
		4:
			User.ShootSpeed += 0.05 * User.Wave
		5:
			User.DurAdd += 5 * User.Wave
		6:
			User.Guns += 1
		7:
			User.Speed += 10 * User.Wave
		8:
			User.MaxSize += 1 * User.Wave
		9:
			User.MaxMag += 10 * User.Wave
		10:
			User.Luck += 1 * User.Wave
		11:
			User.ShowHealth = true
		12:
			User.AimSight = true
		13:
			User.MaxReRolls += 1


func _on_pressed() -> void:
	if Price == 0:
		Upgrade()
		User.WaveWon = false
		get_parent().get_parent().queue_free()
	else :
		if User.Coins >= Price:
			User.Coins -= Price
			Upgrade()
			visible = false
		else :
			get_parent().get_node("Price").modulate = Color.RED
			await get_tree().create_timer(0.25).timeout
			get_parent().get_node("Price").modulate = Color.WHITE
