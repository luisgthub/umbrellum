extends Area2D


# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= Gmanager.block_speed*delta
	if global_position.y<=-400:
		queue_free()
func anim():
	if $AnimationPlayer.has_animation("explosion"):
		$AnimationPlayer.play("explosion")
		await $AnimationPlayer.animation_finished
	queue_free()
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("umbrella"):
		if Gmanager.player_life>0:
			Gmanager.player_life-= 1
		anim()
