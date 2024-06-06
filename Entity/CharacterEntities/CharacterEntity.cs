using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Security.Cryptography.X509Certificates;
using Godot;
using System.Linq;

public partial class CharacterEntity : BaseEntity
{
	[Export] private StatResource[] stats;

	[ExportGroup("Required Nodes")]
	[Export] public StateMachine StateMachineNode {get; private set;}
	[Export] public AnimationPlayer AnimPlayerNode {get; private set;}
	[Export] public Area3D HitboxNode {get; private set;} // the part that deals damage to another entity
	[Export] public Area3D HurtboxNode {get; private set;} // the part that receives damage from another entity
	// the collision shape, that upon being hit, triggers damage
	[Export] public CollisionShape3D HitboxShapeNode {get; private set;}

	[ExportGroup("Components")]
	[Export] public HurtboxComponent characterHurtbox;
	
	// [ExportGroup("Containers")]
	// [Export] protected EquipContainer equipContainer = new EquipContainer();
	// [Export] protected HitboxContainer hitboxContainer = new HitboxContainer();
	// [Export] protected SoundContainer soundContainer = new SoundContainer();

	[ExportGroup("Character Variables")]
	[Export(PropertyHint.Range, "0,20,0.1")] public float speed = 2.0f;
	

	[ExportGroup("Detectors")]
	[Export] public RayCast3D climbDetector;

	public Vector3 direction = new();
	protected float fallMultiplier = 2f;
	private float gravity = 9.8f;
	

    public override void _Ready()
    {
			HurtboxNode.AreaEntered += HandleHurtboxEntered;
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

	// **** EVENTS ****
	private void HandleHurtboxEntered(Area3D area)
	{
		if (area is not IHitbox hitbox){return;}

		// process if blocking/parrying/dodging here

		StatResource health = GetStatResource(Stat.Health);

		float damage = hitbox.GetDamage();

		health.StatValue -= damage;
	}

}