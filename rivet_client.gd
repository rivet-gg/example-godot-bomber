extends Node
class_name RivetClient

var base_url = "https://api.rivet.gg/v1"
var token = "dev_staging.eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.CO7zlOr0MRDum9Cs_zAaEgoQ3TEdjSdYRVKFdM_hpFsQSiIxQi8KEgoQ8LiU6_EFRIm3J_bcUc9y5RoJMTI3LjAuMC4xIg4KB2RlZmF1bHQQx1IYAg.C_ApBjHtgQDYXciEHn2Ktv2rve8OOEuxHqJO2ZXnLeVyQdZAiZE813cFAAFxjo4gCPj4x5vSKNh2RCzWCdUQDA"

func lobby_ready():
	_rivet_post("matchmaker", "/lobbies/ready", "{}")

func _build_url(service, path) -> String:
	return base_url.replace("://", "://" + service + ".") + path
	
func _build_headers() -> PackedStringArray:
	return [
		"Authorization: Bearer " + token,
	]
	
func _rivet_get(service: String, path: String):
	var url = _build_url(service, path)
	print("GET ", url)
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	var error = http_request.request(url, _build_headers())
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _rivet_post(service: String, path: String, body: Variant):
	var url = _build_url(service, path)
	print("POST ", url)

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	var body_json = JSON.new().stringify(body)
	var error = http_request.request(url, _build_headers(), HTTPClient.METHOD_POST, body_json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Request error ", result)
		return
	if response_code != 200:
		push_error("Request failed ", response_code, " ", body.get_string_from_utf8())
		return

	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	print("response ", response_code, " ", response)
