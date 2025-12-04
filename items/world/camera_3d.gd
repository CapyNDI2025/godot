extends Camera3D

# Paramètres de déplacement
@export var speed := 10.0
@export var sprint_multiplier := 2.0
@export var mouse_sensitivity := 0.002

# Paramètres de rotation
var pitch := 0.0
var yaw := 0.0

func _ready():
	# Capture la souris pour le contrôle de la caméra
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Rotation avec la souris
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -PI/2, PI/2)
		
		rotation.x = pitch
		rotation.y = yaw
	
	# Libérer/capturer la souris avec Échap
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	# Vecteur de direction
	var input_dir := Vector3.ZERO
	
	# ZQSD - Détection directe des touches du clavier
	if Input.is_physical_key_pressed(KEY_Z):
		input_dir.z -= 1
	if Input.is_physical_key_pressed(KEY_S):
		input_dir.z += 1
	if Input.is_physical_key_pressed(KEY_Q):
		input_dir.x -= 1
	if Input.is_physical_key_pressed(KEY_D):
		input_dir.x += 1
	
	# Haut/Bas avec Espace et Shift
	if Input.is_physical_key_pressed(KEY_SPACE):
		input_dir.y += 1
	if Input.is_physical_key_pressed(KEY_SHIFT):
		input_dir.y -= 1
	
	# Normaliser pour éviter un déplacement plus rapide en diagonal
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
	
	# Sprint avec Ctrl
	var current_speed = speed
	if Input.is_physical_key_pressed(KEY_CTRL):
		current_speed *= sprint_multiplier
	
	# Appliquer le mouvement dans la direction de la caméra
	var velocity = (transform.basis * input_dir) * current_speed * delta
	global_position += velocity
