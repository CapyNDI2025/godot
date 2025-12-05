extends AudioStreamPlayer3D

func _ready() -> void:
	Eventbus.play_step.connect(_on_play_step)

func _on_play_step(step: int) -> void:
	var audio_path = "res://sounds/room%d.mp3" % step
	
	if ResourceLoader.exists(audio_path):
		var audio = load(audio_path)
		stream = audio
		play()
	else:
		print("Audio introuvable: ", audio_path)

func _on_finished() -> void:
	Eventbus.step_over.emit()
