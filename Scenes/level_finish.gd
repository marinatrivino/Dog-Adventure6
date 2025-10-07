"""
extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.go_to_next_level()
"""

extends Area2D

var triggered := false  # evita que se dispare varias veces

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return  # ya se activó, no hacer nada
	if body.is_in_group("player"):
		triggered = true
		set_monitoring(false)  # desactiva la detección para que no se repita
		GameManager.go_to_next_level()
