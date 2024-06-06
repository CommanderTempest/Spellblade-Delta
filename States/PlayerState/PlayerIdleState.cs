using Godot;
using System;

[GlobalClass]
public partial class PlayerIdleState : PlayerState
{

    public override void _PhysicsProcess(double delta)
    {
      if (characterNode.direction != Vector3.Zero)
      {
        characterNode.StateMachineNode.SwitchState<PlayerMoveState>();
      }
    }

    public override void _Input(InputEvent @event)
    {
      CheckForAttackInput();

      if (Input.IsActionJustPressed(GameConstants.INPUT_DASH)) 
      {
        characterNode.StateMachineNode.SwitchState<PlayerDashState>();
      }
    }

    protected override void EnterState()
    {
      characterNode.AnimPlayerNode.Play(GameConstants.ANIM_IDLE);
    }

    private void CheckForAttackInput()
    {
      
    }
}
