extends RigidBody3D

var timer: float = 0.0;
## Newtons of thrust applied to the ship
@export_range(500, 2500)
var thrust: float = 1000;

@export
var torque: float = 100;

var is_transitioning: bool = false;

func wait_for(wait_time: float, callback: Callable) -> void:
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(callback)

func level_end() -> void:
	is_transitioning = true
	set_process(false)
	
func complete_level(next_level: String) -> void:
	level_end()
	wait_for(1.0, get_tree().change_scene_to_file.bind(next_level))
	
func game_over() -> void:
	level_end()
	wait_for(1.0, get_tree().reload_current_scene)

func movement(delta) -> void:
	if(Input.is_action_pressed("thrust")):
		apply_central_force(basis.y * delta * thrust)
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
