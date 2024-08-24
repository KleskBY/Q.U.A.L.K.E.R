/*
==============================================================================

DOG

==============================================================================
*/

float  DOG_HEALTH = 125;
vector DOG_SIZE1 = '-11 -11 0';
vector DOG_SIZE2 = '11 11 28';
float  DOG_ANIM_SPEED = 0.07;

float DOG_IDLE_START_FRAME = 69;
float DOG_IDLE_END_FRAME = 77;
float DOG_WALK_START_FRAME = 78;
float DOG_WALK_END_FRAME = 85;
float DOG_RUN_START_FRAME = 48;
float DOG_RUN_END_FRAME = 59;

float DOG_PAIN_START_FRAME = 26;
float DOG_PAIN_END_FRAME = 31;
float DOG_PAIN2_START_FRAME = 32;
float DOG_PAIN2_END_FRAME = 47;

float DOG_DEATH_START_FRAME = 8;
float DOG_DEATH_END_FRAME = 16;
float DOG_DEATH2_START_FRAME = 17;
float DOG_DEATH2_END_FRAME = 25;

float DOG_ATTACK_START_FRAME = 0;
float DOG_ATTACK_END_FRAME = 7;
float DOG_JUMP_START_FRAME = 60;
float DOG_JUMP_END_FRAME = 68;


////////////////////////// SOUND //////////////////////////

void dog_idle_sound()
{
	if (random() > 0.1) return;
	if (self.waitmin < time)
	{
	 	self.waitmin = time + random();
		local float rsnd = RandomInt(1, 5);	
		if (rsnd == 1) sound (self, CHAN_VOICE, "monsters/dog/idle01.wav", 1, SoundRadius(800)); 
		else if (rsnd == 2) sound (self, CHAN_VOICE, "monsters/dog/idle02.wav", 1, SoundRadius(800)); 
		else if (rsnd == 3) sound (self, CHAN_VOICE, "monsters/dog/idle03.wav", 1, SoundRadius(800)); 
		else if (rsnd == 4) sound (self, CHAN_VOICE, "monsters/dog/idle04.wav", 1, SoundRadius(800)); 
		else if (rsnd == 5) sound (self, CHAN_VOICE, "monsters/dog/idle05.wav", 1, SoundRadius(800)); 
	}
};

void dog_attack_sound()
{
	local float rsnd = RandomInt(1, 3);	
	if (rsnd == 1) sound (self, CHAN_VOICE, "monsters/dog/attack01.wav", 1, SoundRadius(800)); 
	else if (rsnd == 2) sound (self, CHAN_VOICE, "monsters/dog/attack02.wav", 1, SoundRadius(800)); 
	else if (rsnd == 3) sound (self, CHAN_VOICE, "monsters/dog/attack03.wav", 1, SoundRadius(800)); 
};

void dog_pain_sound()
{
	local float rsnd = RandomInt(1, 3);
	if (rsnd == 1) sound (self, CHAN_VOICE, "monsters/dog/pain01.wav", 1, SoundRadius(800)); 
	else if (rsnd == 2) sound (self, CHAN_VOICE, "monsters/dog/pain02.wav", 1, SoundRadius(800)); 
	else if (rsnd == 3) sound (self, CHAN_VOICE, "monsters/dog/pain03.wav", 1, SoundRadius(800)); 
};

void dog_death_sound()
{
	local float rsnd = RandomInt(1, 4);	
	if (rsnd == 1) sound (self, CHAN_VOICE, "monsters/dog/die01.wav", 1, SoundRadius(800)); 
	else if (rsnd == 2) sound (self, CHAN_VOICE, "monsters/dog/die02.wav", 1, SoundRadius(800)); 
	else if (rsnd == 3) sound (self, CHAN_VOICE, "monsters/dog/die03.wav", 1, SoundRadius(800)); 
	else if (rsnd == 4) sound (self, CHAN_VOICE, "monsters/dog/die04.wav", 1, SoundRadius(800)); 
};

////////////////////////// IDLE //////////////////////////

