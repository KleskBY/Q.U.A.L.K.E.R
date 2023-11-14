float SNORK_HEALTH = 500;
vector SNORK_SIZE1 = '-14 -14 0';
vector SNORK_SIZE2 = '14 14 28';
float SNORK_ANIM_SPEED = 0.03;


/////////////////// SOUND //////////////////////////

void(entity attacker, float damage)	snork_pain =
{
}

void() snork_die =
{
	Gib();
};

void() snork_idle_sound =
{
	if(random() > 0.01) return;
	local float rsnd = random_int(1, 3);	
	if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/snork/snork_idle_1.wav", 1, ATTN_IDLE);
	else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/snork/snork_idle_2.wav", 1, ATTN_IDLE);
	else sound (self, CHAN_VOICE, "monsters/snork/snork_idle_0.wav", 1, ATTN_IDLE);
}
////////////////////////// IDLE ////////////////////////////

void() snork_stand =
{
	setmodel (self, "models/monsters/snork_idle.md3");
	setsize (self, SNORK_SIZE1, SNORK_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 146) self.frame = 0;
	
	self.think = snork_stand;
	self.nextthink = time + SNORK_ANIM_SPEED;
	ai_stand();
	// snork_idle_sound();
	
};


////////////////////////// RUN ////////////////////////////

void() snork_run =
{
	setmodel (self, "models/monsters/snork_run.md3");
	setsize (self, SNORK_SIZE1, SNORK_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 29) self.frame = 0;
	
	self.think = snork_run;
	self.nextthink = time + SNORK_ANIM_SPEED;
	ai_run(4);
	snork_idle_sound();
};

////////////////////////// WALK ////////////////////////////

void() snork_walk =
{
	setmodel (self, "models/monsters/snork_walk.md3");
	setsize (self, SNORK_SIZE1, SNORK_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 30) self.frame = 0;
	
	self.think = snork_walk;
	self.nextthink = time + SNORK_ANIM_SPEED;
	ai_walk(1);
	// snork_idle_sound();
};
////////////////////////// ATTACK //////////////////////////

void() snork_attack_loop =
{	
	self.frame = self.frame + 1;
	
	if(self.frame > 49)  //46 49
	{
		self.think = snork_run;
		self.nextthink = time + SNORK_ANIM_SPEED;
	}
	else
	{
		if(self.frame & 4)
		{
			ai_charge(6);
		}
		
		if(self.frame == 18 || self.frame == 25) 
		{
			ai_melee();
		}
		
		// self.think = snork_attack_loop;
		self.nextthink = time + SNORK_ANIM_SPEED;
	}
};

void() snork_attack =
{
	if(random() >= 0.5) sound(self, CHAN_VOICE, "monsters/snork/snork_attack_hit_0.wav", 1, ATTN_IDLE);
	else sound(self, CHAN_VOICE, "monsters/snork/snork_attack_hit_1.wav", 1, ATTN_IDLE);
	
	if(random() > 0.51) setmodel (self, "models/monsters/snork_attack2.md3");
	else setmodel (self, "models/monsters/snork_attack1.md3");
	
	setsize (self, SNORK_SIZE1, SNORK_SIZE2);
	self.frame = 0;
	
	ai_charge(12);
	
	self.think = snork_attack_loop;
	self.nextthink = time + SNORK_ANIM_SPEED;
};

//JUMP

void() snork_land_loop = 
{
	self.frame = self.frame + 1;
	if(self.frame > 7) 
	{
		self.frame = 0;
		self.think = snork_run;
	}
	else self.think = snork_land_loop;
	self.nextthink = time + SNORK_ANIM_SPEED;
}

void() snork_land = 
{
	setmodel (self, "models/monsters/snork_jump_land.md3");
	setsize (self, SNORK_SIZE1, SNORK_SIZE2);
	self.frame = 2;
	
	self.think = snork_land_loop;
	self.nextthink = time + SNORK_ANIM_SPEED;
	self.lastTouch = time;
}

