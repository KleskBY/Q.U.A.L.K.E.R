
// called by ClientKill and DeadThink
void PlayerRespawn() 
{
	float players;
	if(cvar("gamemode") == MODE_COOP)
	{
		for (entity e = findchain(classname, "player"); e; e = e.chain) if(IsAllive(e)) players = players + 1;
		if(!players) localcmd("restart\n");

		PutObserverInServer();
	}
	else if(cvar("gamemode") == MODE_DM)
	{
		SetNewParms();
		PutClientInServer();
	}
	else if(cvar("gamemode") == MODE_SURV)
	{
		for (entity e = findchain(classname, "player"); e; e = e.chain) if(IsAllive(e)) players = players + 1;
		
		float alliveMonsters;
		for (entity e = findchainflags(flags, FL_MONSTER); e; e = e.chain) 
		{
			if(IsAllive(e)) alliveMonsters += 1;
		}
		
		if(players) 
		{
			if(find(world, classname, "survival"))
			{
				if(alliveMonsters <= 0)
				{
					SetNewParms();
					PutClientInServer();
				}
				else PutObserverInServer();
			}
			else PutObserverInServer();
		}
		else localcmd ("restart\n");
	}
	else localcmd("restart\n"); // restart the entire server
};

void() DeathSound =
{
	local float rs = RandomInt(1, 5);
	if (rs == 1) sound(self, CHAN_VOICE, "player/death01.wav", 1, ATTN_NORM);
	else if (rs == 2) sound(self, CHAN_VOICE, "player/death02.wav", 1, ATTN_NORM);
	else if (rs == 3) sound(self, CHAN_VOICE, "player/death03.wav", 1, ATTN_NORM);
	else if (rs == 4) sound(self, CHAN_VOICE, "player/death04.wav", 1, ATTN_NORM);
	else sound(self, CHAN_VOICE, "player/death05.wav", 1, ATTN_NORM);
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
	
	if (self.health < -0)
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


void() PlayerDeathThink =
{
	self.viewzoom = Lerp(self.viewzoom, 1, 0.05);
	if(self.frame < 199) self.frame = self.frame + 1;
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0) return; // wait for all buttons released
		self.deadflag = DEAD_RESPAWNABLE; // allow respawn after buttons released
		return;
	}
	
	if (!self.button2 && !self.button1 && !self.button0) return; // wait for any button down

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	PlayerRespawn();
};


void(entity targ, entity attacker) ClientObituary =
{
	local	float rnum;
	local	string deathstring;
	rnum = random();

	if (targ.classname == "player")
	{
		if (attacker.classname == "teledeath")
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");

			attacker.owner.frags = attacker.owner.frags + 1;
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");

			targ.frags = targ.frags - 1;
			return;
		}

		if (attacker.classname == "player")
		{
			if (targ == attacker) // killed self
			{
				attacker.frags = attacker.frags - 1;
				bprint (targ.netname);
				bprint (" becomes bored with life\n");
				return;
			}
			else if (teamplay == 2 && targ.team == attacker.team)
			{
				if (rnum < 0.25) deathstring = " mows down a teammate\n";
				else if (rnum < 0.50) deathstring = " checks his glasses\n";
				else if (rnum < 0.75) deathstring = " gets a frag for the other team\n";
				else deathstring = " loses another friend\n";
				
				bprint (attacker.netname);
				bprint (deathstring);
				attacker.frags = attacker.frags - 1;
				return;
			}
			else
			{
				attacker.frags = attacker.frags + 1;
				bprint(attacker.netname);
				bprint(" ");
				bprint(chr2str(3));
				if(targ.hitbox == 1) bprint(chr2str(2));//bprint("");
				bprint(" ");
				bprint(targ.netname);
				bprint("\n");
			}
			return;
		}
		else
		{
			targ.frags = targ.frags - 1;
			bprint (targ.netname);

			if (attacker.flags & FL_MONSTER) // killed by a montser?
			{
				bprint (" was killed\n");
				return;
			}

			if (attacker.solid == SOLID_BSP && attacker != world)
			{	
				bprint (" was squished\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (" tried to leave\n");
				return;
			}

			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				bprint (" drowned\n");
				return;
			}
			else if (rnum == -4)
			{
				bprint (" dissolved in acid\n");
				return;
			}
			else if (rnum == -5)
			{
				bprint (" burned down\n");
				return;
			}
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint (" fell to his death\n");
				return;
			}
			bprint (" died\n");
		}
	}
};
