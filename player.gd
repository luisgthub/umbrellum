extends CharacterBody2D
enum State {CLOSING,OPENING,OPENED}
var current_state = State.OPENING
@onready var proj_scene = preload("res://projectile.tscn")
@onready var umbrella_colision = $PinJoint2D/umbrella/CollisionShape2D
@onready var anim = $PinJoint2D/umbrella/AnimationPlayer
@onready var mark = $PinJoint2D/umbrella/Marker2D
@onready var spritedown = $PinJoint2D/umbrella/Sprite2D
@onready var spriteup = $PinJoint2D/umbrella/Sprite2D2
const speed = 200
var is_damage_taken =true
var up_level = 0
func _ready() -> void:
	Gmanager.player_node = self
	up_level = Gmanager.upgrade_level
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time =0.3
	mtimer.timeout.connect(shoot)
	mtimer.start()
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		Gmanager.player_life = 20
		Gmanager.points = 0
		Gmanager.upgrade_coins = 0
		get_tree().reload_current_scene()	
		
	# get mouse position
	var mouse_pos = get_global_mouse_position()
	var direction =global_position.direction_to(mouse_pos)
	var distance = global_position.distance_to(mouse_pos)
	if distance >10:
		var target_vel = direction*speed
		velocity= velocity.lerp(target_vel,0.9)
	else:
		velocity=Vector2.ZERO
	#mouse_pos.y = -400
	Gmanager.player_position = global_position
	if direction.y<0:
		spriteup.visible=true
		spritedown.visible=false
		$PinJoint2D/umbrella/AnimationPlayer.play("up")
		$PinJoint2D/umbrella/Marker2D.position=Vector2(-8,-35)
	else:
		spritedown.visible=true
		spriteup.visible=false
		$PinJoint2D/umbrella/AnimationPlayer.play("down")
		$PinJoint2D/umbrella/Marker2D.position=Vector2(0,-35)
	move_and_slide()
	

func shoot():
		$hit.play()
		$hit.pitch_scale=randf_range(0.50,0.9)
		var scale_value = up_level*0.5
		var offset = 5*scale_value
		var inst = proj_scene.instantiate()
		inst.global_position = mark.global_position +Vector2(0,offset)
	
		get_tree().current_scene.add_child(inst)
		get_tree().create_timer(1.0).timeout.connect(inst.queue_free)
		#permite que o marker sempre esteja num offset a frente do guardachuva
		inst.scale=Vector2(scale_value,scale_value)

func _on_area_entered(area: Area2D) -> void:

	if area.is_in_group("proj"):
		if Gmanager.player_life>0:
			Gmanager.player_life-=1
			
		var tween = create_tween()
		tween.tween_property(spriteup,"modulate",Color(1,0,0),0.2)
		tween.tween_property(spritedown,"modulate",Color(1,0,0),0.2)
		tween.tween_property(spriteup,"modulate",Color(1,1,1),0.3)
		tween.tween_property(spritedown,"modulate",Color(1,1,1),0.3)
	if area.is_in_group("upgrade"):
		Gmanager.current_weapon = Gmanager.choosen_weapon	
	if area.is_in_group("coin"):
		Gmanager.enemy_speed+=Gmanager.upgrade_coins/50
		print(Gmanager.enemy_speed)
		$coin.play()
		$coin.pitch_scale=randf_range(0.60,0.8)
	if area.is_in_group("upgrade"):
		$upgrade.play()
		$upgrade.pitch_scale=randf_range(0.50,0.9)
	if area.is_in_group("heal_block"):
		$heal.play()
		$heal.pitch_scale=randf_range(0.50,0.9)
