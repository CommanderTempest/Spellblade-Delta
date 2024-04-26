extends HTTPRequest

signal sendUpdateUI(version: String)
@onready var dialogue = $CanvasLayer/DialogueBox/Dialogue

func _ready():
	self.set_use_threads(true)
	
	# change request to ping my website, and get the latest update, then run comparison with current
	# version, May run a singleton for current version?
	
	# version is on: srv515170.hstgr.cloud ?
	# or 77.243.85.93 ?
	#self.request_completed.connect(_on_request_completed)
	var headers: PackedStringArray = []
	print("Sending request")
	self.request("http://localhost:9000/getversion", headers, HTTPClient.METHOD_GET)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
#	var data = body.get_string_from_utf8()
#	print(data)
	#var json = JSON.parse_string(body)
	#print(body)
	print("Received!")
	print(body.get_string_from_utf8())
	print(JSON.parse_string(body.get_string_from_utf8()))
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json["version"]:
		dialogue.visible = true
		dialogue.text = json["version"]
	#sendUpdateUI.emit(json["version"])
	