void() dog_stand =
{
	self.frame = self.frame + 1;
	if(self.frame < DOG_IDLE_START_FRAME || self.frame > DOG_IDLE_END_FRAME) self.frame = DOG_IDLE_START_FRAME;
	
	self.think = dog_stand;
	self.nextthink = time + DOG_ANIM_SPEED;
	dog_idle_sound();
	ai_stand();
};

////////////////////////// WALK //////////////////////////

void() dog_walk =
{
	self.frame = self.frame + 1;
	if(self.frame < DOG_WALK_START_FRAME || self.frame > DOG_WALK_END_FRAME) self.frame = DOG_WALK_START_FRAME;
	
	self.think = dog_walk;
	self.nextthink = time + DOG_ANIM_SPEED;
	ai_walk(2);
	dog_idle_sound();
};

////////////////////////// RUN  //////////////////////////

void() dog_run =
{
	self.frame = self.frame + 1;
	if(self.frame < DOG_RUN_START_FRAME || self.frame > DOG_RUN_END_FRAME) self.frame = DOG_RUN_START_FRAME;
	
	self.think = dog_run;
	self.nextthink = time + DOG_ANIM_SPEED;
	ai_run(20);
	dog_idle_sound();
};


////////////////////////// ATTACK //////////////////////////

void() dog_bite =
{
	local vector delta;
	local float ldmg;

	dog_attack_sound();
	if (!self.enemy) return;
	ai_charge(10);
	if (!CanDamage (self.enemy, self)) return;

	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100) return;
	ldmg = (random() + random() + random()) * 8;
	T_Damage (self.enemy, self, self, ldmg);
};

void() dog_jump;
void() Dog_JumpTouch =
{
	local float	ldmg;

	if (self.health <= 0) return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 300 )
		{
			ldmg = 10 + 10 * random();
			T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND) // jump randomly to not get hung up
		{	
			// self.touch = SUB_Null;
			self.think = dog_jump;
			self.nextthink = time + 0.1;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = dog_run;
	self.nextthink = time + 0.1;
};


void() dog_attack =
{
	self.frame = self.frame + 1;
	self.think = dog_attack;
	self.nextthink = time + DOG_ANIM_SPEED;
	
	if (self.frame < DOG_ATTACK_START_FRAME || self.frame > DOG_ATTACK_END_FRAME)
	{
		self.frame = DOG_ATTACK_START_FRAME;
		ai_charge(25);
	}
	if(self.frame == DOG_ATTACK_END_FRAME - 4) dog_bite();
	if(self.frame == DOG_ATTACK_END_FRAME)
	{
		self.think = dog_run;
		
	}
};

////////////////////////// jump //////////////////////////

