extends Node2D

@onready var block_scene = preload("res://block.tscn")
@onready var spark_scene = preload("res://spark.tscn")
@onready var bomb_scene = preload("res://bomb.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time = Gmanager.current_time
	mtimer.timeout.connect(set_block_position)
	mtimer.start()
	Gmanager.is_attacking=false

func set_block_position():
	var rand_position_x = randi_range(-16,208)
	var rand_position_y = 400
	var new_position_x = global_position.x+rand_position_x
	var new_position_y =  global_position.y+rand_position_y
	
	create_block(new_position_x,new_position_y)
	
func create_block(value_x,value_y):
	print("valorx",value_x)
	var rand_count = randi_range(1,6)
	var block_h_size = 32
	var vertical_value = 400
	var offset = Vector2(value_x,vertical_value)	
	for x in range(rand_count):
		var inst = block_scene.instantiate()
		inst.global_position = offset

		inst.global_position = Vector2(value_x+(x*block_h_size),value_y)
		get_tree().current_scene.add_child(inst)
		var rand_squad_pos = randi_range(1,3)
		if x>=rand_squad_pos:	
			inst.global_position = Vector2(value_x+32*rand_squad_pos,value_y+34)
	#chance de aparecer

	var randc = randi_range(-16,132)
	create_coins(value_x+randc,value_y+randc)
	var randv = randi_range(-16,132)
	create_bomb(value_x+randv,value_y+randv)
		
		
		
		
func create_coins(value_x,value_y):
	#var random_vertical_value = randf_range(-60,140)
	var offset = Vector2(value_x,value_y)
	var inst = spark_scene.instantiate()
	inst.global_position = offset
	get_tree().current_scene.add_child(inst)

func create_bomb(value_x,value_y):
	#var random_vertical_value = randf_range(-60,140)
	var offset = Vector2(value_x,value_y)
	var inst = bomb_scene.instantiate()
	inst.global_position = offset
	get_tree().current_scene.add_child(inst)
