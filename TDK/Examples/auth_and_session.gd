extends Node

const AuthToken = preload("res://TDK/Source/auth_token.gd")
const TDKSession = preload("res://TDK/Source/session.gd")

var http_request: HTTPRequest
var tdk_session: TDKSession

# Called when the node enters the scene tree for the first time.
func _ready():
	if http_request == null:
		http_request = HTTPRequest.new()
		add_child(http_request)
		
	var authToken = AuthToken.new().getAuthToken()
	if authToken != null:
		print("Found auth token: ", authToken)
	else:
		print("No auth token found!")
		
	tdk_session = TDKSession.new()
	var error = tdk_session.start_session(http_request, "0x", [], 0, 0, 0, Callable(self, "_on_request_completed"))
	if error != null:
		print("Error initiating request: ", error)
	else:
		print("Request sent successfully")

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Response: ", body.get_string_from_utf8())
	else:
		print("Failed to start session!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
