using System.Collections.Generic;
using Godot;
using Godot.Collections;

public partial class HitboxContainer : Node3D
{
	[Export] Array<HitboxComponent> hitboxes = new Array<HitboxComponent>();
	public bool isEmpty = false;

    public override void _Ready()
    {
        isEmpty = hitboxes.Count == 0;
    }

	public bool isInContainer(HitboxComponent hitbox)
	{
		if (hitboxes.Contains(hitbox)) {return true;}
		return false;
	}
}


