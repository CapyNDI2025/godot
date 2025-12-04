extends AnimationPlayer

var animation_keyframes = []
var current_keyframe_index = 0
var target_keyframe_time = 0.0
var is_transitioning = false

func _ready() -> void:
	Eventbus.next_camera_step.connect(_on_next_camera_step)
	_extract_keyframes("new_animation")
	_init_at_first_keyframe()

func _extract_keyframes(anim_name: String) -> void:
	if not has_animation(anim_name):
		return
	
	var anim = get_animation(anim_name)
	var times = []
	
	for track_idx in range(anim.get_track_count()):
		for key_idx in range(anim.track_get_key_count(track_idx)):
			var time = anim.track_get_key_time(track_idx, key_idx)
			if time not in times:
				times.append(time)
	
	times.sort()
	animation_keyframes = times
	print("Keyframes trouvés: ", animation_keyframes)

func _init_at_first_keyframe() -> void:
	if animation_keyframes.is_empty():
		return
	
	play("new_animation")
	seek(animation_keyframes[0], true)
	pause()
	current_keyframe_index = 0

func _on_next_camera_step() -> void:
	if animation_keyframes.is_empty() or is_transitioning:
		return
	
	current_keyframe_index += 1
	if current_keyframe_index >= animation_keyframes.size():
		current_keyframe_index = 0
	
	target_keyframe_time = animation_keyframes[current_keyframe_index]
	is_transitioning = true
	play("new_animation")

func _process(delta: float) -> void:
	if is_transitioning and is_playing():
		if current_animation_position >= target_keyframe_time:
			pause()
			seek(target_keyframe_time, true)
			is_transitioning = false
