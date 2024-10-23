extends Node2D

@onready var auth_token_label = $Control/AuthTokenLabel
@onready var request_result_label = $Control/RequestResultLabel
@onready var address_label = $Control/AddressLabel
@onready var copy_token_button = $Control/CopyToken
@onready var get_user_button = $Control/GetUser
@onready var start_session_button = $Control/StartSession
@onready var track_event_button = $Control/TrackCustomEvent
@onready var get_address_button = $Control/GetAddress

func _ready():
	copy_token_button.pressed.connect(_on_copy_token)
	get_user_button.pressed.connect(_on_get_user)
	start_session_button.pressed.connect(_on_start_session)
	track_event_button.pressed.connect(_on_track_event)
	get_address_button.pressed.connect(_on_get_address)

	var auth_token = TDK.get_auth_token()
	if auth_token != null:
		auth_token_label.text = str("Found auth token: ", auth_token)
	else:
		auth_token_label.text = "No auth token found!"

func _on_copy_token():
	DisplayServer.clipboard_set(TDK.get_auth_token())

func _on_get_user():
	var auth_token = TDK.get_auth_token()
	if auth_token != null:
		var result = await TDK.get_user("https://tdk-api.spellcaster.lol", auth_token)
		if result.response_code == 200:
			var user_data = JSON.parse_string(result.body)
			request_result_label.text = str("Response (get_user):\n", JSON.stringify(user_data, "\t"))
		else:
			request_result_label.text = str("An error ocurred. Result:\n", JSON.stringify(result, "\t"))
	else:
		request_result_label.text = "No auth token found!"

func _on_start_session():
	var result = await TDK.start_session("0x", [], 0, 0, 0)
	if result.response_code == 200:
		request_result_label.text = str("Response (start_session):\n", result.body)
	else:
		request_result_label.text = str("An error ocurred. Result:\n", JSON.stringify(result, "\t"))

func _on_track_event():
	TDK.track_custom_event("custom_event", {"custom_event_key": "hello world"})

func _on_get_address():
	var address = TDK.get_wallet_address()
	address_label.text = address
