@tool
extends Node

#func _ready() -> void:
	#TinyDrawDebug.cross(Vector3.UP * 10.0, 0.25, Color.RED, 30.0)
	#TinyDrawDebug.cross(Vector3.FORWARD * 3.0, 0.25, Color.RED, 30.0)
	#TinyDrawDebug.capsule(Vector3.UP * 10.0, Vector3.FORWARD * 3.0, 1.0, Color.CORAL, 30.0)
	#
	#TinyDrawDebug.cube(Vector3.UP * 5.0, Vector3(1.0, 2.0, 3.0), Color.PURPLE, 5.0)


func _process(delta: float) -> void:
	#TinyDrawDebug.line(Vector3(1.0, 0.0, 1.0), Vector3(1.0, 2.0, 1.0), Color.RED)
	#TinyDrawDebug.cube(Vector3(2.0, 0.5, 1.0), Vector3(1.0, 1.0, 1.0), Color.GREEN)
	#TinyDrawDebug.circle(Vector3(3.5, 0.5, 1.0), Vector3.FORWARD, 0.5, Color.BLUE)
	#TinyDrawDebug.sphere(Vector3(5.0, 0.5, 1.0), 0.5, Color.AQUA)
	#TinyDrawDebug.cross(Vector3(6.5, 0.5, 1.0), 1.0, Color.CRIMSON)
	#TinyDrawDebug.cylinder(Vector3(8.0, 0.0, 1.0), Vector3(8.0, 1.0, 1.0), 0.25, Color.BISQUE)
	#TinyDrawDebug.capsule(Vector3(9.5, 0.0, 1.0), Vector3(9.5, 1.25, 1.0), 0.25, Color.DARK_ORANGE)
	
	for i in 3:
		TinyDrawDebug.line(Vector3(1.0, 0.0, 1.1 * i), Vector3(1.0, 2.0, 1.1 * i), Color.RED)
		TinyDrawDebug.cube(Vector3(2.0, 0.5, 1.1 * i), Vector3(1.0, 1.0, 1.0), Color.GREEN)
		TinyDrawDebug.circle(Vector3(3.5, 0.5, 1.1 * i), Vector3.FORWARD, 0.5, Color.BLUE)
		TinyDrawDebug.sphere(Vector3(5.0, 0.5, 1.1 * i), 0.5, Color.AQUA)
		TinyDrawDebug.cross(Vector3(6.5, 0.5, 1.1 * i), 1.0, Color.CRIMSON)
		TinyDrawDebug.cylinder(Vector3(8.0, 0.0, 1.1 * i), Vector3(8.0, 1.0, 1.1 * i), 0.25, Color.BISQUE)
		TinyDrawDebug.capsule(Vector3(9.5, 0.0, 1.1 * i), Vector3(9.5, 1.25, 1.1 * i), 0.25, Color.DARK_ORANGE)
