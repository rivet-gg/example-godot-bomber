extends Node

var base_url = "https://api.rivet.gg/v1"

func get_token():
	var token_env = OS.get_environment("RIVET_TOKEN")
	if !token_env.is_empty():
		return token_env
		
	# TODO: Don't hardcode this	
#	return "dev_staging.eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.CO7zlOr0MRDum9Cs_zAaEgoQ3TEdjSdYRVKFdM_hpFsQSiIxQi8KEgoQ8LiU6_EFRIm3J_bcUc9y5RoJMTI3LjAuMC4xIg4KB2RlZmF1bHQQx1IYAg.C_ApBjHtgQDYXciEHn2Ktv2rve8OOEuxHqJO2ZXnLeVyQdZAiZE813cFAAFxjo4gCPj4x5vSKNh2RCzWCdUQDA"
	return "pub_prod.eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.CIL2oIL1MRCCntzE_zAaEgoQtGYeHCV4Q2uRNuK-eW62CCIWGhQKEgoQuEGjxM3_SzSb-wFL3bj9fg.9huD2ANeUelveL_w7oZ0flzxUtrRlepepZ-pEfaDt6ds908Ivgz30O-FsqCvhdxHz_m0pNXSQcfko-krNAFuCQ"


func lobby_ready(body: Variant, on_success: Callable, on_fail: Callable):
	_rivet_request_with_body("POST", "matchmaker", "/lobbies/ready", body, on_success, on_fail)

func find_lobby(body: Variant, on_success: Callable, on_fail: Callable):
	_rivet_request_with_body("POST", "matchmaker", "/lobbies/find", body, on_success, on_fail)

func player_connected(body: Variant, on_success: Callable, on_fail: Callable):
	_rivet_request_with_body("POST", "matchmaker", "/players/connected", body, on_success, on_fail)

func player_disconnected(body: Variant, on_success: Callable, on_fail: Callable):
	_rivet_request_with_body("POST", "matchmaker", "/players/disconnected", body, on_success, on_fail)

func _build_url(service, path) -> String:
	return base_url.replace("://", "://" + service + ".") + path

func _build_headers() -> PackedStringArray:
	return [
		"Authorization: Bearer " + get_token(),
	]
	
func _rivet_request(method: String, service: String, path: String, on_success: Callable, on_fail: Callable):
	var url = _build_url(service, path)
	RivetHelper.rivet_print("%s %s" % [method, url])
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed.bind(on_success, on_fail))

	var error = http_request.request(url, _build_headers())
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		if on_fail != null:
			on_fail.call("Request failed to send: %s" % error)

func _rivet_request_with_body(method: String, service: String, path: String, body: Variant, on_success: Callable, on_fail: Callable):
	var url = _build_url(service, path)
	print("%s %s: %s" % [method, url, body])

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed.bind(on_success, on_fail))

	var body_json = JSON.stringify(body)
	var error = http_request.request(url, _build_headers(), HTTPClient.METHOD_POST, body_json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		if on_fail != null:
			on_fail.call("Request failed to send: %s" % error)

func _http_request_completed(result, response_code, _headers, body, on_success: Callable, on_fail: Callable):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Request error ", result)
		if on_fail != null:
			on_fail.call("Request error: %s" % result)
		return
	if response_code != 200:
		push_error("Request failed ", response_code, " ", body.get_string_from_utf8())
		if on_fail != null:
			on_fail.call("Request failed (%s): %s" % [response_code, body.get_string_from_utf8()])
		return

	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	RivetHelper.rivet_print("Success")
	if on_success != null:
		on_success.call(response)

