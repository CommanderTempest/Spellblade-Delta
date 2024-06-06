using Godot;
using System;

[GlobalClass] // allows selection of this class in Godot when creating objects
public partial class StatResource : Resource
{
    public event Action OnZero; // signal
    public event Action OnUpdate;

    [Export] public Stat StatType {get; private set;}

    private float _statValue; // this is the variable the property below accesses
    [Export] public float StatValue 
    {
        get => _statValue;
        set 
        {
            _statValue = Mathf.Clamp(value, 0, Mathf.Inf);

            OnUpdate.Invoke();
            
            if (_statValue == 0)
            {
                OnZero?.Invoke();
            }
        }
    }

}