void() snork_touch =
{
	if (self.health <= 0) return;
	local	float	ldmg;
	
	setmodel (self, "models/monsters/snork_jump_land.md3");
	setsize (self, SNORK_SIZE1, SNORK_SIZE2);
		
	if (other.takedamage)
	{
		if (vlen(self.velocity) > 400)
		{
			ldmg = 40 + 10 * random();
			T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = SUB_Null;
			self.think = snork_land;
			self.nextthink = time + 0.1;
		}
		return;	// not on ground yet
	}
	self.touch = SUB_Null;
	self.think = snork_land;
	self.nextthink = time + 0.1;
}


void() snork_jump;
void() snork_jump_loop = //animation in air
{	
	self.frame = self.frame + 1;
	
	if(self.frame > 16) //stop updating animation while in air and jump again if stuck
	{
		self.think = snork_jump;
		self.nextthink = time + 2; 
	}
	else self.nextthink = time + SNORK_ANIM_SPEED;
	
};

void() snork_jump_start =
{	
	self.frame = self.frame + 1;
	
	if(self.frame > 6) //Jump moment
	{
		setmodel (self, "models/monsters/snork_jump_air.md3");
		setsize (self, SNORK_SIZE1, SNORK_SIZE2);
		
		if(random() > 0.6)
		{
			local float rsnd = random_int(1, 3);	
			if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/snork/snork_idle_1.wav", 1, ATTN_IDLE);
			else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/snork/snork_idle_2.wav", 1, ATTN_IDLE);
			else sound (self, CHAN_VOICE, "monsters/snork/snork_idle_0.wav", 1, ATTN_IDLE);
		}
			
		ai_face();
		self.touch = snork_touch;
		makevectors (self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 600 + '0 0 275';
		if (self.flags & FL_ONGROUND) self.flags = self.flags - FL_ONGROUND;
		
		self.think = snork_jump_loop;
		self.nextthink = time + SNORK_ANIM_SPEED;
	}
	else
	{
		ai_face();
		self.nextthink = time + SNORK_ANIM_SPEED;
	}
};

void() snork_jump =
{
	if(self.lastTouch + 3 < time)
	{
		setmodel (self, "models/monsters/snork_jump.md3");
		setsize (self, SNORK_SIZE1, SNORK_SIZE2);
		self.frame = 0;
		
		ai_face();
		
		self.think = snork_jump_start;
		self.nextthink = time + SNORK_ANIM_SPEED;
	}
};

//INIT

void() snork_precache =
{
	precache_model("models/monsters/snork_idle.md3");
	precache_model("models/monsters/snork_attack2.md3");
	precache_model("models/monsters/snork_attack1.md3");
	precache_model("models/monsters/snork_walk.md3");
	precache_model("models/monsters/snork_run.md3");
	precache_model("models/monsters/snork_jump.md3");
	precache_model("models/monsters/snork_jump_air.md3");
	precache_model("models/monsters/snork_jump_land.md3");
	
	precache_sound("monsters/snork/snork_attack_hit_0.wav");
	precache_sound("monsters/snork/snork_attack_hit_1.wav");
		
	precache_sound("monsters/snork/snork_idle_0.wav");
	precache_sound("monsters/snork/snork_idle_1.wav");
	precache_sound("monsters/snork/snork_idle_2.wav");
	
};

void() monster_snork =
{
	snork_precache();
	
	self.classname = "monster_snork";
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.yaw_speed = 12;

	setmodel (self, "models/monsters/snork_idle.md3");
	setsize (self, SNORK_SIZE1, SNORK_SIZE2);
	self.health = SNORK_HEALTH;
	self.th_stand = snork_stand;
	self.th_walk = snork_walk;
	self.th_run = snork_run;
	self.th_melee = snork_attack;
	self.th_missile = snork_jump;	
	self.th_pain = snork_pain;
	self.th_die = snork_die;
	self.checkAttack = CheckAttack;
	
	walkmonster_start();
};


