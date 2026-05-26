@tool
extends Node

#func _ready() -> void:
	#TinyDrawDebug.cross(Vector3.UP * 10.0, 0.25, Color.RED, 30.0)
	#TinyDrawDebug.cross(Vector3.FORWARD * 3.0, 0.25, Color.RED, 30.0)
	#TinyDrawDebug.capsule(Vector3.UP * 10.0, Vector3.FORWARD * 3.0, 1.0, Color.CORAL, 30.0)
	#
	#TinyDrawDebug.cube(Vector3.UP * 5.0, Vector3(1.0, 2.0, 3.0), Color.PURPLE, 5.0)


func _process(delta: float) -> void:
	TinyDrawDebug.cross(Vector3.UP * 10.0, 0.25, Color.RED)
	TinyDrawDebug.cross(Vector3.FORWARD * 3.0, 0.25, Color.RED)
	TinyDrawDebug.capsule(Vector3.UP * 10.0, Vector3.FORWARD * 3.0, 1.0, Color.CORAL)
	
	TinyDrawDebug.cube(Vector3.UP * 5.0, Vector3(1.0, 2.0, 3.0), Color.PURPLE)

	TinyDrawDebug.sphere(Vector3.ONE * 10.0, 2.0, Color.CHARTREUSE)
	
	TinyDrawDebug.circle(Vector3.ONE * 20)
	
	TinyDrawDebug.line(Vector3.ONE * 15.0, Vector3.ONE * 25.0, Color.BLUE)
