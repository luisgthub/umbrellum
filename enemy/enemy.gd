extends Area2D
@onready var proj_scene = preload("res://enemy/enemy_projectile.tscn")
@onready var lifebar_scene = preload("res://enemy/enemy_lifebar.tscn")
var enemy_life = max(4,0)
		
@onready var sprite = $Sprite2D
@onready var sprite_proj = load("res://assets/spark.png")
@onready var enemy1 = load("res://enemy/cloud1.png")
@onready var enemy2 = load("res://enemy/cloudeye.png")
@onready var enemy3 = load("res://enemy/blackcloud.png")
@onready var enemy4 = load("res://enemy/cloudboss.png")
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.


func randomize_enemy():

	var enemies_data = {
	enemy1:0.4,
	enemy2:0.3,
	enemy3:0.2,
	enemy4:0.1,
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
		#print("Textura selecionada:",selected_texture.resource_path)

var bar_inst
func update_label():
	if bar_inst:
		bar_inst.text = str(enemy_life)
		flash()
func _ready() -> void:
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time = 2.0
	mtimer.timeout.connect(shoot)
	mtimer.start()
	
	bar_inst = lifebar_scene.instantiate()
	bar_inst.text = str(enemy_life)
	add_child(bar_inst)
	bar_inst.global_position = $life_bar.global_position
	randomize_enemy()

func _process(delta: float) -> void:
	var vel = Gmanager.enemy_speed
	global_position = global_position.move_toward(Gmanager.player_position,vel*delta)

func flash():
	var tween = create_tween()
	tween.tween_property(sprite,"modulate",Color(1,0,0),0.1)
	tween.tween_property(sprite,"modulate",Color(1,1,1),0.1)	

	
func shoot():
	var inst = proj_scene.instantiate()
	inst.global_position = global_position
	var particle = inst.get_node("CPUParticles2D")
	particle.amount = 16
	get_tree().current_scene.add_child(inst)
	
func anim():
	if $AnimationPlayer.has_animation("explosion"):
		$AnimationPlayer.play("explosion")
		await $AnimationPlayer.animation_finished
	queue_free()
func die_logic():
	is_dead=true
	Gmanager.points+=20
	$dead.play()
var is_dead = false		
func _on_area_entered(area: Area2D) -> void:
	if is_dead: return
	if area.is_in_group("umbrella"):
		Gmanager.player_life-=1
		queue_free()
	if area.is_in_group("proj"):
		$hurt.play()
		$hurt.pitch_scale=randf_range(0.50,0.9)
		enemy_life-=1
		enemy_life = max(enemy_life, 0)
		update_label()
		if enemy_life<=0:
			Gmanager.proj_speed+=0.5
			die_logic()
			anim()
	if global_position.y<=-400:
		queue_free()
