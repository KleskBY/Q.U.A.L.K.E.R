float CONTROLLER_HEALTH = 900;
vector CONTROLLER_SIZE1 = '-8 -8 0';
vector CONTROLLER_SIZE2 = '8 8 55';
float CONTROLLER_ANIM_SPEED = 0.03;

float CONTROLLER_KICK_RADIUS = 1400;
float CONTROLLER_KICK_DAMAGE = 30;
float CONTROLLER_KICK_POWER = 11;
float CONTROLLER_KICK_COOLDOWN = 5;

/////////////////// SOUND //////////////////////////

void(entity attacker, float damage)	controller_pain =
{
}

void() controller_sight =
{
	sound (self, CHAN_VOICE, "monsters/controller/controller_attack_hit_0.wav", 1, ATTN_IDLE);
}

void() controller_die =
{
	if(self.enemy) 
	{
		self.enemy.stopViewmodel = 0;
		stuffcmd(self.enemy, "cl_hud 1;r_trippy 0\n");
	}
	Gib();
};

void() controller_idle_sound =
{
	// if(random() > 0.01) return;
	// local float rsnd = random_int(1, 5);	
	// if(rsnd == 1) sound (self, CHAN_VOICE, "monsters/giant/giant_idle_0.wav", 1, ATTN_IDLE);
	// else if(rsnd == 2) sound (self, CHAN_VOICE, "monsters/giant/giant_idle_1.wav", 1, ATTN_IDLE);
	// else if(rsnd == 3) sound (self, CHAN_VOICE, "monsters/giant/giant_breath_1.wav", 1, ATTN_IDLE);
	// else if(rsnd == 4) sound (self, CHAN_VOICE, "monsters/giant/giant_breath_2.wav", 1, ATTN_IDLE);
	// else sound (self, CHAN_VOICE, "monsters/giant/giant_breath_0.wav", 1, ATTN_IDLE);
}
////////////////////////// IDLE ////////////////////////////

void() controller_stand =
{
	controller_idle_sound();
	setmodel (self, "models/monsters/controller_idle.md3");
	setsize (self, CONTROLLER_SIZE1, CONTROLLER_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 219) self.frame = 0;
	
	self.think = controller_stand;
	self.nextthink = time + CONTROLLER_ANIM_SPEED;
	ai_stand();
	
};


////////////////////////// RUN ////////////////////////////



void() controller_run =
{
	controller_idle_sound();
	self.think = controller_run;
	self.nextthink = time + CONTROLLER_ANIM_SPEED;
	
	setmodel (self, "models/monsters/controller_walk.md3");
	setsize (self, CONTROLLER_SIZE1, CONTROLLER_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 29) self.frame = 0;
	ai_run(2);

};

////////////////////////// WALK ////////////////////////////

void() controller_walk =
{
	setmodel (self, "models/monsters/controller_walk.md3");
	setsize (self, CONTROLLER_SIZE1, CONTROLLER_SIZE2);
	controller_idle_sound();
	
	self.frame = self.frame + 1;
	if(self.frame > 29) self.frame = 0;
	
	self.think = controller_walk;
	self.nextthink = time + CONTROLLER_ANIM_SPEED;
	ai_walk(4);
	
};
////////////////////////// ATTACK //////////////////////////

void() controller_attack_loop =
{	
	self.frame = self.frame + 1;
	
	if(self.frame > 40)
	{
		self.think = controller_run;
		self.nextthink = time + CONTROLLER_ANIM_SPEED;
	}
	else
	{
		if(self.frame & 4) ai_charge(5);
		if(self.frame == 15 || self.frame == 18 || self.frame == 21) ai_melee();
		self.nextthink = time + CONTROLLER_ANIM_SPEED;
	}
};

void() controller_attack =
{
	setmodel (self, "models/monsters/controller_attack1.md3");
	setsize (self, CONTROLLER_SIZE1, CONTROLLER_SIZE2);
	self.frame = 0;
	
	ai_charge(6);
	
	self.think = controller_attack_loop;
	self.nextthink = time + CONTROLLER_ANIM_SPEED;
};




//PSY ATTACK

