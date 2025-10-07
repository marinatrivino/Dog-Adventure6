extends Control

@export var game_scene_path := "res://Scenes/Level1.tscn"

func _ready() -> void:
	# Si el HUD está global y lo tenés, ocultarlo al inicio
	if HUD:
		HUD.visible = false

# Detecta cualquier tecla presionada que no haya sido manejada
func _unhandled_input(event: InputEvent) -> void:
	# Solo si se presionó la tecla de acción "ui_accept"
	if event.is_pressed() and event.is_action_pressed("ui_accept"):
		start_game()

func start_game() -> void:
	# Mostrar HUD si es global
	if HUD:
		HUD.visible = true
	get_tree().change_scene_to_file(game_scene_path)
