using System;
using Godot;

public partial class HitboxComponent : Area3D
{
	[Export] private const int MIN_DAMAGE_TO_DEAL = 12;
	[Export] private const int MAX_DAMAGE_TO_DEAL = 20;

	private HurtboxComponent myHurtbox;
	private HurtboxComponent contactTarget;
	private static RandomNumberGenerator rng = new RandomNumberGenerator();

    public override void _Ready()
    {
      AreaEntered += areaEntered;
			AreaExited += areaExited;
			myHurtbox = GetOwner<CharacterEntity>().characterHurtbox;
    }

	private void areaEntered(Node3D otherArea)
	{
		if (otherArea is HurtboxComponent)
		{
			if (otherArea != myHurtbox)
			{
				contactTarget = (HurtboxComponent) otherArea;
			}
		}
	}

	private void areaExited(Node3D otherArea)
	{
		if (otherArea == contactTarget) {contactTarget = null;}
	}

	public int getRandomDamageToDeal()
	{
		int randomDamage = (int) Math.Round(rng.RandfRange(MIN_DAMAGE_TO_DEAL, MAX_DAMAGE_TO_DEAL));
		return randomDamage;
	}
}


