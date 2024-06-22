using System;
using Godot;

[GlobalClass]
public partial class PlayerAttackState : PlayerState
{
  [Export] private Timer comboTimerNode;

  private int combo = 1;
  private int maxCombo = 3;

  public override void _Ready() 
  {
    base._Ready();
    comboTimerNode.Timeout += () => {combo = 1;};
  }

  protected override void EnterState()
  {
    characterNode.AnimPlayerNode.Play(GameConstants.ANIM_ATTACK + combo.ToString());

    characterNode.AnimPlayerNode.AnimationFinished += HandleAnimationFinished;
  }

  protected override void ExitState()
  {
    characterNode.AnimPlayerNode.AnimationFinished -= HandleAnimationFinished;
    comboTimerNode.Start();
  }

  private void HandleAnimationFinished(StringName anim)
  {
    combo++;
    combo = Mathf.Wrap(combo, 1, maxCombo + 1);
    characterNode.StateMachineNode.SwitchState<PlayerIdleState>();
  }

}