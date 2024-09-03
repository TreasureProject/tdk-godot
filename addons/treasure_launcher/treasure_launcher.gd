extends Node

func get_auth_token():
	var args = OS.get_cmdline_args()
	for arg in args:
		if arg.begins_with("--tdk-auth-token"):
			var split_arg = arg.split("=")
			if split_arg.size() == 2:
				var value = split_arg[1]
				return value
	
	return null

func get_user(api_url: String, auth_token: String):
	var http_request = HTTPRequest.new()
	http_request.timeout = 30
	add_child(http_request)

	var headers = ["Content-Type: application/json", "Authorization: " + auth_token]

	var error = http_request.request(api_url + "/users/me", headers, HTTPClient.METHOD_GET)

	var result = {
		"error_code": error,
		"result": null,
		"response_code": null,
		"headers": null,
		"body": null
	}

	if error == OK:
		var req_result = await http_request.request_completed
		result.result = req_result[0]
		result.response_code = req_result[1]
		result.headers = req_result[2]
		result.body = req_result[3]
	
	http_request.queue_free()
	
	return result

func start_session(
	backendWallet: String,
	approvedTargets: Array,
	nativeTokenLimitPerTransaction: int = 0,
	sessionDurationSec: int = 0,
	sessionMinDurationLeftSec: int = 0
):
	var http_request = HTTPRequest.new()
	http_request.timeout = 30
	add_child(http_request)
	
	var request_body = {
		"backendWallet": backendWallet,
		"approvedTargets": approvedTargets,
		"nativeTokenLimitPerTransaction": nativeTokenLimitPerTransaction,  # optional
		"sessionDurationSec": sessionDurationSec,  # optional
		"sessionMinDurationLeftSec": sessionMinDurationLeftSec  # optional
	}

	var json_string = JSON.stringify(request_body)

	var headers = ["Content-Type: application/json"]

	var error = http_request.request("http://localhost:16001/tdk-start-session", headers, HTTPClient.METHOD_POST, json_string)

	var result = {
		"error_code": error,
		"result": null,
		"response_code": null,
		"headers": null,
		"body": null
	}

	if error == OK:
		var req_result = await http_request.request_completed
		result.result = req_result[0]
		result.response_code = req_result[1]
		result.headers = req_result[2]
		result.body = req_result[3]
	
	http_request.queue_free()
	
	return result
