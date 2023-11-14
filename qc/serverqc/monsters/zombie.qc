float ZOMBIE_HEALTH = 450;
vector ZOMBIE_SIZE1 = '-7 -7 0';
vector ZOMBIE_SIZE2 = '7 7 47';
float ZOMBIE_ANIM_SPEED = 0.03;



/////////////////// SOUND //////////////////////////

void() zombie_attack_sound = 
{
	local float rsnd = random_int(1, 10);		
	if(rsnd == 0) sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_1.wav", 1, SoundRadius(450));
	else if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_2.wav", 1, SoundRadius(450));
	else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_3.wav", 1, SoundRadius(450));
	else if(rsnd == 3) sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_4.wav", 1, SoundRadius(450));
	else if(rsnd == 4) sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_5.wav", 1, SoundRadius(450));
	else if(rsnd == 5) sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_6.wav", 1, SoundRadius(450));
	else if(rsnd == 6) sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_7.wav", 1, SoundRadius(450));
	else if(rsnd == 7) sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_8.wav", 1, SoundRadius(450));
	else if(rsnd == 8) sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_9.wav", 1, SoundRadius(450));
	else sound (self, CHAN_VOICE, "monsters/zombie/zombie_attack_10.wav", 1, SoundRadius(450));
};

void(entity attacker, float damage)	zombie_pain =
{
	if (self.pain_finished > time) return;

	local float rsnd = random_int(1, 6);		
	if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/zombie/zombie_take_damage_1.wav", 1, SoundRadius(450));
	else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/zombie/zombie_take_damage_2.wav", 1, SoundRadius(450));
	else if(rsnd == 3) sound (self, CHAN_VOICE, "monsters/zombie/zombie_take_damage_3.wav", 1, SoundRadius(450));
	else if(rsnd == 4) sound (self, CHAN_VOICE, "monsters/zombie/zombie_take_damage_4.wav", 1, SoundRadius(450));
	else if(rsnd == 5) sound (self, CHAN_VOICE, "monsters/zombie/zombie_take_damage_5.wav", 1, SoundRadius(450));
	else sound (self, CHAN_VOICE, "monsters/zombie/zombie_take_damage_6.wav", 1, SoundRadius(450));
	self.pain_finished = time + 1;
}

void() zombie_die =
{
	Gib();
};

void() zombie_idle_sound =
{
	if(random() > 0.01) return;
	local float rsnd = random_int(1, 17);		
	if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_1.wav", 1, SoundRadius(350));
	else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_2.wav", 1, SoundRadius(350));
	else if(rsnd == 3) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_3.wav", 1, SoundRadius(350));
	else if(rsnd == 4) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_4.wav", 1, SoundRadius(350));
	else if(rsnd == 5) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_5.wav", 1, SoundRadius(350));
	else if(rsnd == 6) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_6.wav", 1, SoundRadius(350));
	else if(rsnd == 7) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_7.wav", 1, SoundRadius(350));
	else if(rsnd == 8) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_8.wav", 1, SoundRadius(350));
	else if(rsnd == 9) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_9.wav", 1, SoundRadius(350));
	else if(rsnd == 10) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_10.wav", 1, SoundRadius(350));
	else if(rsnd == 11) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_11.wav", 1, SoundRadius(350));
	else if(rsnd == 12) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_12.wav", 1, SoundRadius(350));
	else if(rsnd == 13) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_13.wav", 1, SoundRadius(350));
	else if(rsnd == 14) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_14.wav", 1, SoundRadius(350));
	else if(rsnd == 15) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_15.wav", 1, SoundRadius(350));
	else if(rsnd == 16) sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_16.wav", 1, SoundRadius(350));
	else sound (self, CHAN_VOICE, "monsters/zombie/zombie_idle_17.wav", 1, SoundRadius(350));
}
////////////////////////// IDLE ////////////////////////////

void() zombie_stand =
{
	setmodel (self, "models/monsters/zombie_idle.md3");
	setsize (self, ZOMBIE_SIZE1, ZOMBIE_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 30) self.frame = 0;
	
	self.think = zombie_stand;
	self.nextthink = time + ZOMBIE_ANIM_SPEED;
	ai_stand();
	zombie_idle_sound();
};

////////////////////////// WALK ////////////////////////////

void() zombie_walk =
{
	setmodel (self, "models/monsters/zombie_walk.md3");
	setsize (self, ZOMBIE_SIZE1, ZOMBIE_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 40) self.frame = 0;
	
	self.think = zombie_walk;
	self.nextthink = time + ZOMBIE_ANIM_SPEED;
	ai_walk(2);
};

////////////////////////// RUN ////////////////////////////

void() zombie_run =
{
	setmodel (self, "models/monsters/zombie_walk.md3");
	setsize (self, ZOMBIE_SIZE1, ZOMBIE_SIZE2);

	self.frame = self.frame + 1;
	if(self.frame > 40) self.frame = 0;
	
	self.think = zombie_run;
	self.nextthink = time + ZOMBIE_ANIM_SPEED;
	ai_run(1);
	zombie_idle_sound();
};

