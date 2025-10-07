extends Node2D

# Velocidad de movimiento
@export var velocidad = 100
# Distancia que se moverá a cada lado desde su posición inicial
@export var move_distance = 200

var direccion = 1
var start_position: Vector2

func _ready():
	start_position = global_position  # Guardamos posición inicial
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	

func _process(delta):
	# Mover horizontalmente
	position.x += direccion * velocidad * delta

	# Cambiar dirección al llegar a los límites relativos
	if position.x < start_position.x - move_distance:
		direccion = 1
		$AnimatedSprite2D.flip_h = false

	elif position.x > start_position.x + move_distance:
		direccion = -1
		$AnimatedSprite2D.flip_h = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.name == "Player" and body.has_method("on_respawn"):
	#	body.on_respawn()
	if body.is_in_group("player"):  
		GameManager.lose_life()  
