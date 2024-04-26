using Godot;
using System;

public partial class knight : CharacterBody2D
{
	[Export] 
	private int speed = 250; 
	private Vector2 currentVelocity;
	private AnimatedSprite2D knightanim;
	public override void _PhysicsProcess (double delta) 
	{
		LookAt(GetGlobalMousePosition());
		base._PhysicsProcess (delta); 
		handleInput(); 
		Velocity = currentVelocity; 
		MoveAndSlide(); 
	} 
	private void handleInput() 
	{ 
			currentVelocity = Input.GetVector("left", "right", "up", "down"); 
			currentVelocity *= speed; 
	}


}
