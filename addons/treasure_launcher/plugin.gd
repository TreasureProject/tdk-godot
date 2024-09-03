@tool
extends EditorPlugin

const AUTOLOAD_NAME = "TreasureLauncher"

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/treasure_launcher/treasure_launcher.gd")

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
