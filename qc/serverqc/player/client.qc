void SelectNone();


//Call after player connects to the server
void() ClientConnect =
{
};

//Call after player disconeects from the server
void() ClientDisconnect =
{
	SelectNone();
	if (self.gun) remove(self.gun);
	if (self.viewmodel) remove(self.viewmodel);
	
	if (gameover) return;
	bprint(self.netname);
	bprint(" left the game.\n");
	// T_Damage(self, world, world, self.health);
};

//Client execute kill command
void() ClientKill =
{
	T_Damage(self, world, world, self.health);
};

//Looking for spawn point (entity info_player_start), spawn in 0, 0, 64 if no spawnpoint found
entity lastspawn;
entity() SelectSpawnPoint =
{
	local entity spot;
	local entity thing;
	local float  pcount;
	
	if(cvar("gamemode") == MODE_COOP || cvar("gamemode") == MODE_SURV)
	{
		spot = find(world, classname, "info_player_start");
		if(spot == lastspawn)
		{
			spot = find(lastspawn, classname, "info_player_coop");
			if (!spot) spot = lastspawn;
		}
	}
	else if(cvar("gamemode") == MODE_DM)
	{
		// spot = find(spot, classname, "info_player_deathmatch");
		spot = lastspawn;	
		while (1)
		{
			spot = find(spot, classname, "info_player_deathmatch");
			if (spot != world)
			{
				if (spot == lastspawn) return lastspawn;
				pcount = 0;
				thing = findradius(spot.origin, 32);
				while(thing)
				{
					if (thing.classname == "player") pcount = pcount + 1;
					thing = thing.chain;
				}
				if (pcount == 0)
				{
					lastspawn = spot;
					return spot;
				}
			}
		}
	}
	
	if(!spot)
	{
		bprint("No info_player_start on level\n");
		entity newspawn = spawn();
		newspawn.classname = "info_player_start";
		setorigin(newspawn, '0 0 64');
		return newspawn;
	}

	lastspawn = spot;
	return spot;
};


void PlayerPain(entity attacker, float damage);
void PlayerDie();
void PlayerThink();
void W_SetCurrentAmmo();
void PlayerStanceWalk();


//Call after setting the parm1... parms
void() PutClientInServer =
{
	float ambient_light = world.light_lev;
	if(ambient_light < 4) ambient_light = 4;
	string cmd = strcat("r_ambient ", ftos(ambient_light));
	cmd = strcat(cmd, ";teamplay ", ftos(cvar("teamplay")));
	cmd = strcat(cmd, ";deathmatch ", ftos(cvar("deathmatch")));
	cmd = strcat(cmd, ";coop ", ftos(cvar("coop")));
	cmd = strcat(cmd, ";r_trippy 0; cl_hud 1;");
	cmd = strcat(cmd, "\n");
	stuffcmd(self, cmd);
	
	PlayerStanceWalk();
	self.stamina = 100;
	
	//Stats
	local entity e;
	self.total_items = 0;
	self.picked_items = 0;
	self.total_hits = 0;
	self.total_shots = 0;
	for (e = findchainfloat(item, TRUE); e; e = e.chain)
	{
		self.total_items = self.total_items + 1;
	}


	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.items = 0;
	self.invincible_time = 0;
	if(coop) self.team = 0;

	if(coop && parm2 == 0) SetNewParms();
	DecodeLevelParms();
	W_SetCurrentAmmo();

	self.attack_finished = time;
	self.th_pain = PlayerPain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	self.pausetime = 0; // paustime is set by teleporters to keep the player from moving a while
	
	entity spot = SelectSpawnPoint();
	self.origin = self.oldorigin = spot.origin + '0 0 1';	// 1998-07-21 Respawning where player died fix by Robert Field
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately

	W_SetCurrentAmmo();
	if(self.weaponSwitch) self.weaponSwitch();
	
	setsize(self, STAND_SIZE_MIN, STAND_SIZE_MAX);
	self.view_ofs = '0 0 24';
	self.velocity = '0 0 0';
	self.crouching = 0;
	
	PlayerThink();
};










void() PutObserverInServer;
//void() set_suicide_frame;
void() respawn = // called by ClientKill and DeadThink
{
	CopyToBodyQue(self);	// make a copy of the dead body for appearances sake
	if (coop)
	{
		local float players;
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
	else if(deathmatch)
	{
		SetNewParms();
		PutClientInServer();
	}
	else localcmd ("restart\n"); // restart the entire server
};

void(entity e) respawnPlayer = 
{
	entity oldself = self;
	self = e;
	setmodel(e, "");
	respawn();
	self = oldself;
}