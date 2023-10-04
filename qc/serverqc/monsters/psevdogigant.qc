float PSEVDOGIGANT_HEALTH = 3500;
vector PSEVDOGIGANT_SIZE1 = '-38 -38 0';
vector PSEVDOGIGANT_SIZE2 = '38 38 90';
float PSEVDOGIGANT_ANIM_SPEED = 0.03;

float PSEVDOGIGANT_KICK_RADIUS = 500;
float PSEVDOGIGANT_KICK_DAMAGE = 30;
float PSEVDOGIGANT_KICK_POWER = 11;
float PSEVDOGIGANT_KICK_COOLDOWN = 10;

/////////////////// SOUND //////////////////////////

void(entity attacker, float damage)	psevdogigant_pain =
{
}

void() psevdogigant_die =
{
	Gib();
};

void() psevdogigant_idle_sound =
{
	if(random() > 0.01) return;
	local float rsnd = random_int(1, 5);	
	if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/giant/giant_idle_0.wav", 1, ATTN_IDLE);
	else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/giant/giant_idle_1.wav", 1, ATTN_IDLE);
	else if(rsnd == 3) sound (self, CHAN_VOICE, "monsters/giant/giant_breath_1.wav", 1, ATTN_IDLE);
	else if(rsnd == 4) sound (self, CHAN_VOICE, "monsters/giant/giant_breath_2.wav", 1, ATTN_IDLE);
	else sound (self, CHAN_VOICE, "monsters/giant/giant_breath_0.wav", 1, ATTN_IDLE);
}
////////////////////////// IDLE ////////////////////////////

void() psevdogigant_stand =
{
	psevdogigant_idle_sound();
	setmodel (self, "models/monsters/psevdogigant_idle.md3");
	setsize (self, PSEVDOGIGANT_SIZE1, PSEVDOGIGANT_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 219) self.frame = 0;
	
	self.think = psevdogigant_stand;
	self.nextthink = time + PSEVDOGIGANT_ANIM_SPEED;
	ai_stand();
	
};


////////////////////////// RUN ////////////////////////////


void kick_land(float radius, float kick_power, float damage)
{
	entity e = findradius(self.origin, radius);
	while(e) 
	{
		if(e.takedamage && !(e.flags & FL_MONSTER))
		{			
			float dist = vlen(self.origin - e.origin);
			float damageScale = 1.0 - (dist / radius);
			if(!(e.flags & FL_ONGROUND)) 
			{
				if(dist < radius / 2) damageScale = damageScale * 0.5;
				else damageScale = 0;
			}

			if(damageScale > 0)
			{
				if(damage > 0)
				{
					e.velocity_x = 0;
					e.velocity_y = 0;
					T_Damage (e, self, self, damage * damageScale);
				}
				
				e.punchangle = e.punchangle + [ 1 + kick_power * damageScale, 1 +  kick_power * damageScale, 1 + kick_power  * damageScale ] ;
			}
		}
		
		e = e.chain;
	}

};


void() psevdogigant_run =
{
	psevdogigant_idle_sound();
	self.think = psevdogigant_run;
	self.nextthink = time + PSEVDOGIGANT_ANIM_SPEED;
	
	if(self.health < PSEVDOGIGANT_HEALTH / 3) 
	{
		setmodel (self, "models/monsters/psevdogigant_walk2.md3");
		setsize (self, PSEVDOGIGANT_SIZE1, PSEVDOGIGANT_SIZE2);
		
		self.frame = self.frame + 1;
		if(self.frame > 49) self.frame = 0;
		ai_run(5);
	}
	else
	{
		setmodel (self, "models/monsters/psevdogigant_walk.md3");
		setsize (self, PSEVDOGIGANT_SIZE1, PSEVDOGIGANT_SIZE2);
		
		self.frame = self.frame + 1;
		if(self.frame > 29) self.frame = 0;
		if(self.frame == 4 || self.frame == 18) 
		{
			sound (self, CHAN_WEAPON, "monsters/giant/giant_hit.wav", 0.7, SoundRadius(750));
			kick_land(400, 2, 0);
		}
		ai_run(6);
	}
};

////////////////////////// WALK ////////////////////////////

void() psevdogigant_walk =
{
	setmodel (self, "models/monsters/psevdogigant_walk.md3");
	setsize (self, PSEVDOGIGANT_SIZE1, PSEVDOGIGANT_SIZE2);
	psevdogigant_idle_sound();
	
	self.frame = self.frame + 1;
	if(self.frame > 29) self.frame = 0;
	
	self.think = psevdogigant_walk;
	self.nextthink = time + PSEVDOGIGANT_ANIM_SPEED;
	ai_walk(3);
	
};
////////////////////////// ATTACK //////////////////////////

