extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time =0.5
	mtimer.timeout.connect(anim)
	mtimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= Gmanager.block_speed*delta
func anim():

	$AnimationPlayer.play("basic_spark")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("umbrella"):
		Gmanager.player_life= -2
		queue_free()
	if global_position.y<=-400:
		print("exprudi")
		queue_free()