////////////////////////// ATTACK //////////////////////////

void() zombie_attack_loop =
{	
	self.frame = self.frame + 1;
	
	if(self.frame > self.weaponframe)  //46 49
	{
		self.think = zombie_run;
		self.nextthink = time + ZOMBIE_ANIM_SPEED;
	}
	else
	{
		if(self.frame & 10)
		{
			ai_charge(2);
		}
		if(self.frame == 22) ai_melee();
		self.nextthink = time + ZOMBIE_ANIM_SPEED;
	}
};

void() zombie_attack =
{
	if(random() > 0.51) 
	{
		setmodel (self, "models/monsters/zombie_attack1.md3");
		self.weaponframe = 57;
	}
	else 
	{
		setmodel (self, "models/monsters/zombie_attack2.md3");
		self.weaponframe = 39;
	}
	setsize (self, ZOMBIE_SIZE1, ZOMBIE_SIZE2);
	self.frame = 0;
	
	ai_charge(12);
	zombie_attack_sound();
	
	self.think = zombie_attack_loop;
	self.nextthink = time + ZOMBIE_ANIM_SPEED;
};

//INIT

void() zombie_precache =
{
	precache_model("models/monsters/zombie_idle.md3");
	precache_model("models/monsters/zombie_attack2.md3");
	precache_model("models/monsters/zombie_attack1.md3");
	precache_model("models/monsters/zombie_walk.md3");
	
	precache_sound("monsters/zombie/zombie_attack_1.wav");
	precache_sound("monsters/zombie/zombie_attack_2.wav");
	precache_sound("monsters/zombie/zombie_attack_3.wav");
	precache_sound("monsters/zombie/zombie_attack_4.wav");
	precache_sound("monsters/zombie/zombie_attack_5.wav");
	precache_sound("monsters/zombie/zombie_attack_6.wav");
	precache_sound("monsters/zombie/zombie_attack_7.wav");
	precache_sound("monsters/zombie/zombie_attack_8.wav");
	precache_sound("monsters/zombie/zombie_attack_9.wav");
	precache_sound("monsters/zombie/zombie_attack_10.wav");
	
	precache_sound("monsters/zombie/zombie_take_damage_1.wav");
	precache_sound("monsters/zombie/zombie_take_damage_2.wav");
	precache_sound("monsters/zombie/zombie_take_damage_3.wav");
	precache_sound("monsters/zombie/zombie_take_damage_4.wav");
	precache_sound("monsters/zombie/zombie_take_damage_5.wav");
	precache_sound("monsters/zombie/zombie_take_damage_6.wav");

	precache_sound("monsters/zombie/zombie_idle_1.wav");
	precache_sound("monsters/zombie/zombie_idle_2.wav");
	precache_sound("monsters/zombie/zombie_idle_3.wav");
	precache_sound("monsters/zombie/zombie_idle_4.wav");
	precache_sound("monsters/zombie/zombie_idle_5.wav");
	precache_sound("monsters/zombie/zombie_idle_6.wav");
	precache_sound("monsters/zombie/zombie_idle_7.wav");
	precache_sound("monsters/zombie/zombie_idle_8.wav");
	precache_sound("monsters/zombie/zombie_idle_9.wav");
	precache_sound("monsters/zombie/zombie_idle_10.wav");
	precache_sound("monsters/zombie/zombie_idle_11.wav");
	precache_sound("monsters/zombie/zombie_idle_12.wav");
	precache_sound("monsters/zombie/zombie_idle_13.wav");
	precache_sound("monsters/zombie/zombie_idle_14.wav");
	precache_sound("monsters/zombie/zombie_idle_15.wav");
	precache_sound("monsters/zombie/zombie_idle_16.wav");
	precache_sound("monsters/zombie/zombie_idle_17.wav");
	
	precache_sound("monsters/zombie/zombie_take_damage_1.wav");
	precache_sound("monsters/zombie/zombie_take_damage_2.wav");
	precache_sound("monsters/zombie/zombie_take_damage_3.wav");
	precache_sound("monsters/zombie/zombie_take_damage_4.wav");
	precache_sound("monsters/zombie/zombie_take_damage_5.wav");
	precache_sound("monsters/zombie/zombie_take_damage_6.wav");
	
};

void() monster_zombie =
{
	zombie_precache();
	
	self.classname = "monster_zombie";
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.yaw_speed = 12;
	self.scale = 1;

	setmodel (self, "models/monsters/zombie_idle.md3");
	setsize (self, ZOMBIE_SIZE1, ZOMBIE_SIZE2);
	self.health = ZOMBIE_HEALTH;
	self.th_stand = zombie_stand;
	self.th_walk = zombie_walk;
	self.th_run = zombie_run;
	self.th_melee = zombie_attack;
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.goalentity = world;
	self.enemy = world;
	self.checkAttack = CheckAttack;
	
	walkmonster_start();
};


