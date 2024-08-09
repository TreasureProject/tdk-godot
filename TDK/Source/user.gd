func get_user(http_request: HTTPRequest, apiUri: String, auth_token: String, callback: Callable = Callable(self, "_on_request_completed")):
	http_request.connect("request_completed", callback)

	var headers = ["Content-Type: application/json", "Authorization: " + auth_token]

	var error = http_request.request(apiUri + "/users/me", headers, HTTPClient.METHOD_GET)

	if error != OK:
		return error
	else:
		return null

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Response: ", body.get_string_from_utf8())
	else:
		print("Request failed with response code: ", response_code, ", Response: ", body.get_string_from_utf8(), " Result: ", result)
