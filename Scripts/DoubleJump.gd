extends JumpStrategy
class_name DoubleJump

@export var max_jumps := 2
var jumps_left := 0

func jump(player: CharacterBody2D) -> void:
	if jumps_left > 0:
		player.velocity.y = player.jump_force
		jumps_left -= 1

func reset(player: CharacterBody2D) -> void:
	if player.is_on_floor():
		jumps_left = max_jumps
