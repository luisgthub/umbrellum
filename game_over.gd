extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	final_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func final_score():
	$score.text ="FINAL SCORE: "+str(Gmanager.points)


func _on_try_again_pressed() -> void:
	Gmanager.player_life = 10
	Gmanager.points = 0
	Gmanager.upgrade_coins = 0
	Gmanager.upgrade_level = 0
	Gmanager.current_weapon = "weapon1"
	Gmanager.is_game_over=false
	Gmanager.player_node = null
	get_tree().reload_current_scene()
	self.queue_free()
