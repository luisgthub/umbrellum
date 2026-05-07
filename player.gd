extends CharacterBody2D
enum State {CLOSING,OPENING,OPENED}
var current_state = State.OPENING
@onready var proj_scene = preload("res://projectile.tscn")
@onready var umbrella_colision = $PinJoint2D/umbrella/CollisionShape2D
@onready var anim = $PinJoint2D/umbrella/AnimationPlayer
const speed = 0.3
var is_damage_taken =true

func _ready() -> void:
	var mtimer = Timer.new()
	add_child(mtimer)
	mtimer.wait_time =0.3
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
	mouse_pos.y = 100
	var direction = global_position.direction_to(mouse_pos)
	#direction.y = 0
	#print(direction)
	global_position = direction.lerp(mouse_pos,speed)
	#lerp angle muda a rotação de forma q vai pelo caminho mais rapido
	#impede de girar sem controle
	#rotation = lerp_angle(rotation,mouse_angle,0.01)
	move_and_slide()
	if get_slide_collision_count() > 0 and is_damage_taken:	
			var colisao = get_slide_collision(0)
			is_damage_taken = false
			print("Bati em: ", colisao.get_collider().name)
			apply_damage()
			await get_tree().create_timer(2.0).timeout
			is_damage_taken = true

func apply_damage():
	Gmanager.player_life-= 5
func _process(delta: float) -> void:
		get_input()
func shoot():
	var inst = proj_scene.instantiate()
	inst.global_position = $PinJoint2D/umbrella/Marker2D.global_position
	get_tree().current_scene.add_child(inst)
	get_tree().create_timer(0.8).timeout.connect(inst.queue_free)

func get_input() -> void:
	if Input.is_action_just_pressed("left_mouse"):
		if current_state==State.OPENING:
			change_state(State.CLOSING)
			Gmanager.current_time=1.0
			print("tempo resetado")
		elif current_state==State.CLOSING:
			Gmanager.current_time=2.0
			print("tempo resetado")
			change_state(State.OPENING)

func _on_umbrella_body_entered(body: Node) -> void:
	print("opa")
	if body.is_in_group("block"):
		Gmanager.player_life-=5
		await get_tree().create_timer(1.0).timeout
