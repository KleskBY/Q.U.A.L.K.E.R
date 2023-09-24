//External trigger
//Used for editing .ent file
void() trigger_external_touch
{
	if (other.classname != "player") return;
	if (self.waitmin > time) return;
	
	self.waitmin = time + self.wait;
	if (self.message != "")
	{
		centerprint (other, self.message);
	}
	if (self.noise)
	{
		sound (other, CHAN_AUTO, self.noise, 1, SoundRadius(300)); 
	}
	if (self.task)
	{
		other.task = self.task;
		cvar_set("scratch3", self.task);
	}
	if (self.task_pos)
	{
		other.task_pos = self.task_pos;
		cvar_set("scratch4", vtos(self.task_pos));
	}
	
	if (self.map != "")
	{
		if(self.spawnflags & DOOR_SILVER_KEY && !(other.items & IT_KEY1))
		{
			return;
		}
		if(self.spawnflags & DOOR_GOLD_KEY && !(other.items & IT_KEY2))
		{
			return;
		}

		other.weaponmodel = "";
		setmodel(other.viewmodel, "");

		nextmap = self.map;
		SUB_UseTargets ();
		if (self.spawnflags & 1 && deathmatch == 0) // NO_INTERMISSION
		{	
			GotoNextMap();
			return;
		}
		self.touch = SUB_Null;
		self.think = execute_changelevel;
		self.nextthink = time + 0.1;
	}
	if(self.count) remove(self);
}

void() trigger_external
{
	InitTrigger ();
	setsize (self, self.pos1, self.pos2);
	if(!self.wait) self.wait = 1;
	self.touch = trigger_external_touch;
}


void() radio_off_think =
{
	if(self.weaponframe > 0) self.weaponframe = self.weaponframe - 1;
	self.nextthink = time + 0.03;
	self.think = radio_off_think;
	
	self.velocity_x = 0;
	self.velocity_y = 0;
	if(self.weaponframe <= 0) 
	{
		self.think = player_run;
		self.movetype = MOVETYPE_WALK;
		self.reload = 0;
		self.blockSwitch = 0;
		self.weaponSelect();
		self.weaponSwitch();
	}
};


void() radio_on_think =
{
	if(self.weaponframe < 40) self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + 0.03;
	self.think = radio_on_think;
	
	self.velocity_x = 0;
	self.velocity_y = 0;
	self.movetype = MOVETYPE_NONE;
	self.reload = 1;
	self.blockSwitch = 1;
	self.punchangle = '0 0 0';
};

void() RemoveAllMonsters =
{
	local entity e;
	for ( entity b = world; ( b = find( b, classname, "monster_dog" ) ); ) 
	{
		print(b.classname);
		print("\n");
		T_Damage(b, b, b, b.health  + 1);
	}
};


entity(void() func, vector pos, vector ang) SpawnMonster;



