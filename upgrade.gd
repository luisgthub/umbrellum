extends Area2D

@onready var sprite_weaponC = preload("res://assets/C.png")
@onready var sprite_weaponB = preload("res://assets/B.png")
@onready var sprite_weaponA = preload("res://assets/A.png")
@onready var display_scene = preload("res://number_display.tscn")
@onready var sprite = $Sprite2D
func create_display():
	var inst = display_scene.instantiate()
	inst.global_position = global_position+Vector2(0,-20)
	inst.text = "UPGRADED WEAPON!"
	get_tree().current_scene.add_child(inst)
# Called when the node enters the scene tree for the first time.
var weapon_data =null

var identity_weapon: String	
func _ready() -> void:
	
	identity_weapon = Gmanager.choose_weapon()
	var data = Gmanager.weapons[identity_weapon]
	
	if data.has("powerup"):
		sprite.texture = data["powerup"]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= Gmanager.block_speed*delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("umbrella"):
	#aqui

		Gmanager.count_upgrade_level()
		Gmanager.current_weapon = identity_weapon
		queue_free()
		create_display()
	if global_position.y<=-400:
		queue_free()
