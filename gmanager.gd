extends Node
@onready var gm_over_scene = preload("res://game_over.tscn")
var points = 0
var current_weapon = null
var upgrade_coins = 0
var upgrade_level = 1
var player_life = max(0,10)
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
		"sprite":preload("res://assets/border.png"),
		"powerup":preload("res://assets/C.png"),
		"colision": Vector2(1, 1)
		},
	"weapon2":{
		"sprite":preload("res://assets/triple_bullet.png"),
		"powerup":preload("res://assets/C.png"),
		"colision": Vector2(2, 2)
		},
	"weapon3":{
		"sprite":preload("res://assets/triple_purple_bullet.png"),
		"powerup":preload("res://assets/B.png"),
		"colision": Vector2(3, 3)
		},
	"weapon4":{
		"sprite":preload("res://assets/five_yellow_bullet.png"),
		"powerup":preload("res://assets/A.png"),
		"colision": Vector2(5, 5)
		},
	}

func count_upgrade_level():
	upgrade_coins+= 1
	upgrade_level =(upgrade_coins/5)+1
	
func choose_weapon():
	var weapons_name = weapons.keys()
	var n_weapons = weapons.size()-1
	var sort_weapon = randi_range(0,n_weapons)
	var choosen_weapon = weapons_name[sort_weapon]
	current_weapon = choosen_weapon	
func _ready() -> void:
	current_weapon="weapon1"

	print(Gmanager.current_weapon)
	
	
	enemy_life=3
	player_life= 10
	points = 0
	pass # Replace with function body.
func game_over():
		is_game_over=true
		print("morto")
		var game_over = gm_over_scene.instantiate()
		get_tree().current_scene.add_child(game_over)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_life==0 and not is_game_over:
		game_over()
			
