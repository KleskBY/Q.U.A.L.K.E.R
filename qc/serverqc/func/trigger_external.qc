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
	InitTrigger();
	setsize (self, self.pos1, self.pos2);
	if(!self.wait) self.wait = 1;
	self.touch = trigger_external_touch;
}



void() trigger_external_monsterjump =
{
	if (!self.speed) self.speed = 200;
	if (!self.height) self.height = 200;
	if (self.angles == '0 0 0') self.angles = '0 360 0';
	InitTrigger();
	setsize (self, self.pos1, self.pos2);
	self.touch = trigger_monsterjump_touch;
};


void() trigger_external_push_touch
{
	if (other.classname != "player") return;
	if (self.waitmin > time) return;
	
	self.waitmin = time + self.wait;
	if (self.message != "")
	{
		centerprint (other, self.message);
	}
	
	
	vector center = (self.pos1 + self.pos2) * 0.5;
	other.velocity = normalize(other.origin - center) * (vlen(other.velocity) + 100);
	
}

void() trigger_external_push
{
	InitTrigger();
	setsize (self, self.pos1, self.pos2);
	if(!self.wait) self.wait = 0.1;
	self.touch = trigger_external_push_touch;
}


