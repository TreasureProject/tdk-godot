extends Node2D

@onready var auth_token_label = $Control/AuthTokenLabel
@onready var request_result_label = $Control/RequestResultLabel
@onready var get_user_button = $Control/GetUser
@onready var start_session_button = $Control/StartSession

func _ready():
	get_user_button.pressed.connect(_on_get_user)
	start_session_button.pressed.connect(_on_start_session)
	
	var auth_token = TreasureLauncher.get_auth_token()
	if auth_token != null:
		auth_token_label.text = str("Found auth token: ", auth_token)
	else:
		auth_token_label.text = "No auth token found!"

func _on_get_user():
	var auth_token = TreasureLauncher.get_auth_token()
	if auth_token != null:
		var result = await TreasureLauncher.get_user("https://tdk-api.spellcaster.lol", TreasureLauncher.get_auth_token())
		if result.response_code == 200:
			var user_data = JSON.parse_string(result.body.get_string_from_utf8())
			request_result_label.text = str("Response (get_user):\n", JSON.stringify(user_data, "\t"))
		else:
			request_result_label.text = str("An error ocurred. Result:\n", JSON.stringify(result, "\t"))
	else:
		request_result_label.text = "No auth token found!"
	
func _on_start_session():
	var result = await TreasureLauncher.start_session("0x", [], 0, 0, 0)
	if result.response_code == 200:
		request_result_label.text = str("Response (start_session):\n", result.body.get_string_from_utf8())
	else:
		request_result_label.text = str("An error ocurred. Result:\n", JSON.stringify(result, "\t"))
