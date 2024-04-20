extends Node

@onready var http_request = $HTTPRequest

func _ready():
	http_request.request_completed.connect(_on_request_completed)
	
	# change request to ping my website, and get the latest update, then run comparison with current
	# version, May run a singleton for current version?
	http_request.request("https://api.github.com/repos/godotengine/godot/releases/latest")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json["name"])
