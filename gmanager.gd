extends Node
@onready var gm_over_scene = preload("res://game_over.tscn")
var points = 0
var player_life = clamp(10,0,10)	
var is_game_over = false
var is_attacking = false
#quanto mais diminui o tempo
#mais aumenta a velocidade
var current_time = 2.0
var block_speed = 100
var base_time = 100
var constant = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	current_time-=0.05*delta
	current_time = max(current_time,0.1)
	block_speed = constant/current_time
	block_speed = max(block_speed,2.000)
	print("timec",current_time)
	print("speed",block_speed)
	if player_life<=0 and not is_game_over:
		game_over()
			
