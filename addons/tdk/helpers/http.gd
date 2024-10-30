extends Object

var _node : Node

func _init(node: Node) -> void:
	_node = node

func http_get(route: String, extra_headers = {}):
	return await _http_request(route, extra_headers, HTTPClient.METHOD_GET)

func http_post(route: String, body = {}, extra_headers = {}):
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
	_node.add_child(http_request)

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
		if result.body:
			result.body = result.body.get_string_from_utf8()

	http_request.queue_free()

	return result
