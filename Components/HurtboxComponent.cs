using Godot;

public partial class HurtboxComponent : Area3D
{
	[Signal]
	public delegate void TriggerHitEventHandler(HitboxComponent otherComponent);

	//public bool canTakeDamage = false;
	//public bool isInArea = false;

    public override void _Ready()
    {
        AreaEntered += enteredHurtbox;
		//AreaExited += exitedHurtbox;
    }

	public void enteredHurtbox(Node3D otherArea)
	{
		if (otherArea is HitboxComponent) 
		{
			if (otherArea.GetOwner<CharacterEntity>() != this.GetOwner<CharacterEntity>())
			{
				//isInArea = true;
				EmitSignal(SignalName.TriggerHit, otherArea);
			}
		}
			
	}

	public void exitedHurtbox(Node3D otherArea)
	{
		// Empty?
	}
}

