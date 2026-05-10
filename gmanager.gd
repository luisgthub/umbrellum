extends Node
@onready var gm_over_scene = preload("res://game_over.tscn")
var points = 0
var proj_speed =200
var en_proj_speed = -150
var enemy_speed = clamp(20,20,100)
var player_node: CharacterBody2D = null
var current_weapon="weapon1"
var upgrade_coins = 0
var upgrade_level = 1
var player_life = 30
var enemy_life = clamp(3,0,3)
var player_position = null
var is_game_over = false
var is_attacking = false
#quanto mais diminui o tempo
#mais aumenta a velocidade
var current_time = 2.0
var block_speed = 70
var damage = 1
# Called when the node enters the scene tree for the first time.

var weapons = {
	"weapon1":{
		"sprite":preload("res://assets/proj_player.png"),
		"type":"CC",
		"colision": Vector2(1, 1)
		},
	"weapon2":{
		"sprite":preload("res://assets/triple_bullet.png"),
		"type":"C",
		"powerup":preload("res://assets/C.png"),
		"colision": Vector2(2, 2)
		},
	"weapon3":{
		"sprite":preload("res://assets/triple_purple_bullet.png"),
		"type":"B",
		"powerup":preload("res://assets/B.png"),
		"colision": Vector2(3, 3)
		},
	"weapon4":{
		"sprite":preload("res://assets/five_yellow_bullet.png"),
		"type":"A",
		"powerup":preload("res://assets/A.png"),
		"colision": Vector2(4, 4)
		},
	}

func count_upgrade_level():
	upgrade_coins+= 1

var choosen_weapon = null	
func choose_weapon():
	var weapons_name = weapons.keys()
	var n_weapons = weapons.size()-1
	var sort_weapon = randi_range(1,n_weapons)
	choosen_weapon = weapons_name[sort_weapon]
	return choosen_weapon
	#current_weapon = choosen_weapon	
func _ready() -> void:

	#timer
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time =15
	mtimer.timeout.connect(weapon_timer)
	mtimer.start()
	#end timer
	enemy_life=4
	points = 0
	pass # Replace with function body.
func weapon_timer():
	current_weapon="weapon1"
func game_over():
		is_game_over=true
		print("morto")
		var game_over = gm_over_scene.instantiate()
		get_tree().current_scene.add_child(game_over)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_life = clamp(player_life,0,30)
	if player_life<=0 and not is_game_over:
		player_life=0
		game_over()
			
