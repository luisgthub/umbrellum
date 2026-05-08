extends Area2D

var proj_speed = 300
@onready var sprite = $Sprite2D
@onready var colision = $CollisionShape2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
var weapon_data 
func _ready() -> void:
	weapon_data = Gmanager.weapons[Gmanager.current_weapon]
	colision.scale = weapon_data["colision"]
	sprite.texture = weapon_data["sprite"]
	sprite.scale = weapon_data["colision"]
	
func _process(delta: float) -> void:
	position.y +=proj_speed*delta

func _on_area_entered(area: Area2D) -> void:

	if area.is_in_group("enemy"):
		queue_free()
