extends CharacterBody2D

@export var speed := 200
@export var jump_force := -400
var gravity := 980

var bones = 0
var respawn_position: Vector2
var death_y: float = 1200.0
var invulnerable := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	respawn_position = global_position


func _physics_process(delta):
	# Movimiento horizontal
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		animated_sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		animated_sprite.flip_h = true

	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # resetea al tocar el piso

	# Saltar
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_force

	# Muerte si cae demasiado
	if global_position.y > death_y:
		print("Cayó abajo, debería morir")
		die()

	# Movimiento real
	move_and_slide()

	# --------------------------
	# Animaciones
	# --------------------------
	if not is_on_floor():
		animated_sprite.play("jump")
	elif velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("walk")


func add_bone():
	bones += 1
	HUD.bones = bones
	HUD.update_hud()

func _on_hueso_6_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		queue_free() 

func die():
	if invulnerable:
		return
	print("Player murió")
	if $AnimatedSprite2D.sprite_frames.has_animation("death") \
		and $AnimatedSprite2D.sprite_frames.get_frame_count("death") > 0:
			$AnimatedSprite2D.play("death")
	
	set_physics_process(false)
	if $CollisionShape2D:
		$CollisionShape2D.disabled = true
	GameManager.lose_life()
	
	if GameManager.lives > 0:
		var timer = get_tree().create_timer(1.0)
		await timer.timeout
		on_respawn()
	else:
		GameManager.game_over()
	
	

func on_respawn():
	global_position = GameManager.respawn_position
	velocity = Vector2.ZERO
	
	set_physics_process(true)
	if $CollisionShape2D:
		$CollisionShape2D.disabled = false

	invulnerable = true
	var timer = get_tree().create_timer(1.0)
	await timer.timeout
	invulnerable = false
