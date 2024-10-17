@tool
extends PanelContainer

var TDKConfig = preload("res://addons/tdk/resources/tdk_config.gd")

@onready var submit_button = $Container/ConfigJSON/Buttons/Submit
@onready var close_button = $Container/ConfigJSON/Buttons/Close
@onready var config_json_input = $Container/ConfigJSON/Input

signal close_requested

func _ready() -> void:
	close_button.pressed.connect(func(): close_requested.emit())
	submit_button.pressed.connect(_on_submit)

func _on_submit():
	var json_loader = JSON.new()
	var error = json_loader.parse(config_json_input.text)
	if error != Error.OK:
		push_error("Unable to parse config JSON")
		push_error("At line ", json_loader.get_error_line())
		push_error(json_loader.get_error_message())
		return;
	
	var json_dict = json_loader.data
	
	var config = TDKConfig.new()
	config.populate_from_json(json_dict)
	
	ResourceSaver.save(config, "res://addons/tdk/resources/tdk_config.tres")
