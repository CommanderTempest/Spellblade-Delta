using System.Dynamic;
using System.Threading.Tasks;
using Godot;

public partial class PostureComponent : Node3D
{
	[Signal]
	public delegate void PostureChangedEventHandler(int posture);
	[Signal]
	public delegate void StunnedEventHandler();

	const int POSTURE_REGEN_RATE = 2;     // Posture to regen per tick
	const int POSTURE_REGEN_TIMER = 1000; // amount of time to regen once (in ms)

	[Export] public int MaxPosture {get; private set;} = 100;

	public int CurrentPosture 
	{
		get {return CurrentPosture;}
		set
		{
			if (value + CurrentPosture > MaxPosture) {CurrentPosture = MaxPosture;}
			else {CurrentPosture = value;}
			EmitSignal(SignalName.PostureChanged, CurrentPosture);
			if (CurrentPosture <= 0)
			{
				CurrentPosture = MaxPosture;
				EmitSignal(SignalName.Stunned);
			}
		}
	}

	bool regenerating = false;

    public override void _Ready() {initializePosture();}
    public void initializePosture() {CurrentPosture = MaxPosture;}

	public bool hasPostureRemaining()
	{
		if (CurrentPosture > 0) {return true;}
		else {return false;}
	}

	public void takePostureDamage(int damage){CurrentPosture -= damage;}
	public void healPosture(int amount) {CurrentPosture += amount;}

	public async void beginRegen()
	{
		regenerating = true;
		while (regenerating)
		{
			await Task.Delay(POSTURE_REGEN_TIMER);
			healPosture(POSTURE_REGEN_RATE);

			if (CurrentPosture >= MaxPosture) {stopRegen();}
		}
	}

	public void stopRegen(){regenerating = false;}
}
