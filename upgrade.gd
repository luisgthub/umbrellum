extends Area2D

@onready var display_scene = preload("res://number_display.tscn")
@onready var sprite = $Sprite2D
func create_display():
	var inst = display_scene.instantiate()
	inst.global_position = global_position+Vector2(0,-20)
	inst.text = "WEAPON_UPGRADE"
	get_tree().current_scene.add_child(inst)
# Called when the node enters the scene tree for the first time.
var weapon_data 
func _ready() -> void:
	#dict
	weapon_data = Gmanager.weapons[Gmanager.current_weapon]
	Gmanager.current_weapon
	sprite.texture = weapon_data["powerup"]
	
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time =0.5
	mtimer.timeout.connect(anim)
	mtimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= Gmanager.block_speed*delta
func anim():
	$AnimationPlayer.play("basic_spark")
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("umbrella"):
	#aqui
		Gmanager.count_upgrade_level()
		Gmanager.choose_weapon()
		queue_free()
		create_display()
	if global_position.y<=-400:
		queue_free()
