extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Eventbus.step_over.connect(Callable(self, "_on_step_over"))

func _on_pressed() -> void:
	Eventbus.next_camera_step.emit()
	disabled = true
	
func __on_step_over():
	disabled = false
	