extends Area2D
@onready var proj_scene = preload("res://projectile.tscn")
var enemy_speed = 50
@onready var sprite = $Sprite2D
@onready var sprite_proj = load("res://assets/spark.png")
@onready var enemy1 = load("res://enemy/cloud1.png")
@onready var enemy2 = load("res://enemy/cloudeye.png")
@onready var enemy3 = load("res://enemy/blackcloud.png")
@onready var enemy4 = load("res://enemy/cloudeye.png")
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.


func randomize_enemy():
	var enemies_data = {
	enemy1:0.5,
	enemy2:0.25,
	enemy3:0.15,
	enemy4:0.10,
}
	var selected_texture= null
	var sort = randf_range(0.0,1.0)
	var acumulate = 0.0
	for texture in enemies_data:
		acumulate+=enemies_data[texture]
		if sort<=acumulate:
			selected_texture=texture
			break
	if selected_texture!=null:
		sprite.texture = selected_texture
		print("Textura selecionada:",selected_texture.resource_path)
	else:
		print("Atenção: Nenhuma textura selecionada!")
func _ready() -> void:
	randomize_enemy()
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time =0.5
	mtimer.timeout.connect(follow_player)
	mtimer.start()
	
func follow_player():
	global_position = global_position.lerp(Gmanager.player_position,0.1)
	shoot()
func shoot():
	var inst = proj_scene.instantiate()
	inst.proj_speed = -100
	inst.get_node("Sprite2D").texture = sprite_proj
	inst.global_position = $Marker2D.global_position
	get_tree().current_scene.add_child(inst)
	get_tree().create_timer(1.0).timeout.connect(inst.queue_free)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("proj"):
		queue_free()
