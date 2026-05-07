extends CharacterBody2D
enum State {CLOSING,OPENING,OPENED}
var current_state = State.OPENING
@onready var proj_scene = preload("res://projectile.tscn")
@onready var umbrella_colision = $PinJoint2D/umbrella/CollisionShape2D
@onready var anim = $PinJoint2D/umbrella/AnimationPlayer
@onready var mark = $PinJoint2D/umbrella/Marker2D
const speed = 0.3
var is_damage_taken =true
var up_level = 0
func _ready() -> void:
	up_level = Gmanager.upgrade_level
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time =0.6
	mtimer.timeout.connect(shoot)
	mtimer.start()
	
func change_state(new_state):
	current_state = new_state
	match current_state:
		State.CLOSING:
			#umbrella_colision.disabled=false
			anim.play("close")
		State.OPENING:
			#umbrella_colision.disabled=true
			anim.play("open")
						
func _physics_process(delta: float) -> void:
	# get mouse position
	var mouse_pos = get_global_mouse_position()

	if not is_on_floor():
		$AnimationPlayer.play("idle")
	mouse_pos.y = -400
	var direction = global_position.direction_to(mouse_pos)
	#direction.y = 0
	#print(direction)
	global_position = direction.lerp(mouse_pos,speed)
	Gmanager.player_position = global_position
	#lerp angle muda a rotação de forma q vai pelo caminho mais rapido
	#impede de girar sem controle
	#rotation = lerp_angle(rotation,mouse_angle,0.01)
	move_and_slide()
	if get_slide_collision_count() > 0 and is_damage_taken:	
			var colisao = get_slide_collision(0)
			is_damage_taken = false
			print("Bati em: ", colisao.get_collider().name)
			apply_damage()
			await get_tree().create_timer(3.0).timeout
			is_damage_taken = true

func apply_damage():
	Gmanager.player_life-= 5
func _process(delta: float) -> void:
		get_input()
func shoot():
		var scale_value = up_level*0.5
		var offset = 5*scale_value
		var inst = proj_scene.instantiate()
		inst.global_position = mark.global_position +Vector2(0,offset)
		get_tree().current_scene.add_child(inst)
		get_tree().create_timer(5.0).timeout.connect(inst.queue_free)
		#permite que o marker sempre esteja num offset a frente do guardachuva
		inst.scale=Vector2(scale_value,scale_value)
func get_input() -> void:
	if Input.is_action_just_pressed("left_mouse"):
		if current_state==State.OPENING:
			change_state(State.CLOSING)
			print("tempo resetado")
		elif current_state==State.CLOSING:
			print("tempo resetado")
			change_state(State.OPENING)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("proj"):
		if Gmanager.player_life>0:
			Gmanager.player_life-=1
	
