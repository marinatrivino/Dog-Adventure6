extends Node

var lives: int = 3
var respawn_position: Vector2 = Vector2(100, 100)
signal player_died(lives_left)

func lose_life():
	lives -= 1
	emit_signal("player_died", lives)
	var player = get_tree().get_first_node_in_group("player")
	if lives <= 0:
		game_over()
	elif player:
		player.die()
		respawn_player()

func respawn_player():
	await get_tree().create_timer(0.5).timeout
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.global_position = respawn_position
		player.on_respawn()

func game_over():
	print("GAME OVER")
