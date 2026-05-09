extends Area2D


@onready var sprite = $Sprite2D
@onready var colision = $CollisionShape2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
var weapon_data 

func _process(delta: float) -> void:
	position.y +=Gmanager.en_proj_speed*delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("umbrella"):
		Gmanager.player_life-=1
		queue_free()
