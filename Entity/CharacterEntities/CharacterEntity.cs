using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Security.Cryptography.X509Certificates;
using Godot;

public partial class CharacterEntity : BaseEntity
{
	[Signal]
	public delegate void entityPostureChangedEventHandler(int currentPosture);

	protected enum CharacterFlag {
		InCombat,
		Interacting,
		Defeated,
		Resting,
		Stealthed,
		Stunned,
		Blocking,
		Attacking,
		Parrying,
		Dodging
	}

	const float COMBAT_TIMER_DURATION = 10f;

	[ExportGroup("Components")]
	[Export] public HurtboxComponent characterHurtbox;
	[Export] protected HealthComponent healthComponent = new HealthComponent();
	[Export] protected PostureComponent postureComponent = new PostureComponent();
	
	[ExportGroup("Containers")]
	[Export] protected EquipContainer equipContainer = new EquipContainer();
	[Export] protected HitboxContainer hitboxContainer = new HitboxContainer();
	[Export] protected SoundContainer soundContainer = new SoundContainer();

	[Export] protected AnimationPlayer animationPlayer;

	[ExportGroup("Character Variables")]
	[Export] float speed = 2.0f;
	//[Export] bool canAttack = false; // Whether this entity is able to attack

	[ExportGroup("Detectors")]
	[Export] RayCast3D climbDetector;

	[Export] StateMachine stateMachine;

	protected bool canTickDamage = true;
	protected float fallMultiplier = 2f;
	protected List<CharacterFlag> flags = new List<CharacterFlag>();
	protected Timer inCombatTimer = new Timer();

	// var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

    public override void _Ready()
    {
        inCombatTimer.WaitTime = COMBAT_TIMER_DURATION;
		inCombatTimer.OneShot = true;
		inCombatTimer.Timeout += onCombatTimerTimeOut;
		AddChild(inCombatTimer);

		postureComponent.Stunned += () => {flags.Add(CharacterFlag.Stunned);};
		healthComponent.Defeated += onCharacterDefeat;
		characterHurtbox.TriggerHit += onHit;
		stateMachine.StateTransition += onStateTransition;
    }

    public override void _PhysicsProcess(double delta)
    {
        if (!IsOnFloor())
		{
			if (Velocity.Y >= 0) {Velocity.Y -= gravity * delta;}
		}
		else {Velocity.Y -= gravity * delta * fallMultiplier;}
    }

	public void damageEntityHealth(int damage)
	{
		enterCombat();
		healthComponent.takeDamage(damage);
	}

	public void damageEntityPosture(int damage)
	{
		enterCombat();
		postureComponent.takePostureDamage(damage);
	}

	public void enterCombat()
	{
		if (!flags.Contains(CharacterFlag.InCombat))
		{
			flags.Add(CharacterFlag.InCombat);
			healthComponent.stopRegen();
			postureComponent.stopRegen();
		}
		inCombatTimer.Start();
	}

	public void exitCombat()
	{
		if (flags.Contains(CharacterFlag.InCombat))
		{
			flags.Remove(CharacterFlag.InCombat);
			healthComponent.beginRegen();
			postureComponent.beginRegen();
		}
	}

	public void clearBattleFlags()
	{
		if (flags.Contains(CharacterFlag.Attacking)) {flags.Remove(CharacterFlag.Attacking);}
		if (flags.Contains(CharacterFlag.Blocking)) {flags.Remove(CharacterFlag.Blocking);}
		if (flags.Contains(CharacterFlag.Parrying)) {flags.Remove(CharacterFlag.Parrying);}
		if (flags.Contains(CharacterFlag.Dodging)) {flags.Remove(CharacterFlag.Dodging);}
		if (flags.Contains(CharacterFlag.Stunned)) {flags.Remove(CharacterFlag.Stunned);}
		// is this last one fine? ^
	}

	public bool canMakeAction()
	{
		if (flags.Contains(CharacterFlag.Stunned) || flags.Contains(CharacterFlag.Defeated))
		{
			return false;
		}
		return true;
	}

	private void addFlag(CharacterFlag flagToAdd)
	{
		if (!flags.Contains(flagToAdd)) {flags.Add(flagToAdd);}
	}

    // ****** EVENTS *******

    private void onCombatTimerTimeOut()
	{
		inCombatTimer.Stop();
		exitCombat();
	}

	private void onCharacterDefeat()
	{
		addFlag(CharacterFlag.Defeated);
		if (animationPlayer.HasAnimation("Defeat")) {animationPlayer.Play(GameConstants.ANIM_DEFEAT);}
	}

	private void onHit(HitboxComponent otherArea)
	{
		if (!hitboxContainer.isInContainer(otherArea))
		{
			if (flags.Contains(CharacterFlag.Dodging)) 
			{
				// Play Dodge Animation and/or particles
				GD.Print("Dodged!");
			}
			else if (flags.Contains(CharacterFlag.Parrying))
			{
				// Play Parry Particles
				GD.Print("Parried!");
			}
			else if (flags.Contains(CharacterFlag.Blocking))
			{
				soundContainer.playSound("Block");
				damageEntityPosture(otherArea.getRandomDamageToDeal());
			}
			else
			{
				damageEntityHealth(otherArea.getRandomDamageToDeal());
			}
		}
		else {GD.PrintErr(this.Name + " is hitting itself");}
	}

	[Obsolete("transition_state is deprecated, please transition from inside the state", true)]
	public void transition_state(string new_state)
	{
		// 	if state_machine.get_current_state_as_string() != new_state:
		// 		#if new_state == "IdleState":
		// 			#self.clear_battle_flags()
		// 		#elif new_state == "AttackState":
		// 			#self.add_flag(CharacterFlag.Attacking)
		// 		#elif new_state == "BlockState":
		// 			#self.add_flag(CharacterFlag.Blocking)
		// 		#elif new_state == "DodgeState":
		// 			#self.add_flag(CharacterFlag.Dodging)
		// 		state_machine.on_child_transition(state_machine.current_state, new_state)
	}

	public void onStateTransition()
	{
		// func on_state_transition(new_state: State) -> void:
		// 	if new_state is IdleState:
		// 		self.clear_battle_flags()
		// 	elif new_state is AttackState:
		// 		self.add_flag(CharacterFlag.Attacking)
		// 		# could play sound here instead of animation player?
		// 	elif new_state is StunState:
		// 		self.add_flag(CharacterFlag.Stunned)
		// 	elif new_state is BlockState:
		// 		self.add_flag(CharacterFlag.Blocking)
		// 	elif new_state is DodgeState:
		// 		self.add_flag(CharacterFlag.Dodging)
	}

}