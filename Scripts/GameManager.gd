extends Node

@export var levels := ["res://Scenes/Level1.tscn", "res://Scenes/Level2.tscn"]
var current_level_index := 0
var lives: int = 3
var respawn_position: Vector2 = Vector2(100, 100)

signal player_died(lives_left)

func lose_life():
	if lives <= 0:
		return
	lives -= 1
	emit_signal("player_died", lives)

	var player = get_tree().get_first_node_in_group("player")
	if lives > 0 and player:
		player.on_respawn()
	else:
		game_over()

func game_over():
	print("GAME OVER")
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_physics_process(false)
		if player.has_node("CollisionShape2D"):
			player.get_node("CollisionShape2D").disabled = true
			player.velocity = Vector2.ZERO     # detiene movimiento residual
	# Emitimos la señal para actualizar el HUD
	emit_signal("player_died", 0)
	# Esperamos un frame antes de cambiar de escena
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	lives = 3
	
	
	HUD.update_hearts(lives)
	

func go_to_next_level():
	# Primero verificamos si es el último nivel
	if current_level_index + 1 < levels.size():
		# Hay otro nivel
		current_level_index += 1
		await get_tree().process_frame
		get_tree().change_scene_to_file(levels[current_level_index])
	else:
		print("¡Felicidades, completaste todos los niveles!")
		await go_to_main_menu()

func go_to_main_menu():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_physics_process(false)
		if player.has_node("CollisionShape2D"):
			player.get_node("CollisionShape2D").disabled = true
			player.velocity = Vector2.ZERO

	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
