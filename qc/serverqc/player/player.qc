



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




.float lastFixedUpdate;
// Called every frame for each player, before physics
void() PlayerPreThink =
{
	if (intermission_running) //Intermission (map end)
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
	
	if(self.lastFixedUpdate + 0.1 < time)
	{
		PlayerAmbient();
		PlayerTooltip();
		PlayerInCross();
		self.lastFixedUpdate = time;
	}
	PlayerViewmodel();
	
	local float oldSolid = self.solid; //Corpse hit fix
	self.solid = SOLID_BBOX;
	makevectors(self.v_angle + self.punchangle);	
	vector src = self.origin + v_forward * 10 + self.view_ofs;
	traceline(src, src + v_forward * 2048, MOVE_HITMODEL, self);
	self.solid = oldSolid;
	
	
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
	
	// traceline (self.origin + self.view_ofs, self.origin + self.view_ofs + v_forward * 1024, MOVE_HITMODEL, self);
	// if(!trace_ent) centerprint(self, "\n");
	// else centerprint(self, trace_ent.classname);
	
	PlayerLanding();
	if(!(self.flags & FL_ONGROUND)) self.jump_flag = self.velocity_z;
	if(self.origin_z < -3000) ClientKill(); //fucker is trying to escape
	
	ImpulseCommands();
	PlayerAnimation();
};