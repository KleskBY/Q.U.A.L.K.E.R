/*
	==============================================================================
	
	PLAYER
	
	==============================================================================
*/

void() player_run;
void() player_stand =
{
	self.weaponframe = 0;
	if (vlen(self.velocity) >= 20)
	{
		player_run();
		return;
	}
	
	self.think = player_stand;
	self.nextthink = time + 0.1;
}

void() player_run =
{
	self.weaponframe = 0;
	self.reload = 0;
	if (vlen(self.velocity) < 20)
	{
		player_stand();
		return;
	}

	self.think = player_run;
	self.nextthink = time + 0.1;
}
		
void() PainSound =
{
	if (self.health < 0) return;
	if (self.pain_finished > time)
	{
		self.axhitme = 0;
		return;
	}
	self.pain_finished = time + 0.1; // don't make multiple pain sounds right after each other
	
	local float rsnd = random_int(1, 23);
	if (rsnd == 1) sound (self, CHAN_VOICE, "player/pain01.wav", 1, SoundRadius(800)); 
	else if (rsnd == 2) sound (self, CHAN_VOICE, "player/pain02.wav", 1, SoundRadius(800)); 
	else if (rsnd == 3) sound (self, CHAN_VOICE, "player/pain03.wav", 1, SoundRadius(800)); 
	else if (rsnd == 4) sound (self, CHAN_VOICE, "player/pain04.wav", 1, SoundRadius(800));
	else if (rsnd == 5) sound (self, CHAN_VOICE, "player/pain05.wav", 1, SoundRadius(800)); 
	else if (rsnd == 6) sound (self, CHAN_VOICE, "player/pain06.wav", 1, SoundRadius(800)); 
	else if (rsnd == 7) sound (self, CHAN_VOICE, "player/pain07.wav", 1, SoundRadius(800)); 
	else if (rsnd == 8) sound (self, CHAN_VOICE, "player/pain08.wav", 1, SoundRadius(800)); 
	else if (rsnd == 9) sound (self, CHAN_VOICE, "player/pain09.wav", 1, SoundRadius(800)); 
	else if (rsnd == 10) sound (self, CHAN_VOICE, "player/pain10.wav", 1, SoundRadius(800)); 
	else if (rsnd == 11) sound (self, CHAN_VOICE, "player/pain11.wav", 1, SoundRadius(800)); 
	else if (rsnd == 12) sound (self, CHAN_VOICE, "player/pain12.wav", 1, SoundRadius(800)); 
	else if (rsnd == 13) sound (self, CHAN_VOICE, "player/pain13.wav", 1, SoundRadius(800)); 
	else if (rsnd == 14) sound (self, CHAN_VOICE, "player/pain14.wav", 1, SoundRadius(800)); 
	else if (rsnd == 15) sound (self, CHAN_VOICE, "player/pain15.wav", 1, SoundRadius(800)); 
	else if (rsnd == 16) sound (self, CHAN_VOICE, "player/pain16.wav", 1, SoundRadius(800)); 
	else if (rsnd == 17) sound (self, CHAN_VOICE, "player/pain17.wav", 1, SoundRadius(800)); 
	else if (rsnd == 18) sound (self, CHAN_VOICE, "player/pain18.wav", 1, SoundRadius(800)); 
	else if (rsnd == 19) sound (self, CHAN_VOICE, "player/pain19.wav", 1, SoundRadius(800)); 
	else if (rsnd == 20) sound (self, CHAN_VOICE, "player/pain20.wav", 1, SoundRadius(800)); 
	else if (rsnd == 21) sound (self, CHAN_VOICE, "player/pain21.wav", 1, SoundRadius(800)); 
	else if (rsnd == 22) sound (self, CHAN_VOICE, "player/pain22.wav", 1, SoundRadius(800)); 
	else if (rsnd == 23) sound (self, CHAN_VOICE, "player/pain23.wav", 1, SoundRadius(800)); 
};


void(entity attacker, float damage) player_pain =
{
	PainSound();
};
	
void() PlayerDead =
{
	self.nextthink = -1;
	self.deadflag = DEAD_DEAD; // allow respawn after a certain time
};
	
void() player_die1 =
{
	if(self.frame < 66) self.frame = 66;
	else 
	{
		self.frame = self.frame + 1;
		if(self.frame >= 77)
		{
			PlayerDead();
			return;
		}
	}
	self.think = player_die1;
	self.nextthink = time + 0.05;
};

void() player_die2 =
{
	if(self.frame < 78) self.frame = 78;
	else 
	{
		self.frame = self.frame + 1;
		if(self.frame >= 126)
		{
			PlayerDead();
			return;
		}
	}
	self.think = player_die2;
	self.nextthink = time + 0.025;
};

void() DeathSound =
{
	local float rs = rint ((random() * 5) + 1);
	if (rs == 1) sound(self, CHAN_VOICE, "player/death01.wav", 1, ATTN_NORM);
	else if (rs == 2) sound(self, CHAN_VOICE, "player/death02.wav", 1, ATTN_NORM);
	else if (rs == 3) sound(self, CHAN_VOICE, "player/death03.wav", 1, ATTN_NORM);
	else if (rs == 4) sound(self, CHAN_VOICE, "player/death04.wav", 1, ATTN_NORM);
	else sound(self, CHAN_VOICE, "player/death05.wav", 1, ATTN_NORM);
};

void() PlayerDie =
{
	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
		
	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	setsize(self, '-12 -12 -24', '12 12 -20');
	self.solid = SOLID_CORPSE;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < 10) self.velocity_z = self.velocity_z + random() * 300;
	
	if (self.health < -40)
	{
		Gib();
		return;
	}
	
	DeathSound();
	
	self.angles_x = 0;
	self.angles_z = 0;
	
	if (random() <= 0.5) player_die1();
	else player_die2();
};
	
void() set_suicide_frame =
{	
	player_die1(); // self.frame = $deatha11;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
};
