extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_score():
	$score.text ="SCORE: "+str(Gmanager.points)
func deal_damage():
	$life.text ="LIFE: "+str(Gmanager.player_life)
func upgrade_coin():
	$upgrade_coin.text ="UPGRADE COINS: "+str(Gmanager.upgrade_coins)
func actual_upgrade():
	$actual_upgrade.text ="UPGRADE LV: "+str(Gmanager.upgrade_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	add_score()
	deal_damage()
	upgrade_coin()
	actual_upgrade()
	pass
