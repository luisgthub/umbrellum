extends Node2D
@onready var mtimer = Timer
@onready var spark_scene = preload("res://spark.tscn")
var spawn_time = 2.0
@onready var origin_one = $origin_one
@onready var origin_two = $origin_two
@onready var origin_three = $origin_three
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time = 2.0
	mtimer.one_shot = false
	mtimer.timeout.connect(create_spark)
	mtimer.start()

func create_spark():
	var inst = spark_scene.instantiate()
	var rand_chance = randi_range(1,3)
	var target_position = Vector2.ZERO
	match rand_chance:
		1:	target_position=origin_one.global_position
		2:	target_position=origin_two.global_position
		3:	target_position=origin_three.global_position
	print(rand_chance)
	inst.global_position = target_position
	get_tree().current_scene.add_child(inst)
