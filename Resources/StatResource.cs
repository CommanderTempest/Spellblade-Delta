using Godot;

[GlobalClass] // allows selection of this class in Godot when creating objects
public partial class StatResource : Resource
{
    [Export] public Stat StatType {get; private set;}
    [Export] public float StatValue {get; private set;}

}