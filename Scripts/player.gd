extends CharacterBody2D

var jump_strategy: JumpStrategy

@export var speed := 200
@export var jump_force := -480
var gravity := 980

var bones := 0
var respawn_position: Vector2
var death_y: float = 1200.0
var invulnerable := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	respawn_position = global_position
	set_jump_strategy(DoubleJump.new())  # Podés cambiar a SingleJump.new()

func set_jump_strategy(strategy: JumpStrategy) -> void:
	jump_strategy = strategy
	jump_strategy.reset(self)

func _physics_process(delta):
	if GameManager.lives <= 0:
		set_physics_process(false)
		if has_node("CollisionShape2D"):
			$CollisionShape2D.disabled = true
		return

	# Movimiento horizontal
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		animated_sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		animated_sprite.flip_h = true

	# Gravedad
	velocity.y += gravity * delta

	# Salto
	if Input.is_action_just_pressed("ui_accept") and jump_strategy:
		jump_strategy.jump(self)

	# Mover player
	move_and_slide()

	# Reset de estrategia si toca piso
	if jump_strategy:
		jump_strategy.reset(self)

	# Muerte por caída
	if global_position.y > death_y and not invulnerable:
		GameManager.lose_life()
		return

	# Animaciones
	if not is_on_floor():
		animated_sprite.play("jump")
	elif velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func reset_jump_strategy():
	if jump_strategy:
		jump_strategy.reset(self)

func add_bone():
	bones += 1
	HUD.bones = bones
	HUD.update_hud()

func on_respawn():
	if GameManager.lives <= 0:
		return
	global_position = GameManager.respawn_position
	velocity = Vector2.ZERO
	set_physics_process(true)
	invulnerable = true
	var timer = get_tree().create_timer(1.0)
	await timer.timeout
	invulnerable = false
