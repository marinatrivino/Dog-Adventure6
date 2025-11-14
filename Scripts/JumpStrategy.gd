extends Resource
class_name JumpStrategy

func jump(player: CharacterBody2D) -> void:
	push_error("Error: jump() no implementado en estrategia hija")
	print("strategy jump ejecutado")
