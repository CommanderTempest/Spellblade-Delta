using Godot;
using System;

[GlobalClass]
public partial class PlayerIdleState : PlayerState
{

    public override void _PhysicsProcess(double delta)
    {
    }

    public override void _Input(InputEvent @event)
    {
      CheckForAttackInput();
    }

    protected override void EnterState()
    {
      characterNode.AnimPlayerNode.Play(GameConstants.ANIM_IDLE);
      //GD.Print("Spam entering Idle State");
      //characterNode.Velocity = Vector3.Zero;
    }

    private void CheckForAttackInput()
    {
      
    }
}
