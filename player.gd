extends RigidBody3D

var timer: float = 0.0;
## Newtons of thrust applied to the ship
@export_range(500, 2500)
var thrust: float = 1000;
@export
var torque: float = 100;
var is_transitioning: bool = false;
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var thrust_audio: AudioStreamPlayer3D = $ThrustAudio
var pitch: float = 1.0
func wait_for(wait_time: float, callback: Callable) -> void:
	var tween = create_tween()
	tween.tween_interval(wait_time)
	tween.tween_callback(callback)

func level_end() -> void:
	thrust_audio.stop()
	is_transitioning = true
	set_process(false)
	
func complete_level(next_level: String) -> void:
	success_audio.play()
	level_end()
	wait_for(3.0, get_tree().change_scene_to_file.bind(next_level))
	
func game_over() -> void:
	explosion_audio.play()
	level_end()
	wait_for(3.0, get_tree().reload_current_scene)

func movement(delta) -> void:
	thrust_audio.set_pitch_scale(pitch)
	if(Input.is_action_pressed("thrust")):
		if pitch < 4.0:
			pitch += 0.01
		if(!thrust_audio.playing):
			thrust_audio.play()
		apply_central_force(basis.y * delta * thrust)
	else:
		if pitch > 1.0:
			pitch -= 0.05
		else:
			thrust_audio.stop()

	if(Input.is_action_pressed("rotate_left")):
		apply_torque(Vector3(0.0, 0.0, torque * delta))
	if(Input.is_action_pressed("rotate_right")):
		apply_torque(Vector3(0.0, 0.0, -torque * delta))
	if(Input.is_action_just_pressed("restart_level")):
		get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement(delta);

func _on_body_entered(body: Node) -> void:
	if(is_transitioning == false):
		if("Goal" in body.get_groups()):
			complete_level(body.file_path);
		if("Hazard" in body.get_groups()):
			game_over();
