extends Area2D


# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= Gmanager.block_speed*delta
func _ready() -> void:
	$explosion.visible = false
func anim():
	var tween = create_tween()
	$explosion.visible = true	
	if $AnimationPlayer.has_animation("explosion"):
		$AnimationPlayer.play("explosion")
		$explode.play()
		$explode.pitch_scale=randf_range(0.50,0.9)
		await $AnimationPlayer.animation_finished
	queue_free()
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("umbrella"):
		if Gmanager.player_life>0:
			Gmanager.player_life-= 1
		anim()
	if global_position.y<=-400:
			queue_free()
