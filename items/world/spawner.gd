extends Marker3D

@export var scene_to_spawn: PackedScene
@export var spawn_interval := 0.8  # Temps entre chaque spawn en secondes
@export var lifetime := 60.0  # Durée de vie de chaque objet spawné
@export var freeze_time := 10.0  # Temps avant que l'objet se figé (en secondes)
@export var max_instances := 50  # Nombre maximum d'objets en même temps
@export var spawn_on_start := true  # Commencer à spawner dès le début

var instances: Array[Node3D] = []
var spawn_timer := 0.0
var is_spawning := false

func _ready() -> void:
	if spawn_on_start:
		start_spawning()

func _process(delta: float) -> void:
	if not is_spawning or not scene_to_spawn:
		return
	
	spawn_timer += delta
	
	# Spawn un nouvel objet
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_instance()

func spawn_instance() -> void:
	# Limite le nombre d'instances
	if instances.size() >= max_instances:
		# Supprimer la plus ancienne
		if instances.size() > 0:
			var oldest = instances.pop_front()
			if is_instance_valid(oldest):
				oldest.queue_free()
	
	# Créer la nouvelle instance
	var instance: Node3D = scene_to_spawn.instantiate()
	add_child(instance)
	instance.global_transform = global_transform
	instances.append(instance)
	
	# Programmer sa destruction
	schedule_deletion(instance)

func schedule_deletion(instance: Node3D) -> void:
	# Attendre avant de figé l'objet
	await get_tree().create_timer(freeze_time).timeout
	
	if is_instance_valid(instance):
		# Figé l'objet s'il a un RigidBody3D
		if instance is RigidBody3D:
			instance.freeze = true
	
	# Attendre avant de le supprimer complètement
	await get_tree().create_timer(lifetime - freeze_time).timeout
	
	if is_instance_valid(instance):
		instances.erase(instance)
		instance.queue_free()

func start_spawning() -> void:
	is_spawning = true

func stop_spawning() -> void:
	is_spawning = false

func clear_all_instances() -> void:
	for instance in instances:
		if is_instance_valid(instance):
			instance.queue_free()
	instances.clear()
