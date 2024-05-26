using System.Diagnostics;
using Godot;

public partial class IdleState : PlayerState
{
    public override void _Input(InputEvent @event)
    {
        if (Input.IsActionJustPressed(GameConstants.INPUT_LMB))
		{
			playerEntity.stateMachine.SwitchState<AttackState>();
		}
    }


    protected override void EnterState()
    {
        if (animationPlayer.HasAnimation(GameConstants.ANIM_IDLE))
		{
			animationPlayer.Play(GameConstants.ANIM_IDLE);
		}
		else {GD.Print(Name + " has no animation: Idling");}
    }

    protected override void ExitState()
    {
        if (animationPlayer.CurrentAnimation == GameConstants.ANIM_IDLE)
		{
			animationPlayer.Stop();
		}
    }

}
// extends State
// class_name IdleState

// func Enter():
// 	if Character:
// 		Character.gravity = 9.8 # make sure gravity is on
// 	if anim.has_animation("Idling"):
// 		anim.queue("Idling")
// 	else:
// 		print(self.name + " has no animation: Idling")
	
// func Exit():
// 	if anim.current_animation == "Idling":
// 		anim.stop()
// 		#anim.play("Idling")

// func Update(_delta: float):
// 	pass
