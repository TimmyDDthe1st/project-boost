extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	printText()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func printText():
	print("Hello world")
	print("Don't panic")
	print(42)
