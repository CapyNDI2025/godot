extends AnimationPlayer

func _ready() -> void:
	Eventbus.next_camera_step.connect(_on_next_camera_step)

func _on_next_camera_step() -> void:
	if has_animation("new_animation"):
		if is_playing():
			# Continue l'animation ou avance d'un step
			advance(1.0)  # Avance de 1 seconde
		else:
			play("new_animation")
	else:
		print("Aucune animation 'camera_animation' trouvée")
