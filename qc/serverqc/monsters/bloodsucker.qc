float BLOODSUCKER_HEALTH = 600;
vector BLOODSUCKER_SIZE1 = '-7 -7 0';
vector BLOODSUCKER_SIZE2 = '7 7 48';
float BLOODSUCKER_ANIM_SPEED = 0.03;

void() GoInvisible = 
{
	if(self.alpha > 0.1) self.alpha = self.alpha - BLOODSUCKER_ANIM_SPEED * 2;
};

void() GoVisible = 
{
	if(self.alpha < 1) self.alpha = self.alpha + BLOODSUCKER_ANIM_SPEED * 3;
};

/////////////////// SOUND //////////////////////////

void(entity attacker, float damage)	bloodsucker_pain =
{
	if (self.pain_finished > time) return;

	local float rsnd = RandomInt(1, 6);	
	if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/bloodsucker/hit_1.wav", 1, ATTN_IDLE);
	else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/bloodsucker/hit_2.wav", 1, ATTN_IDLE);
	else if(rsnd == 3) sound (self, CHAN_VOICE, "monsters/bloodsucker/hit_3.wav", 1, ATTN_IDLE);
	else if(rsnd == 4) sound (self, CHAN_VOICE, "monsters/bloodsucker/hit_4.wav", 1, ATTN_IDLE);
	else if(rsnd == 5) sound (self, CHAN_VOICE, "monsters/bloodsucker/hit_5.wav", 1, ATTN_IDLE);
	else sound (self, CHAN_VOICE, "monsters/bloodsucker/hit_6.wav", 1, ATTN_IDLE);
	self.pain_finished = time + 1;
}

void() bloodsucker_die =
{
	local float rsnd = RandomInt(1, 5);	
	if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/bloodsucker/die_1.wav", 1, ATTN_IDLE);
	else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/bloodsucker/die_2.wav", 1, ATTN_IDLE);
	else if(rsnd == 3) sound (self, CHAN_VOICE, "monsters/bloodsucker/die_3.wav", 1, ATTN_IDLE);
	else if(rsnd == 4) sound (self, CHAN_VOICE, "monsters/bloodsucker/die_4.wav", 1, ATTN_IDLE);
	else sound (self, CHAN_VOICE, "monsters/bloodsucker/die_0.wav", 1, ATTN_IDLE);
	
	Gib();

};

void() bloodsucker_idle_sound =
{
	if(random() > 0.025) return;
	local float rsnd = RandomInt(1, 6);		
	if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/bloodsucker/idle_1.wav", 1, SoundRadius(350));
	else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/bloodsucker/idle_2.wav", 1, SoundRadius(350));
	else if(rsnd == 3) sound (self, CHAN_VOICE, "monsters/bloodsucker/idle_3.wav", 1, SoundRadius(350));
	else if(rsnd == 4) sound (self, CHAN_VOICE, "monsters/bloodsucker/idle_4.wav", 1, SoundRadius(350));
	else if(rsnd == 5) sound (self, CHAN_VOICE, "monsters/bloodsucker/idle_5.wav", 1, SoundRadius(350));
	else sound (self, CHAN_VOICE, "monsters/bloodsucker/idle_0.wav", 1, SoundRadius(350));
}
////////////////////////// IDLE ////////////////////////////

void() bloodsucker_stand =
{
	setmodel (self, "models/monsters/bloodsucker_idle.md3");
	setsize (self, BLOODSUCKER_SIZE1, BLOODSUCKER_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 146) self.frame = 0;
	
	self.think = bloodsucker_stand;
	self.nextthink = time + BLOODSUCKER_ANIM_SPEED;
	ai_stand();
	GoVisible();
	bloodsucker_idle_sound();
	
};


////////////////////////// RUN ////////////////////////////

void() bloodsucker_run =
{
	if (self.timer < time) 
	{
		sound (self, CHAN_VOICE, "monsters/bloodsucker/sucker_breath_mix_0.wav", 1, ATTN_IDLE);
		self.timer = time + 7;
	}
	setmodel (self, "models/monsters/bloodsucker_run.md3");
	setsize (self, BLOODSUCKER_SIZE1, BLOODSUCKER_SIZE2);
	GoInvisible();
	
	self.frame = self.frame + 1;
	if(self.frame > 29) self.frame = 0;
	
	self.think = bloodsucker_run;
	self.nextthink = time + BLOODSUCKER_ANIM_SPEED;
	ai_run(5);
};

////////////////////////// WALK ////////////////////////////

