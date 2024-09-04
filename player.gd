extends RigidBody3D

var timer: float = 0.0;
var thrust: float = 1000;
var torque: float = 100;
var gameOver: bool = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!gameOver):
		if(Input.is_action_pressed("thrust")):
			apply_central_force(basis.y * delta * thrust)
		if(Input.is_action_pressed("rotate_left")):
			apply_torque(Vector3(0.0, 0.0, torque * delta))
		if(Input.is_action_pressed("rotate_right")):
			apply_torque(Vector3(0.0, 0.0, -torque * delta))
	if(Input.is_action_just_pressed("restart_level")):
		get_tree().reload_current_scene()


func _on_body_entered(body: Node) -> void:
	if("Goal" in body.get_groups()):
		gameOver = true;
		print("WIN")
	if("Hazard" in body.get_groups()):
		gameOver = true;
		print("LOSE")
