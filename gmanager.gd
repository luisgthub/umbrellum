extends Node
@onready var gm_over_scene = preload("res://game_over.tscn")
var points = 0
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
func count_upgrade_level():
	upgrade_coins+= 1
	upgrade_level =(upgrade_coins/5)+1
	
func _ready() -> void:
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
			
