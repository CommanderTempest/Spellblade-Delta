extends CharacterBody3D
class_name Player

signal toggle_inventory()

const PICK_UP = preload("res://Item/PickUp/pick_up.tscn")

@export var posture_damage := 20
@export var speed := 2.0
@export var player_damage := 20
@export var state_machine: StateMachine
@export var hurtbox: HurtboxComponent
@export var hitbox: HitboxComponent
@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip
@export var Spawn_Pos: Vector3 = Vector3(0,7,46)

@onready var camera_pivot = $CameraPivot
@onready var smooth_camera = $CameraPivot/SmoothCamera
@onready var animation_player = $AnimationPlayer
@onready var walk_player = $WalkPlayer
@onready var animation_tree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var inventory_interface = $CanvasLayer/InventoryInterface
@onready var hot_bar_inventory = $CanvasLayer/HotBarInventory
@onready var interact_ray = $Torso/InteractRay
@onready var interact_label = $CanvasLayer/NotificationContainer/InteractLabel
@onready var health_component = $HealthComponent
@onready var dialogue = $CanvasLayer/DialogueBox/Dialogue
@onready var dialogue_box = $CanvasLayer/DialogueBox


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory_interface.set_player_inventory_data(inventory_data)
	inventory_interface.set_equip_inventory_data(equip_inventory_data)
	inventory_interface.force_close.connect(toggle_inventory_interface)
	hot_bar_inventory.set_inventory_data(inventory_data)
	hurtbox.hurt.connect(on_hurtbox_hurt)
	health_component.defeated.connect(on_defeat)
	
	PlayerManager.player = self
	
	# registers lootable nodes
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	
	# registers talkable nodes
	for node in get_tree().get_nodes_in_group("conversation"):
		node.toggle_conversation.connect(toggle_conversation_interface)
	

func _process(delta) -> void:
	pass
#	if isWeaponInContact and canTickDamage:
#		if contactEnemy:
#			canTickDamage = false
#			contactEnemy.enemy_take_damage(player_damage)

func _physics_process(delta):
	handle_camera_location()
	
	# Add the gravity.
	if not is_on_floor() and not state_machine.current_state is ClimbState:
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# handles display of UI for pickups
	if interact_ray.is_colliding():
		if interact_ray.get_collider().is_in_group("external_inventory"):
			if not interact_label.visible:
				interact_label.visible = true
		elif interact_ray.get_collider().is_in_group("conversation"):
			if not interact_label.visible:
				interact_label.visible = true
	else:
		if interact_label.visible:
			interact_label.visible = false
	
	if input_dir.is_zero_approx():
		walk_player.play("Idle")
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		walk_player.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		#playback.stop()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: 
		mouse_motion = -event.relative * 0.001
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		toggle_inventory_interface()
	if Input.is_action_just_pressed("interact"):
		interact()

func handle_camera_location() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x,
		-90.0,
		90.0
	)
	
	mouse_motion = Vector2.ZERO

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func getIsSwinging() -> bool:
	if state_machine.current_state is AttackState:
		return state_machine.current_state.isSwinging
	return false
	
func getStatus() -> String:
	if state_machine.current_state is BlockState:
		if state_machine.current_state.isParrying:
			return "Parry"
		elif state_machine.current_state.isBlocking:
			return "Block"
	elif state_machine.current_state is DodgeState:
		if state_machine.current_state.isDodging:
			return "Dodge"
	return "None"

func on_hurtbox_hurt(hurtBy: HitboxComponent):
	# hit by itself
	if hurtBy == hitbox:
		return
	else:
		hurtbox.take_damage(hurtBy.damage_to_deal)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		hot_bar_inventory.hide()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hot_bar_inventory.show()
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()

func toggle_conversation_interface() -> void:
	dialogue_box.visible = not dialogue_box.visible

func interact() -> void:
	if interact_ray.is_colliding():
		if interact_ray.get_collider() is InteractableEntity:
			toggle_conversation_interface()
		else:
			interact_ray.get_collider().player_interact(self)

func get_drop_position() -> Vector3:
	var direction = -global_transform.basis.z
	return global_position + direction

func heal(heal_value: int) -> void:
	health_component.heal(heal_value)

func on_defeat() -> void:
	animation_player.play("Defeat")
	# main menu?
	
	# teleport back here
	health_component.heal(100)
	self.position = Spawn_Pos

func _on_inventory_interface_drop_slot_data(slot_data):
	var pick_up = PICK_UP.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = get_drop_position()
	add_child(pick_up)

func _on_button_pressed():
	self.position = Spawn_Pos
