public partial class PlayerEntity : CharacterEntity
{
	// Movement allowed in here?
}

// extends CharacterEntity
// class_name PlayerEntity

// @export_group("Camera Sensitivity")
// @export var sens_horizontal := 0.5 # sensitivity-horizontal
// @export var sens_vertical := 0.5

// @onready var player_controller: PlayerController = $PlayerController
// @onready var camera_mount = $CameraMount

// var mouse_motion := Vector2.ZERO

// func _ready() -> void:
// 	super._ready()
// 	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
// 	PlayerManager.cur_player = self

// func _input(event: InputEvent) -> void:
// 	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
// 		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
// 		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
// 		camera_mount.rotation_degrees.x = clampf(
// 			camera_mount.rotation_degrees.x,
// 			-90.0,
// 			90.0
// 		)
// 	if event.is_action_pressed("ui_cancel"):
// 		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
// 			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
// 		else:
// 			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
