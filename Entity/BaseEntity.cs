using Godot;

public partial class BaseEntity : CharacterBody3D
{
	[Export] string entityName;

	Vector3 spawnPosition;

    public override void _Ready()
    {
        spawnPosition = GlobalPosition;
    }
}
