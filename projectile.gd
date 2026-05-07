extends Area2D

var proj_speed = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y +=proj_speed*delta
	await get_tree().create_timer(0.5).timeout
