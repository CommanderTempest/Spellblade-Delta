using System;
using Godot;
using Godot.Collections;

// For audio playing 1 at a time like Charater Creators/Selectors see this video: https://www.youtube.com/watch?v=_m4L36SfijA&t=458s

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