void() dog_jump =
{
	self.frame = self.frame + 1;
	self.think = dog_jump;
	self.nextthink = time + DOG_ANIM_SPEED;
	
	if(self.frame == DOG_JUMP_END_FRAME)
	{
		self.think = dog_run;
	}
	if (self.frame < DOG_JUMP_START_FRAME || self.frame > DOG_JUMP_END_FRAME)
	{
		self.frame = DOG_JUMP_START_FRAME;
		
		ai_face();
		self.lastTouch = time + 2;
		self.touch = Dog_JumpTouch;
		makevectors (self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 300 + '0 0 200';
		if (self.flags & FL_ONGROUND) self.flags = self.flags - FL_ONGROUND;
	}	
};

////////////////////////// PAIN //////////////////////////


void() dog_pain1 =
{
	self.frame = self.frame + 1;
	if(self.frame > DOG_PAIN_END_FRAME) self.think = dog_run;
	else self.think = dog_pain1;
	self.nextthink = time + DOG_ANIM_SPEED;
	ai_painforward(1);
};

void() dog_pain2 =
{
	self.frame = self.frame + 1;
	if(self.frame > DOG_PAIN2_END_FRAME) self.think = dog_run;
	else self.think = dog_pain1;
	self.nextthink = time + DOG_ANIM_SPEED;
	ai_painforward(1);
};

void(entity attacker, float damage)	dog_pain =
{
	if (random() > 0.6) return;
	if (self.pain_finished > time) return;
	local float r = random();
	if(random() >= 0.5) 
	{
		self.frame = DOG_PAIN_START_FRAME;
		dog_pain1();
	}
	else 
	{
		self.frame = DOG_PAIN2_START_FRAME;
		dog_pain2();
	}
	dog_pain_sound();
	self.pain_finished = time + 4;
};

////////////////////////// DEATH //////////////////////////

void() dog_die1 =
{
	if(self.solid != SOLID_CORPSE) self.frame = DOG_DEATH_START_FRAME;
	else if(self.frame < DOG_DEATH_END_FRAME) self.frame = self.frame + 1;
	else self.nextthink = 0;
	setsize(self, DOG_SIZE1 + '-2 -2 0', '15 15 12');
	self.solid = SOLID_CORPSE;
	self.think = dog_die1;
	self.nextthink = time + DOG_ANIM_SPEED;
};

void() dog_die2 =
{
	if(self.solid != SOLID_CORPSE) self.frame = DOG_DEATH2_START_FRAME;
	else if(self.frame < DOG_DEATH2_END_FRAME) self.frame = self.frame + 1;
	else self.nextthink = 0;
	setsize(self, DOG_SIZE1 + '-2 -2 0', '15 15 12');
	self.solid = SOLID_CORPSE;
	self.think = dog_die2;
	self.nextthink = time + DOG_ANIM_SPEED;
};


void() dog_die =
{
	if(self.health < 40) 
	{
		Gib();
		return;
	}
	
	droptofloor();
	dog_death_sound();
	if(random() > 0.5) dog_die1();
	else dog_die2();
};

////////////////////////// CHECK ATTACK //////////////////////////


float()	CheckDogMelee =
{
	local vector dist = self.enemy.origin - self.origin;
	// dist_z = 0;
	local float	d = vlen(dist);
	// if (enemy_range == RANGE_MELEE) // FIXME: check canreach
	if(d < 90)
	{	
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

float()	CheckDogJump =
{
	local vector dist;
	local float	d;

	if(self.lastTouch > time) return FALSE;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	if (d < 80) return FALSE;
	if (d > 150) return FALSE;
	return TRUE;
};

float()	DogCheckAttack =
{
	if (CheckDogMelee()) // if close enough for slashing, go for it
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckDogJump())
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
};


/////////////////////////// INIT //////////////////////////

void() dog_precache =
{
	precache_model("models/monsters/dog.md3");
	precache_sound("monsters/dog/idle01.wav");
	precache_sound("monsters/dog/idle02.wav");
	precache_sound("monsters/dog/idle03.wav");
	precache_sound("monsters/dog/idle04.wav");
	precache_sound("monsters/dog/idle05.wav");
	precache_sound("monsters/dog/attack01.wav");
	precache_sound("monsters/dog/attack02.wav");
	precache_sound("monsters/dog/attack03.wav");
	precache_sound("monsters/dog/die01.wav");
	precache_sound("monsters/dog/die02.wav");
	precache_sound("monsters/dog/die03.wav");
	precache_sound("monsters/dog/die04.wav");
	precache_sound("monsters/dog/pain01.wav");
	precache_sound("monsters/dog/pain02.wav");
	precache_sound("monsters/dog/pain03.wav");
}

void() monster_dog =
{
	dog_precache();

	self.classname = "monster_dog";
	self.yaw_speed = 12;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/monsters/dog.md3");
	setsize (self, DOG_SIZE1, DOG_SIZE2);
	self.health = DOG_HEALTH;
	self.skin = rint(random(0,4));
	self.scale = 0.75;

	self.th_stand = dog_stand;
	self.th_walk = dog_walk;
	self.th_run = dog_run;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_attack;
	self.th_missile = dog_jump;

	self.checkAttack = DogCheckAttack;
	walkmonster_start();
};
