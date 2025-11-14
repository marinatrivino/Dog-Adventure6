extends JumpStrategy
class_name SingleJump

func jump(player: CharacterBody2D) -> void:
	if player.is_on_floor():
		player.velocity.y = player.jump_force

func reset(player: CharacterBody2D) -> void:
	# No hace nada
	pass
