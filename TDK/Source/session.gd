func start_session(http_request: HTTPRequest, backendWallet: String, approvedTargets: Array, nativeTokenLimitPerTransaction: int = 0, sessionDurationSec: int = 0, sessionMinDurationLeftSec: int = 0, callback: Callable = Callable(self, "_on_request_completed")):
	var request_body = {
		"backendWallet": backendWallet,
		"approvedTargets": approvedTargets,
		"nativeTokenLimitPerTransaction": nativeTokenLimitPerTransaction,  # optional
		"sessionDurationSec": sessionDurationSec,  # optional
		"sessionMinDurationLeftSec": sessionMinDurationLeftSec  # optional
	}
	http_request.connect("request_completed", callback)

	var json_string = JSON.stringify(request_body)

	var headers = ["Content-Type: application/json"]

	var error = http_request.request("http://localhost:16001/tdk-start-session", headers, HTTPClient.METHOD_POST, json_string)

	if error != OK:
		return error
	else:
		return null

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Response: ", body.get_string_from_utf8())
	else:
		print("Request failed with response code: ", response_code, ", Response: ", body.get_string_from_utf8(), " Result: ", result)
