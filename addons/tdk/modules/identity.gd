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

func get_user(api_url: String, auth_token: String) -> Dictionary:	
	return await _http_get(api_url + "/users/me", { "Authorization": auth_token })

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

	return await _http_post("http://localhost:16001/tdk-start-session", request_body)

func _http_get(route: String, extra_headers = {}):
	return await _http_request(route, extra_headers, HTTPClient.METHOD_GET)

func _http_post(route: String, body = {}, extra_headers = {}):
	extra_headers["Content-Type"] = "application/json"
	var request_data = JSON.stringify(body)
	return await _http_request(route, extra_headers, HTTPClient.METHOD_POST, request_data)

func _http_request(
	route: String,
	extra_headers: Dictionary,
	method: HTTPClient.Method,
	request_data = ""
):
	var headers = []
	for key in extra_headers:
		var value = extra_headers[key]
		headers.append(str(key,": ",value))

	var http_request = HTTPRequest.new()
	http_request.timeout = 30
	add_child(http_request)

	var error = http_request.request(route, headers, method, request_data)

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
