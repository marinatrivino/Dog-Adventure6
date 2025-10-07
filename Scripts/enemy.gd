extends Node2D

@export var velocidad = 100
@export var move_distance = 200

var direccion = 1
var start_position: Vector2

func _ready():
	start_position = global_position
	$Area2D.body_entered.connect(_on_area_2d_body_entered)

func _process(delta):
	position.x += direccion * velocidad * delta
	if position.x < start_position.x - move_distance:
		direccion = 1
		$AnimatedSprite2D.flip_h = false
	elif position.x > start_position.x + move_distance:
		direccion = -1
		$AnimatedSprite2D.flip_h = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not body.invulnerable:
		GameManager.lose_life()
