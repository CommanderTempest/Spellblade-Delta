using System;
using System.Reflection.Metadata;
using Godot;
public partial class PlayerEntity : CharacterEntity
{
	[ExportCategory("Camera")]
	[Export] private float sensHorizontal = 0.5f;
	[Export] private float sensVertical = 0.5f;
	[Export] private Node3D cameraMount;

    public override void _Ready()
    {
        base._Ready();
				Input.MouseMode = Input.MouseModeEnum.Captured;
    }

    public override void _Input(InputEvent inputEvent)
	{
		if (inputEvent is InputEventMouseMotion)
		{
			if (Input.MouseMode == Input.MouseModeEnum.Captured)
			{
				ProcessCameraMovement((InputEventMouseMotion)inputEvent);
				return;
			}
		}
		else if (inputEvent.IsActionPressed("ui_cancel"))
		{
			if (Input.MouseMode == Input.MouseModeEnum.Visible) {Input.MouseMode = Input.MouseModeEnum.Captured;}
			else {Input.MouseMode = Input.MouseModeEnum.Visible;}
		}
		else if (Input.IsActionJustPressed(GameConstants.INPUT_DASH)) 
    {
      this.speed *= 2;
			// play the sprint/dash animation
    }
		else if (Input.IsActionJustReleased(GameConstants.INPUT_DASH))
		{
			this.speed /= 2;
			// stop playing sprint/dash, start playing idle
		}

		
		Vector2 inputDirection = Input.GetVector(
			GameConstants.INPUT_MOVE_LEFT,
			GameConstants.INPUT_MOVE_RIGHT,
			GameConstants.INPUT_MOVE_FORWARD,
			GameConstants.INPUT_MOVE_BACK
		);
		direction = this.Transform.Basis * new Vector3(inputDirection.X, 0, inputDirection.Y).Normalized();

		
	}

	private void ProcessCameraMovement(InputEventMouseMotion inputEvent)
	{
		RotateY(Mathf.DegToRad(-inputEvent.Relative.X * sensHorizontal));
		cameraMount.RotateX(Mathf.DegToRad(-inputEvent.Relative.Y * sensVertical));
	
		float rotationX = (float) Math.Clamp(cameraMount.RotationDegrees.X, -90.0, 90.0);
		cameraMount.RotationDegrees = new Vector3(rotationX, cameraMount.RotationDegrees.Y, cameraMount.RotationDegrees.Z);
	}
	
}

