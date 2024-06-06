using Godot;
using System;
using System.Reflection;

public partial class PlayerDashState : PlayerState
{
  [Export(PropertyHint.Range, "0,20,0.1")] private float speed = 2f;

  public override void _Ready()
  {
    base._Ready();
  }

  public override void _PhysicsProcess(double delta)
  {
    characterNode.MoveAndSlide();
  }

    public override void _Input(InputEvent @event)
    {
      if (Input.IsActionJustReleased(GameConstants.INPUT_DASH))
      {
        characterNode.Velocity = Vector3.Zero;
        characterNode.StateMachineNode.SwitchState<PlayerIdleState>();
      }
    }

  protected override void EnterState()
  {
    characterNode.AnimPlayerNode.Play(GameConstants.ANIM_DASH);
    characterNode.Velocity = new(
        characterNode.direction.X,0,characterNode.direction.Y
      );
    characterNode.Velocity *= speed;
  }
}
