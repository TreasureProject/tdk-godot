@tool
extends EditorPlugin

const AUTOLOAD_NAME = "TDK"

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/tdk/tdk.gd")

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
