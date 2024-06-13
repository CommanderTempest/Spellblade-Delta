using Godot;
using System;

public partial class SWeapon : Node3D
{
    [Export] public float Range {get; private set;} = 5.0f;  // from how far you can hit a target
    [Export] public float Speed {get; private set;} = 2.0f;   // how quickly you can swing the weapon
    [Export] public float Damage {get; private set;} = 5.0f;  // how much damage a single swing does

    /*
        May need separate inherited classes for wands/swords/ other types?
    */
}