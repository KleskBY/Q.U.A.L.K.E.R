

float SPAWN_RATE = 65;
float MAX_MONSTERS = 34;


entity(void() func, vector pos, vector ang) SpawnMonster =
{
	local entity monster = spawn();
	monster.think = func;
	monster.nextthink = time + 0.1;
	setorigin(monster, pos);
	monster.angles = ang;
	return monster;
};



void() monster_spawner_think =
{
	if (self.waitmin < time)
	{
		if(!IsVisible(FindNearestPlayer(self.origin)))
		{
			if(total_monsters < MAX_MONSTERS || (self.hook && !IsAllive(self.hook)))
			{
				local float rsnd = RandomInt(1, 5);
				if(rsnd == 1) self.hook = SpawnMonster(monster_dog, self.origin, self.angles);
				else if(rsnd == 2) self.hook = SpawnMonster(monster_zombie, self.origin, self.angles);
				else if(rsnd == 3) self.hook = SpawnMonster(monster_snork, self.origin, self.angles);
				else if(rsnd == 4) self.hook = SpawnMonster(monster_bloodsucker, self.origin, self.angles);
				else if(rsnd == 5) self.hook = SpawnMonster(monster_controller, self.origin, self.angles);
				// else if(rsnd == 6) self.hook = SpawnMonster(monster_psevdogigant, self.origin, self.angles);
			}
		}
		self.waitmin = time + SPAWN_RATE;
	}
	else if(self.hook && !self.hook.enemy && IsAllive(self.hook))
	{		
		entity oldself = self;
		self = self.hook;
		self.enemy = FindNearestPlayer(self.origin);
		FoundTarget();
		self = oldself;
	}
	self.nextthink = time + 1;
};

void() monster_spawner =
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	setsize(self, '-50 -50 -50', '50 50 50');
	self.nextthink = time + 0.1;
	self.think = monster_spawner_think;
};
