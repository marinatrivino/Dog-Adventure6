extends Control
@export var game_scene_path := "res://Scenes/Level1.tscn" 

func _ready() -> void:
	$StartButton.pressed.connect(_on_button_pressed)

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)
