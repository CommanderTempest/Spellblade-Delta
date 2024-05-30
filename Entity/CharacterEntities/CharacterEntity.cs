using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Security.Cryptography.X509Certificates;
using Godot;
using System.Linq;

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

	[Export] private StatResource[] stats;

	[ExportGroup("Required Nodes")]
	[Export] public StateMachine StateMachineNode {get; private set;}
	[Export] public AnimationPlayer AnimPlayerNode {get; private set;}

	[ExportGroup("Components")]
	[Export] public HurtboxComponent characterHurtbox;
	[Export] protected HealthComponent healthComponent = new HealthComponent();
	[Export] protected PostureComponent postureComponent = new PostureComponent();
	
	[ExportGroup("Containers")]
	[Export] protected EquipContainer equipContainer = new EquipContainer();
	[Export] protected HitboxContainer hitboxContainer = new HitboxContainer();
	[Export] protected SoundContainer soundContainer = new SoundContainer();

	

	[ExportGroup("Character Variables")]
	[Export(PropertyHint.Range, "0,20,0.1")] private float speed = 2.0f;
	//[Export] bool canAttack = false; // Whether this entity is able to attack

	[ExportGroup("Detectors")]
	[Export] public RayCast3D climbDetector;

	public Vector3 direction = new();
	private float gravity = 9.8f;

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
		//stateMachine.StateTransition += onStateTransition;
    }

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

    public override void _PhysicsProcess(double delta)
    {
			if (!IsOnFloor())
			{
				if (Velocity.Y >= 0) 
				{
					Velocity = new Vector3(direction.X, 0, direction.Z);
					Velocity = new Vector3(Velocity.X, (float)(Velocity.Y - this.gravity * delta), Velocity.Z);
				}
			}
			else {Velocity = new Vector3(Velocity.X, (float) (Velocity.Y - gravity * delta * fallMultiplier), Velocity.Z);}
		
			MoveAndSlide();
    }

	public StatResource GetStatResource(Stat stat)
	{
		return stats.Where((element) => element.StatType == stat).FirstOrDefault();
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
		if (AnimPlayerNode.HasAnimation("Defeat")) {AnimPlayerNode.Play(GameConstants.ANIM_DEFEAT);}
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