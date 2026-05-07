extends Area2D

@onready var display_scene = preload("res://number_display.tscn")
func create_display():
	var inst = display_scene.instantiate()
	inst.global_position = global_position+Vector2(0,-20)
	inst.text = "+ 1 UPGRADE COIN"
	get_tree().current_scene.add_child(inst)
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
	#aqui
		Gmanager.count_upgrade_level()
		queue_free()
		create_display()
	if global_position.y<=-400:
		print("exprudi")
		queue_free()
