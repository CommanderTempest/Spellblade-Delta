extends DirectionalLight3D

const WAIT_TIMER := 1

var stopped_cycle := false

@export var environment: WorldEnvironment

func _ready():
	start_cycle()

func start_cycle():
	while not stopped_cycle:
		self.rotation_degrees.x -= 1
		if self.rotation_degrees.x <= -190:
			self.light_energy = 0
			self.rotation_degrees.x = 60
			environment.environment.background_energy_multiplier = 0.4
		elif self.rotation_degrees.x <= 0:
			self.light_energy = 2
			environment.environment.background_energy_multiplier = 1
		await get_tree().create_timer(WAIT_TIMER).timeout
