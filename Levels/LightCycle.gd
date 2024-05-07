extends DirectionalLight3D

const WAIT_TIMER := 1

var stopped_cycle := false

@export var environment: WorldEnvironment

func _ready():
	start_cycle()

func start_cycle():
	var solar_move_time := 1
	var solar_movement := self.rotation_degrees.x
	
	while not stopped_cycle:
		solar_movement = self.rotation_degrees.x - 1
		var sun_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
		sun_tween.tween_property(self, "rotation_degrees:x", solar_movement, solar_move_time)
		if self.rotation_degrees.x <= -190:
			# night
			self.light_energy = 0
			environment.environment.background_energy_multiplier = 0.4
			self.visible = false
			solar_movement = 60
			solar_move_time = 60
			await sun_tween.tween_property(self, "rotation_degrees:x", solar_movement, solar_move_time).finished
			
			# it's day again
			solar_move_time = 1
			self.visible = true
			self.light_energy = 2
			environment.environment.background_energy_multiplier = 1
			
		await get_tree().create_timer(WAIT_TIMER).timeout
