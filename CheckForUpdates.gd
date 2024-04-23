extends HTTPRequest

func _ready():
	self.set_use_threads(true)
	
	# change request to ping my website, and get the latest update, then run comparison with current
	# version, May run a singleton for current version?
	#self.request_completed.connect(_on_request_completed)
	var headers: PackedStringArray = []
	self.request("http://localhost:9000/getversion", headers, HTTPClient.METHOD_GET)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
#	var data = body.get_string_from_utf8()
#	print(data)
	#var json = JSON.parse_string(body)
	#print(body)
	print(body.get_string_from_utf8())
	print(JSON.parse_string(body.get_string_from_utf8()))
	
