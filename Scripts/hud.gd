extends CanvasLayer

var bones: int = 0
var full_heart = preload("res://Assets/corazon lleno.png")
var empty_heart = preload("res://Assets/corazon vacio.png")

@onready var hearts = [
	$LivesContainer/Heart1,
	$LivesContainer/Heart2,
	$LivesContainer/Heart3
]

func _ready():
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		var c = Callable(self, "_on_player_died")
		if not gm.player_died.is_connected(c):
			gm.player_died.connect(c)
		update_hearts(gm.lives)
		pintar_corazones()
	else:
		push_error("GameManager no encontrado en /root/GameManager. ¿Lo agregaste como Autoload?")
	
	$BonesLabel.add_theme_font_size_override("font_size", 40)
	update_hud()

func update_hud():
	$BonesLabel.text = "Bones: " + str(bones)
	update_hearts(GameManager.lives)

func update_hearts(current_lives: int):
	for i in range(hearts.size()):
		if i < current_lives:
			hearts[i].texture = full_heart
		else:
			hearts[i].texture = empty_heart

func pintar_corazones():
	for i in range(hearts.size()):
		hearts[i].texture = full_heart
		print(i)

func _on_player_died(lives_left: int) -> void:
	#lives = lives_left
	update_hearts(GameManager.lives)
	
