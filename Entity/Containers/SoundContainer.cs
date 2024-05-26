using System;
using Godot;
using Godot.Collections;

public partial class SoundContainer : Node3D 
{
	[Export] Array<AudioStreamPlayer3D> sounds = new Array<AudioStreamPlayer3D>();

	public void playSound(string soundToPlay)
	{
		foreach (AudioStreamPlayer3D sound in sounds)
		{
			if (soundToPlay.ToLower() == sound.Name.ToString().ToLower()) {sound.Play();}
		}
	}
}
