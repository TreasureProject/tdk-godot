extends Node

const AuthToken = preload("res://logic/TDK/Source/auth_token.gd")
const User = preload("res://logic/TDK/Source/user.gd")

var http_request: HTTPRequest
var user: User

# Called when the node enters the scene tree for the first time.
func _ready():
	if http_request == null:
		http_request = HTTPRequest.new()
		add_child(http_request)
		
    user = User.new()
	var authToken = AuthToken.new().get_auth_token()
	if authToken != null:
		print("Found auth token: ", authToken)
        var err = user.get_user(http_request, "https://tdk-api.spellcaster.lol", authToken, Callable(self, "_on_request_completed"))
	else:
		print("No auth token found!")

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Response: ", body.get_string_from_utf8())
	else:
		print("Failed to get user!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
