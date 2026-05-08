extends CharacterBody2D
enum State {CLOSING,OPENING,OPENED}
var current_state = State.OPENING
@onready var proj_scene = preload("res://projectile.tscn")
@onready var umbrella_colision = $PinJoint2D/umbrella/CollisionShape2D
@onready var anim = $PinJoint2D/umbrella/AnimationPlayer
@onready var mark = $PinJoint2D/umbrella/Marker2D
@onready var spritedown = $PinJoint2D/umbrella/Sprite2D
@onready var spriteup = $PinJoint2D/umbrella/Sprite2D2
const speed = 250
var is_damage_taken =true
var up_level = 0
func _ready() -> void:
	Gmanager.player_node = self
	up_level = Gmanager.upgrade_level
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time =0.2
	mtimer.timeout.connect(shoot)
	mtimer.start()
	

func _physics_process(delta: float) -> void:
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
	else:
		spritedown.visible=true
		spriteup.visible=false
		$PinJoint2D/umbrella/AnimationPlayer.play("down")
	move_and_slide()
	
func apply_damage():
	Gmanager.player_life-= 5

func shoot():
		var scale_value = up_level*0.5
		var offset = 5*scale_value
		var inst = proj_scene.instantiate()
		inst.global_position = mark.global_position +Vector2(0,offset)
	
		get_tree().current_scene.add_child(inst)
		get_tree().create_timer(0.5).timeout.connect(inst.queue_free)
		#permite que o marker sempre esteja num offset a frente do guardachuva
		inst.scale=Vector2(scale_value,scale_value)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("proj"):
		if Gmanager.player_life>0:
			Gmanager.player_life-=1
	if area.is_in_group("upgrade"):
		Gmanager.current_weapon = Gmanager.choosen_weapon	
