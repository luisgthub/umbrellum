extends Area2D
@onready var display_scene = preload("res://number_display.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("basic_spark")
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time = 1.0
	mtimer.start()
	

func _physics_process(delta: float) -> void:
	position.y -= Gmanager.block_speed*delta
	if position.y>=-500:
		queue_free()

func create_display():
	var inst = display_scene.instantiate()
	inst.global_position = global_position+Vector2(0,-20)
	inst.text = "+ 1 life"
	get_tree().current_scene.add_child(inst)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("umbrella"):
		Gmanager.player_life+=1
		create_display()
		queue_free()
