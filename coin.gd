extends Area2D
@onready var display_scene = preload("res://number_display.tscn")

func _process(delta: float) -> void:
	position.y -= Gmanager.block_speed*delta
func create_display():

	var inst = display_scene.instantiate()
	inst.global_position = global_position+Vector2(0,-20)
	inst.text = "+ 15"
	get_tree().current_scene.add_child(inst)
func _on_area_entered(area: Area2D) -> void:

	if area.is_in_group("umbrella"):
		Gmanager.points+= 15
		Gmanager.upgrade_coins +=1
		Gmanager.enemy_speed+=0.5
		Gmanager.en_proj_speed-=0.5

		create_display()
		queue_free()
	if global_position.y<=-400:
		queue_free()
