extends Node

var tdk_config = preload("res://addons/tdk/resources/tdk_config.tres")

func log_info(message):
	if tdk_config.is_debug_logging_enabled():
		print(message)

func log_warning(message):
	if tdk_config.is_debug_logging_enabled():
		push_warning(message)

func log_error(message):
	if tdk_config.is_debug_logging_enabled():
		push_error(message)