void() controller_range_attack_loop =
{
	self.frame = self.frame + 1;
	self.nextthink = time + CONTROLLER_ANIM_SPEED;
	ai_face();
	
	if(self.frame > 25 && self.frame < 40)
	{
		if(!visible(self.enemy))
		{
			sound(self.enemy, CHAN_VOICE, "misc/null.wav", 1, SoundRadius(200));
			self.think = controller_run;
		}
	}
	if(self.frame == 40)
	{
		sound(self.enemy, CHAN_VOICE, "monsters/controller/controller_whoosh.wav", 1, SoundRadius(200));
		self.enemy.stopViewmodel = 1;
		self.enemy.reload = 1;
		self.enemy.attack_finished = time + 1;
		self.enemy.punchangle = '0 0 0';
		self.enemy.movetype = MOVETYPE_NONE;
		stuffcmd(self.enemy, "cl_hud 0;r_trippy 1\n");
	}
	if(self.frame > 40 && self.frame < 77)
	{
		
		self.enemy.reload = 1;
		self.enemy.velocity_x = 0;
		self.enemy.velocity_z = 0;
		self.enemy.viewzoom = lerp(self.enemy.viewzoom, 0.08, 0.15);

		vector dir = normalize((self.enemy.origin + self.enemy.view_ofs) - (self.origin + '0 0 40'));
		vector ang = vectoangles(dir) + '0 180 0';
		if(self.enemy && self.enemy.classname == "player")
		{
			msg_entity = self.enemy; 
			WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
			WriteAngle(MSG_ONE, ang_x);
			WriteAngle(MSG_ONE, ang_y);
			WriteAngle(MSG_ONE, ang_z);
		}
	}
	if(self.frame == 77) 
	{
		sound(self.enemy, CHAN_AUTO, "monsters/controller/controller_final_hit.wav", 1, SoundRadius(200));
		self.enemy.movetype = MOVETYPE_WALK;
		self.enemy.stopViewmodel = 0;
		self.enemy.reload = 0;
		stuffcmd(self.enemy, "cl_hud 1;r_trippy 0\n");
		self.enemy.punchangle = [ random(-15,15), random(-15,15), random(8,15) ];
		T_Damage (self.enemy, self, self, CONTROLLER_KICK_DAMAGE);
	}



	if(self.frame > 130) self.think = controller_run;

};

void() controller_range_attack =
{
	sound(self.enemy, CHAN_VOICE, "monsters/controller/controller_tube_prepare.wav", 1, SoundRadius(200));
	setmodel (self, "models/monsters/controller_attack_ranged.md3");
	setsize (self, CONTROLLER_SIZE1, CONTROLLER_SIZE2);
	
	self.frame = 0;
	self.think = controller_range_attack_loop;
	self.nextthink = time + CONTROLLER_ANIM_SPEED;
};

//Check attack

float()	controller_check_attack =
{
	if(!visible(self.enemy)) return FALSE;
	float dist = vlen(self.enemy.origin - self.origin);	
	if (dist < 110)
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (dist > 110 && dist < (CONTROLLER_KICK_RADIUS * 0.85) && self.lastTouch < time)
	{
		self.lastTouch = time + CONTROLLER_KICK_COOLDOWN;
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
};



//INIT

void() controller_precache =
{
	precache_model2("models/monsters/controller_idle.md3");
	precache_model2("models/monsters/controller_attack_ranged.md3");
	precache_model2("models/monsters/controller_attack1.md3");
	precache_model2("models/monsters/controller_walk.md3");
	
	precache_sound2("monsters/controller/controller_whoosh.wav");
	precache_sound2("monsters/controller/controller_tube_prepare.wav");
	precache_sound2("monsters/controller/controller_final_hit.wav");
		
	precache_sound2("monsters/controller/controller_attack_hit_0.wav");
	precache_sound2("misc/null.wav");
	precache_sound2("monsters/giant/giant_breath_0.wav");
	precache_sound2("monsters/giant/giant_breath_1.wav");
	precache_sound2("monsters/giant/giant_breath_2.wav");
};

void() monster_controller =
{
	controller_precache();
	
	self.classname = "monster_controller";
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.yaw_speed = 9;
	self.scale = 0.36;

	setmodel (self, "models/monsters/controller_idle.md3");
	setsize (self, CONTROLLER_SIZE1, CONTROLLER_SIZE2);
	self.health = CONTROLLER_HEALTH;
	self.th_stand = controller_stand;
	self.th_walk = controller_walk;
	self.th_run = controller_run;
	self.th_melee = controller_attack;
	self.th_missile = controller_range_attack;	
	self.th_pain = controller_pain;
	self.th_die = controller_die;
	self.checkAttack = controller_check_attack;
	self.signtSound = controller_sight;
	
	walkmonster_start();
};


