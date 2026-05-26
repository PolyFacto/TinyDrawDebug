@tool
extends Node

func _process(delta: float) -> void:
	for i in 10:
		TinyDrawDebug.line(Vector3(1.0, 0.0, 1.1 * i), Vector3(1.0, 2.0, 1.1 * i), Color.RED)
		TinyDrawDebug.cube(Vector3(2.0, 0.5, 1.1 * i), Vector3(1.0, 1.0, 1.0), Color.GREEN)
		TinyDrawDebug.circle(Vector3(3.5, 0.5, 1.1 * i), Vector3.FORWARD, 0.5, Color.BLUE)
		TinyDrawDebug.sphere(Vector3(5.0, 0.5, 1.1 * i), 0.5, Color.AQUA)
		TinyDrawDebug.cross(Vector3(6.5, 0.5, 1.1 * i), 1.0, Color.CRIMSON)
		TinyDrawDebug.cylinder(Vector3(8.0, 0.0, 1.1 * i), Vector3(8.0, 1.0, 1.1 * i), 0.25, Color.BISQUE)
		TinyDrawDebug.capsule(Vector3(9.5, 0.0, 1.1 * i), Vector3(9.5, 1.25, 1.1 * i), 0.25, Color.DARK_ORANGE)
