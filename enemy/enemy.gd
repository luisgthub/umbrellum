extends Area2D
@onready var proj_scene = preload("res://projectile.tscn")
@onready var lifebar_scene = preload("res://enemy/enemy_lifebar.tscn")
var enemy_life = clamp(6,0,6)
var enemy_speed = 40
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
	enemy1:0.6,
	enemy2:0.4,
	enemy3:0.3,
	enemy4:0.2,
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
var bar_inst
func update_label():
	if bar_inst:
		bar_inst.text = str(enemy_life)
		flash()
func _ready() -> void:
	bar_inst = lifebar_scene.instantiate()
	bar_inst.text = str(enemy_life)
	add_child(bar_inst)
	bar_inst.global_position = $life_bar.global_position
	randomize_enemy()
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time =0.8
	mtimer.timeout.connect(follow_player)
	mtimer.start()
func flash():
	var tween = create_tween()
	tween.tween_property(sprite,"modulate",Color(1,0,0),0.1)
	tween.tween_property(sprite,"modulate",Color(1,1,1),0.1)	
func follow_player():
	global_position = global_position.lerp(Gmanager.player_position,0.1)
	shoot()
func shoot():
	var inst = proj_scene.instantiate()
	inst.proj_speed = -200
	inst.get_node("Sprite2D").texture = sprite_proj
	inst.global_position = $Marker2D.global_position
	inst.modulate = Color(1, 1, 0)
	var particle = inst.get_node("CPUParticles2D")
	particle.amount = 2
	get_tree().current_scene.add_child(inst)
	
func anim():
	if $AnimationPlayer.has_animation("explosion"):
		$AnimationPlayer.play("explosion")
		await $AnimationPlayer.animation_finished
	queue_free()
		
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("proj"):
		update_label()
		enemy_life-=1
		if enemy_life<=0:
			Gmanager.points+=20
			anim()
