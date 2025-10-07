extends Area2D

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":  
		if body.has_method("add_bone"):
			body.add_bone()
		queue_free()
