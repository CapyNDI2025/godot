extends Node

# Event Bus simple pour Godot

signal next_camera_step
signal play_step(step: int)
signal step_over

func _ready():
	print("EventBus initialisé")