void() bloodsucker_walk =
{
	setmodel (self, "models/monsters/bloodsucker_walk.md3");
	setsize (self, BLOODSUCKER_SIZE1, BLOODSUCKER_SIZE2);
	GoVisible();
	
	self.frame = self.frame + 1;
	if(self.frame > 29) self.frame = 0;
	
	self.think = bloodsucker_walk;
	self.nextthink = time + BLOODSUCKER_ANIM_SPEED;
	ai_walk(1);
};
////////////////////////// ATTACK //////////////////////////

void() bloodsucker_attack_loop =
{	
	GoVisible();
	self.frame = self.frame + 1;
	
	if(self.frame > 49)  //46 49
	{
		self.think = bloodsucker_run;
		self.nextthink = time + BLOODSUCKER_ANIM_SPEED;
	}
	else
	{
		if(self.frame & 5) ai_charge(5);
		if(self.frame == 10 || self.frame == 20 || self.frame == 30 || self.frame == 40) ai_melee();
	
		
		// self.think = bloodsucker_attack_loop;
		self.nextthink = time + BLOODSUCKER_ANIM_SPEED;
	}
};

void() bloodsucker_attack =
{
	local float rsnd = RandomInt(1, 4);		
	if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/bloodsucker/attack_1.wav", 1, ATTN_IDLE);
	else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/bloodsucker/attack_2.wav", 1, ATTN_IDLE);
	else if(rsnd == 3) sound (self, CHAN_VOICE, "monsters/bloodsucker/attack_3.wav", 1, ATTN_IDLE);
	else sound (self, CHAN_VOICE, "monsters/bloodsucker/attack_0.wav", 1, ATTN_IDLE);
	
	if(random() > 0.51) setmodel (self, "models/monsters/bloodsucker_attack2.md3");
	else setmodel (self, "models/monsters/bloodsucker_attack1.md3");
	setsize (self, BLOODSUCKER_SIZE1, BLOODSUCKER_SIZE2);

	self.frame = 0;
	
	ai_charge(12);
	
	self.think = bloodsucker_attack_loop;
	self.nextthink = time + BLOODSUCKER_ANIM_SPEED;
};

//INIT

void() bloodsucker_precache =
{
	precache_model("models/monsters/bloodsucker_idle.md3");
	precache_model("models/monsters/bloodsucker_attack2.md3");
	precache_model("models/monsters/bloodsucker_attack1.md3");
	precache_model("models/monsters/bloodsucker_walk.md3");
	precache_model("models/monsters/bloodsucker_run.md3");
	
	precache_sound("monsters/bloodsucker/attack_0.wav");
	precache_sound("monsters/bloodsucker/attack_1.wav");
	precache_sound("monsters/bloodsucker/attack_2.wav");
	precache_sound("monsters/bloodsucker/attack_3.wav");
	
	precache_sound("monsters/bloodsucker/sucker_breath_mix_0.wav");
	
	precache_sound("monsters/bloodsucker/idle_0.wav");
	precache_sound("monsters/bloodsucker/idle_1.wav");
	precache_sound("monsters/bloodsucker/idle_2.wav");
	precache_sound("monsters/bloodsucker/idle_3.wav");
	precache_sound("monsters/bloodsucker/idle_4.wav");
	precache_sound("monsters/bloodsucker/idle_5.wav");
	
	precache_sound("monsters/bloodsucker/hit_0.wav");
	precache_sound("monsters/bloodsucker/hit_1.wav");
	precache_sound("monsters/bloodsucker/hit_2.wav");
	precache_sound("monsters/bloodsucker/hit_3.wav");
	precache_sound("monsters/bloodsucker/hit_4.wav");
	precache_sound("monsters/bloodsucker/hit_5.wav");
	precache_sound("monsters/bloodsucker/hit_6.wav");
	
	
	precache_sound("monsters/bloodsucker/die_0.wav");
	precache_sound("monsters/bloodsucker/die_1.wav");
	precache_sound("monsters/bloodsucker/die_2.wav");
	precache_sound("monsters/bloodsucker/die_3.wav");
	precache_sound("monsters/bloodsucker/die_4.wav");
	
};

void() monster_bloodsucker =
{
	bloodsucker_precache();
	
	self.classname = "monster_bloodsucker";
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.yaw_speed = 12;

	setmodel (self, "models/monsters/bloodsucker_idle.md3");
	setsize (self, BLOODSUCKER_SIZE1, BLOODSUCKER_SIZE2);
	self.health = BLOODSUCKER_HEALTH;
	self.th_stand = bloodsucker_stand;
	self.th_walk = bloodsucker_walk;
	self.th_run = bloodsucker_run;
	self.th_melee = bloodsucker_attack;
	self.th_pain = bloodsucker_pain;
	self.th_die = bloodsucker_die;
	self.checkAttack = CheckAttack;
	
	walkmonster_start();
};


