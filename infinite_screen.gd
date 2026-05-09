extends Node2D

@onready var block_scene = preload("res://block.tscn")
@onready var heal_block_scene = preload("res://block/heal_block.tscn")
@onready var upgrade_scene = preload("res://upgrade.tscn")
@onready var bomb_scene = preload("res://bomb.tscn")
@onready var enemy_scene = preload("res://enemy/enemy.tscn")
@onready var coin_scene = preload("res://coin.tscn")

# Called when the node enters the scene tree for the first time.
var player = null
func _ready() -> void:
	player = Gmanager.player_node
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time = Gmanager.current_time
	mtimer.timeout.connect(set_block_position)
	mtimer.start()
	Gmanager.is_attacking=false

func set_block_position():
	var rand_position_x = randi_range(-16,170)
	var rand_position_y = 400
	var new_position_x = global_position.x+rand_position_x
	var new_position_y =  global_position.y+rand_position_y
	var rand_coin = randi_range(-16,60)
	var rand_up_pos_x = randi_range(-16,170)	
	var rand_up_pos_y = randi_range(380,380)
	#gera numero aleatorio

	var chance_enemy = min(60 + Gmanager.upgrade_coins / 10, 80)
	var chance_bomb = min(20 + Gmanager.upgrade_coins / 10, 40)
	var choose_random_item = randi_range(1,100)
	#create block
	create_block(new_position_x,new_position_y)
	
	spawn_coins(rand_coin,new_position_y+rand_coin)
	if randi_range(1, 100) <= 10:
		create_upgrade(rand_up_pos_x,rand_up_pos_y)	
	elif randi_range(1, 100) <=25:
		create_heal_block(rand_position_x,new_position_y)		
	elif randi_range(1, 100) <= chance_bomb:
		create_bomb(rand_position_x,new_position_y)
	elif choose_random_item<=chance_enemy:
		var rand_qt = randi_range(1,3)

		for i in rand_qt:
			var vary_x = randi_range(-40, 40)
			var vary_y = randi_range(-40, 40)
			create_enemy(rand_position_x+vary_x,new_position_y+vary_y)

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

func create_heal_block(value_x,value_y):
	print("heal block criado")
	#var random_vertical_value = randf_range(-60,140)
	var offset = Vector2(value_x,value_y)
	var inst = heal_block_scene.instantiate()
	inst.global_position = offset
	get_tree().current_scene.add_child(inst)

func create_upgrade(value_x,value_y):
	#var random_vertical_value = randf_range(-60,140)
	var offset = Vector2(value_x,value_y)
	var inst = upgrade_scene.instantiate()
	inst.global_position = offset
	get_tree().current_scene.add_child(inst)

func create_coin(value_x,value_y):
	#var random_vertical_value = randf_range(-60,140)
	var offset = Vector2(value_x,value_y)
	var inst = coin_scene.instantiate()
	inst.global_position = offset
	get_tree().current_scene.add_child(inst)
	
func create_bomb(value_x,value_y):
	#var random_vertical_value = randf_range(-60,140)
	var offset = Vector2(value_x,value_y)
	var inst = bomb_scene.instantiate()
	inst.global_position = offset
	get_tree().current_scene.add_child(inst)

func create_enemy(value_x,value_y):
	#var random_vertical_value = randf_range(-60,140)
	var offset = Vector2(value_x,value_y)
	var inst = enemy_scene.instantiate()
	inst.global_position = offset
	get_tree().current_scene.add_child(inst)
	
func spawn_coins(pos_x, pos_y):
	var formation_type = randi_range(1, 2)
	
	if formation_type == 1: # Linha Horizontal
		for i in range(3):
			create_coin(pos_x + (i * 60), pos_y)
	elif formation_type == 2: # Triângulo
		create_coin(pos_x, pos_y)
		create_coin(pos_x - 40, pos_y + 40)
		create_coin(pos_x - 80, pos_y + 40)	
		
func _process(delta: float) -> void:
	
	if Gmanager.player_node:
		var screen_size = get_viewport_rect().size
		var marginx = 142
		var marginy = -180

		# Limitamos a posição do player diretamente pelo script do mapa
		Gmanager.player_node.global_position.x = clampf(Gmanager.player_node.global_position.x, -marginx, screen_size.x -1010)
		Gmanager.player_node.global_position.y = clampf(Gmanager.player_node.global_position.y, marginy, screen_size.y - 650)
		
	
