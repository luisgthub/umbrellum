extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_try_again_pressed() -> void:
	Gmanager.player_life = 10
	Gmanager.points = 0
	Gmanager.is_game_over=false
	get_tree().reload_current_scene()
	self.queue_free()
