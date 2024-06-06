using Godot;
using System;

public partial class AttackHitbox : Area3D, IHitbox
{
  public float GetDamage()
  {
    return GetOwner<CharacterEntity>().GetStatResource(Stat.Strength).StatValue;
  }

  public bool CanStun()
  {
    return false;
  }
}
