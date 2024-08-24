
string walk_cmd = "cl_forwardspeed 100; cl_backspeed 80; cl_sidespeed 90;\n";
string crouch_cmd = "cl_forwardspeed 65; cl_backspeed 60; cl_sidespeed 60;\n";
string run_cmd = "cl_forwardspeed 220; cl_backspeed 90; cl_sidespeed 120;\n";

.float crouching;
.float running;
.float stamina;

void PlayerStanceCrouch()
{
	self.crouching = 1;
	self.running = 0;
	setsize(self, DUCK_SIZE_MIN, DUCK_SIZE_MAX);
	self.view_ofs = DUCK_VIEW_OFS;
	stuffcmd(self, crouch_cmd);
};

void PlayerStanceWalk()
{
	self.crouching = 0;
	setsize(self, STAND_SIZE_MIN, STAND_SIZE_MAX);
	self.view_ofs = STAND_VIEW_OFS;
	
	if(self.running) stuffcmd(self, run_cmd);
	else stuffcmd(self, walk_cmd);
};

void PlayerStance()
{
	//Crouch
	if(self.button3) // holding crouch button
	{
		if(!self.crouching)
		{
			PlayerStanceCrouch();
		}
	}
	else if(self.crouching)
	{
		vector tempvec = STAND_SIZE_MAX;
		tempvec_z = -tempvec_z;
		traceline(self.origin, self.origin - tempvec, FALSE, self);
		if(trace_fraction == 1)
		{
			traceline(self.origin, self.origin + STAND_SIZE_MAX, FALSE, self);
			if(trace_fraction == 1)
			{
				tracebox(self.origin, STAND_SIZE_MIN, STAND_SIZE_MAX, self.origin + '0 0 10', FALSE, self);
				if(trace_fraction == 1)
				{
					tracebox(self.origin, STAND_SIZE_MIN, STAND_SIZE_MAX, self.origin, FALSE, self);
					if(trace_fraction == 1)
					{
						PlayerStanceWalk();
					}
				}
			}
		}
	}
	
	//Sprint
	if(self.button4 && !self.button0)
	{
		if(!self.crouching && !self.running && self.stamina > 30)
		{
			self.running = TRUE;
			stuffcmd(self, run_cmd);
		}
	}
	else if(!self.crouching && self.running)
	{
		self.running = FALSE;
		stuffcmd(self, walk_cmd);
	}
	
	//Stamina
	if(time < 5) self.stamina = 100;
	if(self.running) 
	{
		self.stamina = self.stamina - frametime * 5;
		if(self.stamina <= 0) 
		{
			self.running = FALSE;
			stuffcmd(self, walk_cmd);
			sound (self, CHAN_AUTO, "player/breath.wav", 1, ATTN_NONE);
		}
	}
	else self.stamina = self.stamina + frametime * 6;
	if(self.stamina > 100) self.stamina = 100;
	if(self.stamina < 0) self.stamina = 0;

	// print(ftos(self.stamina), "\n");
}