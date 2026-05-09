extends StaticBody2D
@onready var display_scene = preload("res://number_display.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time = 1.0
	mtimer.start()
	

func _physics_process(delta: float) -> void:
	position.y -= Gmanager.block_speed*delta
	if position.y>=400:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if global_position.y<=-500:
			queue_free()
