using Godot;
public partial class PlayerEntity : CharacterEntity
{
	public override void _Input(InputEvent @event)
    {
			Vector2 inputDirection = Input.GetVector(
				GameConstants.INPUT_MOVE_LEFT,
				GameConstants.INPUT_MOVE_RIGHT,
				GameConstants.INPUT_MOVE_FORWARD,
				GameConstants.INPUT_MOVE_BACK
			);
			direction = this.Transform.Basis * new Vector3(inputDirection.X, 0, inputDirection.Y).Normalized();
    }
}

