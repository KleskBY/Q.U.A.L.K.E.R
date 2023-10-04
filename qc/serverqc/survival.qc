


void EndRound() 
{
	for (entity e = findchain(classname, "player"); e; e = e.chain) 
	{
		e.attack_finished = time + 1;
		respawnPlayer(e);
	}
	for (entity e = findchain(classname, "observer"); e; e = e.chain) 
	{
		e.attack_finished = time + 1;
		respawnPlayer(e);
	}
}


.float wave_dog, wave_zombie, wave_snork, wave_bloodsucker, wave_controller, wave_giant, wave_grunt;
void SetMonsters()
{
	if(self.frame == 1)
	{
		self.wave_dog = 10;
	}
	else if(self.frame == 2)
	{
		self.wave_dog = 5;
		self.wave_zombie = 10;
	}
	else if(self.frame == 3)
	{
		self.wave_dog = 5;
		self.wave_zombie = 10;
		self.wave_snork = 10;
	}
	else if(self.frame == 4)
	{
		self.wave_bloodsucker = 15;
	}
	else if(self.frame == 5)
	{
		self.wave_snork = 10;
		self.wave_dog = 15;
	}
	else if(self.frame == 6)
	{
		self.wave_controller = 3;
		self.wave_zombie = 20;
	}
	else if(self.frame == 7)
	{
		self.wave_giant = 1;
		self.wave_controller = 1;
		self.wave_dog = 10;
		self.wave_bloodsucker = 5;
	}
	else if(self.frame == 8)
	{
		self.wave_grunt = 10;
	}
	else 
	{
		self.wave_dog = rint(random(0, self.frame));
		self.wave_snork = rint(random(0, self.frame));
		self.wave_giant = 1;
		self.wave_controller = rint(random(0, self.frame / 3));
		self.wave_bloodsucker = rint(random(0, self.frame / 2));
	}
}





void survival_think();
void StartNewWave()
{
	self.nextthink = time + 0.4;
	if(self.hook && !self.hook.enemy && allive(self.hook))
	{
		entity oldself = self;
		self = self.hook;
		self.enemy = NearestPlayer(self.origin);
		if(self.enemy) FoundTarget();
		self = oldself;
		self.hook = world;
	}
	
	{
		vector rvec = randomvec() * 40;
		rvec_z = 0;
		if(self.wave_dog > 0) 
		{
			self.hook = SpawnMonster(monster_dog, self.origin - rvec, self.angles);
			self.wave_dog -= 1;
			return;
		}
		if(self.wave_zombie > 0) 
		{
			self.hook = SpawnMonster(monster_zombie, self.origin - rvec, self.angles);
			self.wave_zombie -= 1;
			return;
		}
		if(self.wave_snork > 0) 
		{
			self.hook = SpawnMonster(monster_snork, self.origin - rvec, self.angles);
			self.wave_snork -= 1;
			return;
		}
		if(self.wave_bloodsucker > 0) 
		{
			self.hook = SpawnMonster(monster_bloodsucker, self.origin - rvec, self.angles);
			self.wave_bloodsucker -= 1;
			return;
		}
		if(self.wave_controller > 0) 
		{
			self.hook = SpawnMonster(monster_controller, self.origin - rvec, self.angles);
			self.wave_controller -= 1;
			return;
		}
		if(self.wave_giant > 0) 
		{
			self.hook = SpawnMonster(monster_psevdogigant, self.origin - rvec, self.angles);
			self.wave_giant -= 1;
			return;
		}
		if(self.wave_grunt > 0) 
		{
			self.hook = SpawnMonster(monster_grunt, self.origin - rvec, self.angles);
			self.wave_grunt -= 1;
			return;
		}
		
		self.think = survival_think;
	}
};


void PrepareNextWave()
{
	self.nextthink = time + 1;
	if(time > self.timer)
	{
		self.frame = self.frame + 1; //wave number
		SetMonsters();
		for (entity e = findchain(classname, "player"); e; e = e.chain) 
		{
			centerprint(e, strcat("WAVE ", ftos(self.frame)));
		}
		
		self.think = StartNewWave;
		return;
	}

	
	for (entity e = findchain(classname, "observer"); e; e = e.chain) 
	{
		respawnPlayer(e);
	}
	for (entity e = findchain(classname, "player"); e; e = e.chain) 
	{
		centerprint(e, strcat("Next wave in ", ftos(self.timer - time)));
	}
};



void() survival_think =
{
	self.nextthink = time + 1;
	
	float totalAllivePlayers;
	for (entity e = findchain(classname, "player"); e; e = e.chain) 
	{
		if(allive(e)) totalAllivePlayers += 1;
	}
	if(totalAllivePlayers <= 0)
	{
		bprint("All players are dead! Restarting...\n");
		self.think = EndRound;
		self.nextthink = time + 5;
		return;
	}
	
	float alliveMonsters;
	for (entity e = findchainflags(flags, FL_MONSTER); e; e = e.chain) 
	{
		if(allive(e)) alliveMonsters += 1;
	}
	if(alliveMonsters <= 0)
	{
		bprint("Prepare for the next wave!\n");
		self.think = PrepareNextWave;
		self.nextthink = time + 5;
		self.timer = self.nextthink + 15;
	}

	
}

void() survival =
{
	self.classname = "survival";
	self.think = survival_think;
	self.nextthink = time + 1;
}


