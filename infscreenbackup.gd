extends Node2D

@onready var block_scene = preload("res://floor.tscn")
@onready var spark_scene = preload("res://spark.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time = Gmanager.current_time
	mtimer.timeout.connect(set_block_position)
	mtimer.start()
	Gmanager.is_attacking=false
func set_block_position():
	var offset_x = 64
	var offset_y = -256
	var rand_position_x = randi_range(-48,48)
	var rand_position_y = randi_range(64,128)
	if rand_position_x>=0:
		create_block(rand_position_x+offset_x,rand_position_y-offset_y)
	else:
		create_block(rand_position_x-offset_x,rand_position_y-offset_y)
func create_block(value_x,value_y):
	var random_vertical_value = randf_range(value_y,140)
	var offset = Vector2(value_x,random_vertical_value)
	var inst = block_scene.instantiate()
	inst.global_position = offset
	get_tree().current_scene.add_child(inst)
	create_coins(inst)

func _process(delta: float) -> void:
	print("speedd de queda",Gmanager.current_time)
	if Gmanager.is_attacking:
		Gmanager.current_time-=0.1*delta	
	elif Gmanager.is_attacking:
		Gmanager.is_attacking=false
		Gmanager.current_time=2.0
		
func create_coins(inst):
	var rand_chance = randi_range(0,1)
	var instc = spark_scene.instantiate()
	match rand_chance:
		0:return
		1: 
			inst.add_child(instc)
			instc.global_position = inst.global_position + Vector2(0,60)
			instc.scale=Vector2(1,1)/inst.scale
