@tool
extends EditorPlugin

const AUTOLOAD_NAME = "TinyDrawDebug"

func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/tiny_draw_debug/tiny_draw_debug.gd")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