void() psevdogigant_attack_loop =
{	
	self.frame = self.frame + 1;
	
	if(self.frame > 40)
	{
		self.think = psevdogigant_run;
		self.nextthink = time + PSEVDOGIGANT_ANIM_SPEED;
	}
	else
	{
		if(self.frame & 4) ai_charge(5);
		if(self.frame == 15 || self.frame == 18 || self.frame == 21) ai_melee();
		self.nextthink = time + PSEVDOGIGANT_ANIM_SPEED;
	}
};

void() psevdogigant_attack =
{
	if(random() >= 0.5) 
	{
		sound(self, CHAN_VOICE, "monsters/giant/giant_attack_0.wav", 1, ATTN_IDLE);
		setmodel (self, "models/monsters/psevdogigant_attack1.md3");
	}
	else 
	{
		sound(self, CHAN_VOICE, "monsters/giant/giant_attack_1.wav", 1, ATTN_IDLE);
		setmodel (self, "models/monsters/psevdogigant_attack2.md3");
	}
	setsize (self, PSEVDOGIGANT_SIZE1, PSEVDOGIGANT_SIZE2);
	self.frame = 0;
	
	ai_charge(12);
	
	self.think = psevdogigant_attack_loop;
	self.nextthink = time + PSEVDOGIGANT_ANIM_SPEED;
};




//KICK



void() psevdogigant_kick_loop =
{	
	self.frame = self.frame + 1;
	
	if(self.frame == 49)
	{
		sound (self, CHAN_WEAPON, "monsters/giant/giant_hit.wav", 1, SoundRadius(1000));
		kick_land(PSEVDOGIGANT_KICK_RADIUS, PSEVDOGIGANT_KICK_POWER, PSEVDOGIGANT_KICK_DAMAGE);
	}

	self.nextthink = time + PSEVDOGIGANT_ANIM_SPEED;
	if(self.frame > 99) self.think = psevdogigant_run;
};

void() psevdogigant_kick =
{
	sound(self, CHAN_VOICE, "monsters/giant/giant_attack_0.wav", 1, ATTN_IDLE);
	setmodel(self, "models/monsters/psevdogigant_kick.md3");
	setsize(self, PSEVDOGIGANT_SIZE1, PSEVDOGIGANT_SIZE2);
	
	self.frame = 0;
	self.think = psevdogigant_kick_loop;
	self.nextthink = time + PSEVDOGIGANT_ANIM_SPEED;
};

//Check attack

float()	psevdogigant_check_attack =
{
	float dist = vlen(self.enemy.origin - self.origin);	
	if (dist < 100)
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (dist > 110 && dist < (PSEVDOGIGANT_KICK_RADIUS * 0.75) && self.lastTouch < time)
	{
		self.lastTouch = time + PSEVDOGIGANT_KICK_COOLDOWN;
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
};



//INIT

void() psevdogigant_precache =
{
	precache_model2("models/monsters/psevdogigant_idle.md3");
	precache_model2("models/monsters/psevdogigant_attack2.md3");
	precache_model2("models/monsters/psevdogigant_attack1.md3");
	precache_model2("models/monsters/psevdogigant_walk.md3");
	precache_model2("models/monsters/psevdogigant_walk2.md3");
	precache_model2("models/monsters/psevdogigant_kick.md3");
	
	precache_sound2("monsters/giant/giant_attack_0.wav");
	precache_sound2("monsters/giant/giant_attack_1.wav");
	precache_sound2("monsters/giant/giant_hit.wav");
		
	precache_sound2("monsters/giant/giant_idle_0.wav");
	precache_sound2("monsters/giant/giant_idle_1.wav");
	precache_sound2("monsters/giant/giant_breath_0.wav");
	precache_sound2("monsters/giant/giant_breath_1.wav");
	precache_sound2("monsters/giant/giant_breath_2.wav");
};

void() monster_psevdogigant =
{
	psevdogigant_precache();
	
	self.classname = "monster_psevdogigant";
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.yaw_speed = 9;
	self.scale = 0.6;

	setmodel (self, "models/monsters/psevdogigant_idle.md3");
	setsize (self, PSEVDOGIGANT_SIZE1, PSEVDOGIGANT_SIZE2);
	self.health = PSEVDOGIGANT_HEALTH;
	self.th_stand = psevdogigant_stand;
	self.th_walk = psevdogigant_walk;
	self.th_run = psevdogigant_run;
	self.th_melee = psevdogigant_attack;
	self.th_missile = psevdogigant_kick;	
	self.th_pain = psevdogigant_pain;
	self.th_die = psevdogigant_die;
	self.checkAttack = psevdogigant_check_attack;
	
	walkmonster_start();
};


