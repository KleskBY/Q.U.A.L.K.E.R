



void PlayerLanding()
{
	if(self.jump_flag < -300 && self.flags & FL_ONGROUND && self.health > 0)
	{
		if(self.jump_flag < -500)
		{
			T_Damage(self, world, world, -self.jump_flag * 0.05); 
			sound(self, CHAN_VOICE, "player/land2.wav", 0.6, SoundRadius(750));
			self.deathtype = "falling";
		}
		else sound (self, CHAN_VOICE, "player/land1.wav", 0.6, SoundRadius(650));

		self.jump_flag = 0;
		self.punchangle_x = 3;
	}
};





// Called every frame for each player, before physics
void() PlayerPreThink =
{
	//Intermission (map end)
	if (intermission_running)
	{
		IntermissionThink();	// otherwise a button could be missed between
		return;					// the think tics
	}
	
	//player is dead
	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink();
		return;
	}
	
	if (self.deadflag == DEAD_DYING) return; // dying, so do nothing
	if (self.flags & FL_ONGROUND) self.flags = self.flags - (self.flags & FL_LADDERJUMP); //Release ladder flag

	PlayerSwim();
	PlayerJump();
	PlayerUse();
	PlayerStance();
	PlayerFootsteps();
	PlayerZoom();
	PlayerAmbient();
	Viewmodel();
	
	
	//noclip and ladder move
	if(self.movetype == MOVETYPE_NOCLIP && !self.button2 && !self.button3)
	{
		if(self.button4) self.velocity = self.velocity * 5;
	}
	
	//reset movetype after lader
	if(self.movetype == MOVETYPE_FLY && other.lastTouch < time) 
	{
		self.movetype = MOVETYPE_WALK;
	}
	
	// Fix ugly vertical model lean
	self.angles_x = 0; 
};

void() PlayerThink =
{
	self.weaponframe = 0;
	self.reload = 0;

	self.think = PlayerThink;
	self.nextthink = time + 0.1;
}

void() W_WeaponFrame;
//Called every frame for each player, after physics
void() PlayerPostThink =
{
	if (self.view_ofs == '0 0 0') return; // Intermission or cinematic
	if (!IsAllive(self)) return;
	W_WeaponFrame();
	
	PlayerLanding();
	if(!(self.flags & FL_ONGROUND)) self.jump_flag = self.velocity_z;
	if(self.origin_z < -3000) ClientKill(); //fucker is trying to escape
	
	ImpulseCommands();
	PlayerAnimation();
};