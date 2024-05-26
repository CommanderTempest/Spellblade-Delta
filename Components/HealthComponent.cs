using System.Threading.Tasks;
using Godot;

public partial class HealthComponent : Node3D
{
	[Signal]
	public delegate void HealthChangedEventHandler();
	[Signal]
	public delegate void DefeatedEventHandler();

	const int HP_REGEN_RATE = 2;      // HP to regen per tick
	const int HP_REGEN_TIMER = 1000;  // amount of time per tick (in milliseconds)

	[Export] public int MaxHealth {get; private set;} = 100;

	public int CurrentHealth 
	{
		get {return CurrentHealth;} 
		set 
		{
			if (value + CurrentHealth > MaxHealth) {CurrentHealth = MaxHealth;}
			else {CurrentHealth = value;}
			EmitSignal(SignalName.HealthChanged);
			if (CurrentHealth <= 0){EmitSignal(SignalName.Defeated);}
		}
	}

	bool regenerating = false;

    public override void _Ready()
    {
        initializeHealth();
    }

    public void initializeHealth()
	{
		CurrentHealth = MaxHealth;
	}

	public bool hasHealthRemaining()
	{
		if (CurrentHealth > 0) {return true;}
		else {return false;}
	}

	public void takeDamage(int damage) {CurrentHealth -= damage;}
	public void heal(int amount){CurrentHealth += amount;}

	public async void beginRegen()
	{
		regenerating = true;
		while (regenerating)
		{
			await Task.Delay(HP_REGEN_TIMER);
			heal(HP_REGEN_RATE);
		}
	}

	public void stopRegen() {regenerating = false;}
}


