extends Node

var Http = preload("res://addons/tdk/helpers/http.gd")
var http = Http.new(self)

var _has_parsed_args = false
var _launcher_auth_token = null

func _parse_args():
	if _has_parsed_args:
		return
	var args = OS.get_cmdline_args()
	for arg in args:
		if arg.begins_with("--tdk-auth-token"):
			var split_arg = arg.split("=")
			if split_arg.size() == 2:
				_launcher_auth_token = split_arg[1]
	_has_parsed_args = true

func get_auth_token():
	_parse_args()
	return _launcher_auth_token

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

func get_wallet_address() -> String:
	var running_from_launcher = !!get_auth_token()
	if running_from_launcher:
		return _get_wallet_address_from_auth_token()
	return ""

func _get_wallet_address_from_auth_token():
	var content = get_auth_token().split(".")[1]
	var decoded = Marshalls.base64_to_utf8(content)
	var parsed_jwt = JSON.parse_string(decoded)
	return parsed_jwt.ctx.address
