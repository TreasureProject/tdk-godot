extends Node

var Http = preload("res://addons/tdk/helpers/http.gd")
var http = Http.new(self)

func get_auth_token():
	var args = OS.get_cmdline_args()
	for arg in args:
		if arg.begins_with("--tdk-auth-token"):
			var split_arg = arg.split("=")
			if split_arg.size() == 2:
				var value = split_arg[1]
				return value
	
	return null

func get_user(api_url: String, auth_token: String) -> Dictionary:	
	return await http.http_get(api_url + "/users/me", { "Authorization": auth_token })

func start_session(
	backendWallet: String,
	approvedTargets: Array,
	nativeTokenLimitPerTransaction: int = 0,
	sessionDurationSec: int = 0,
	sessionMinDurationLeftSec: int = 0
) -> Dictionary:
	var request_body = {
		"backendWallet": backendWallet,
		"approvedTargets": approvedTargets,
		"nativeTokenLimitPerTransaction": nativeTokenLimitPerTransaction,  # optional
		"sessionDurationSec": sessionDurationSec,  # optional
		"sessionMinDurationLeftSec": sessionMinDurationLeftSec  # optional
	}

	return await http.http_post("http://localhost:16001/tdk-start-session", request_body)
