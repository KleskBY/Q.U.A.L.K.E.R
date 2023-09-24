float GRUNT_HEALTH = 75;
vector GRUNT_SIZE1 = '-10 -10 0';
vector GRUNT_SIZE2 = '10 10 51';
vector GRUNT_CROUCH_SIZE = '0 0 16';
float GRUNT_ANIM_SPEED = 0.1;
float GRUNT_FIRE_RATE = 0.1;


void (float dist) ai_strafeleft =
{
	walkmove(self.angles_y + 90, dist);
};

void (float dist) ai_straferight =
{
	walkmove(self.angles_y + 270, dist);
};

void (float dist) ai_moveforeward =
{
	walkmove(self.angles_y, dist);
};

// stand walk run crouch standup reload grenade stand_attack crouch_attack melee_attack roll_left roll_right

////////////////////////// IDLE ////////////////////////////

void() grunt_stand =
{
	setmodel(self, "models/npc/grunt_stand.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 21) self.frame = 0;
	
	self.think = grunt_stand;
	self.nextthink = time + GRUNT_ANIM_SPEED;
	ai_stand();	
};

////////////////////////// WALK ////////////////////////////

void() grunt_walk =
{	
    setmodel(self, "models/npc/grunt_walk.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	
	self.frame = self.frame + 1;
	if(self.frame > 29) self.frame = 0;
	
	self.think = grunt_walk;
	self.nextthink = time + GRUNT_ANIM_SPEED;
	ai_walk(4);
};

////////////////////////// RUN ////////////////////////////

void() grunt_run =
{	
	footsteps();
    setmodel(self, "models/npc/grunt_run.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);

	self.frame = self.frame + 1;
	if(self.frame > 8) self.frame = 0;
	
	self.duck = 0;
	self.think = grunt_run;
	self.nextthink = time + GRUNT_ANIM_SPEED;
	ai_run(16);
};

////////////////////////// MELEE //////////////////////////

void() grunt_melee_loop =
{	
	self.frame = self.frame + 1;
	
	if(self.frame > 9)
	{
		self.think = grunt_run;
		self.nextthink = time + GRUNT_ANIM_SPEED;
	}
	else
	{
		if(self.frame == 3)
		{
			ai_charge(18);
			ai_melee();
			ai_melee();
			ai_melee();
		}
		self.nextthink = time + GRUNT_ANIM_SPEED;
	}
};

void() grunt_melee =
{
    setmodel(self, "models/npc/grunt_melee.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	self.frame = 0;
	
	ai_charge(12);
	
	self.think = grunt_melee_loop;
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

////////////////////////// GRENADE //////////////////////////

void() grunt_fire_grenade =
{
	local	entity missile;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
		
	makevectors (self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 400;
	missile.velocity_z = 400;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = GRENADE_Touch;
	
	missile.nextthink = time + 2.5;// set missile duration
	missile.think = MyGrenadeExplode;

	setmodel (missile, GRENADE_WORLD_MODEL);
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);
	self.ammoGrenades = self.ammoGrenades - 1;
};


void() grunt_grenade_loop =
{
	self.frame = self.frame + 1;
	if(self.frame > 29) self.think = grunt_run;
	else ai_face();
	if(self.frame == 18) grunt_fire_grenade();//GRENADE_Fire();//grunt_fire_grenade();
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

void() grunt_grenade =
{
	setmodel(self, "models/npc/grunt_grenade.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	
	self.frame = 0;
	self.think = grunt_grenade_loop;
	self.nextthink = time + GRUNT_ANIM_SPEED;
	
	local float rsnd = random_int(1, 7);
	local string fileName = "npc/grenade_ready_";
	fileName = strcat(fileName, ftos(rsnd));
	fileName = strcat(fileName, ".wav");
	sound (self, CHAN_VOICE, fileName, 1, SoundRadius(450));
};

//////////////////////////// ROLL RIGHT /////////////////////////////////

void() grunt_roll_right_loop =
{
	self.frame = self.frame + 1;
	if(self.frame > 13) self.think = grunt_run;
	else 
	{
		if(self.frame > 9) ai_face();
		else ai_straferight(14);
	}
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

void() grunt_roll_right =
{
	setmodel(self, "models/npc/grunt_roll_right.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2 - GRUNT_CROUCH_SIZE);
	
	self.frame = 0;
	self.think = grunt_roll_right_loop;
	self.nextthink = time + GRUNT_ANIM_SPEED;
	self.duck = 1;
	ai_face();
	// setsize (self, GRUNT_SIZE1, GRUNT_SIZE2 - GRUNT_CROUCH_SIZE);
};

//////////////////////////// ROLL RIGHT /////////////////////////////////

void() grunt_roll_left_loop =
{
	self.frame = self.frame + 1;
	if(self.frame > 13) self.think = grunt_run;
	else  
	{
		if(self.frame > 9) ai_face();
		else ai_strafeleft(14);
	}
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

void() grunt_roll_left =
{
	setmodel(self, "models/npc/grunt_roll_left.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2 - GRUNT_CROUCH_SIZE);
	
	self.frame = 0;
	self.think = grunt_roll_left_loop;
	self.nextthink = time + GRUNT_ANIM_SPEED;
	self.duck = 1;
	ai_face();
	// setsize (self, GRUNT_SIZE1, GRUNT_SIZE2 - GRUNT_CROUCH_SIZE);
};

void() grunt_random_roll = 
{
	if(random() > 0.5)
	{
		local float canRollRight = FALSE;
		traceline(self.origin, self.origin + v_right * 75, FALSE, self);
		if(trace_fraction == 1.0) canRollRight = TRUE;
		
		local float canRollLeft = FALSE;
		traceline(self.origin, self.origin - v_right * 75, FALSE, self);
		if(trace_fraction == 1.0) canRollLeft = TRUE;
		
		if(canRollLeft && canRollRight)
		{
			if(random() >= 0.5) self.think = grunt_roll_left;
			else self.think = grunt_roll_right;
		}
		else if(canRollLeft) self.think = grunt_roll_left;
		else if(canRollRight) self.think = grunt_roll_left;
	}
};


////////////////////////// RELOAD //////////////////////////

void() grunt_reload_loop =
{
	self.duck = 1;
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2 - GRUNT_CROUCH_SIZE);
	
	self.frame = self.frame + 1;
	if(self.frame == 10) sound(self, CHAN_WEAPON, AK74_CLIPOUT_SOUND, 1, SoundRadius(600));
	if(self.frame == 22) sound(self, CHAN_WEAPON, AK74_CLIPIN_SOUND, 1, SoundRadius(600));
	if(self.frame == 29) sound(self, CHAN_WEAPON, AK74_SLIDE1_SOUND, 1, SoundRadius(600));
	if(self.frame == 34) grunt_random_roll();
	if(self.frame > 39) self.think = grunt_run;
	else 
	{
		if(self.weapon == WP_SHOT) self.currentammo = 5;
		else self.currentammo = 30;
		
	}
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

void() grunt_reload =
{
	setmodel(self, "models/npc/grunt_reload.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	if(self.duck) self.frame = 4;
	else self.frame = 0;
	self.think = grunt_reload_loop;
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

////////////////////////// FIRE //////////////////////////

void(float shotcount, vector dir, vector spread) FireShotgun =
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle);


	src = (self.origin + (v_forward * TE_LAVASPLASH));
	src_z = (self.absmin_z + (self.size_z * 0.800)); //0.800
	if(self.duck) src_z = (self.absmin_z + self.size_z);
	src_y = (self.absmin_y + (self.size_y * 0.5)); //0.400
    ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		traceline (src, src + direction * 2048 + (v_up * 50), FALSE, self);
		//particle(src + (v_forward * 100),src + direction * 2048,192,random() * 10);
		if (trace_fraction != 1.0) TraceAttack (8, direction);
		shotcount = shotcount - 1;
	}
    ApplyMultiDamage ();
};


void() grunt_fire =
{
	if(self.currentammo && self.lastTouch < time)
	{
		ai_face();

		local vector dir = (self.enemy.origin + '0 0 -8') - self.enemy.velocity * 0.2; // fire somewhat behind the player, so a dodging player is harder to hit
		dir = normalize (dir - self.origin);
		
		makevectors(self.v_angle);
		if(self.duck) pointparticles(particleeffectnum("shotgun_muzzleflash"), self.origin + '0 0 27', self.velocity * 50, 1);
		else pointparticles(particleeffectnum("shotgun_muzzleflash"), self.origin + '0 0 38', self.velocity * 50, 1);
		self.effects = self.effects | EF_MUZZLEFLASH;
		
		if(self.weapon == WP_SHOT) sound(self, CHAN_WEAPON, MOSS_FIRE_SOUND, 1, SoundRadius(1500));
		else sound(self, CHAN_WEAPON, AK74_FIRE_SOUND, 1, SoundRadius(2000));
		
		if(self.weapon == WP_SHOT) FireShotgun(8, dir, '0.08 0.06 0.0');
		else 
		{
			local vector src = self.origin + v_forward * 10;
			src_z = self.absmin_z + self.size_z * 0.7;        
			traceline (src, src + dir * 1024, FALSE, self);
			if (trace_fraction != 1.0)
			{
				if (trace_ent.takedamage)
				{
					T_Damage (trace_ent, self, self, 7);
					ImpactSound(trace_endpos);
				}
				else
				{
					WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
					WriteByte(MSG_BROADCAST, TE_GUNSHOT);
					WriteCoord(MSG_BROADCAST, trace_endpos_x);
					WriteCoord(MSG_BROADCAST, trace_endpos_y);
					WriteCoord(MSG_BROADCAST, trace_endpos_z);
					HitSound(trace_endpos);
				}    
			}
		}
		
		self.currentammo = self.currentammo - 1;
		if(self.weapon == WP_SHOT) self.lastTouch = time + 0.5;
		else if(!self.duck || self.classname == "monster_light") self.lastTouch = time + GRUNT_FIRE_RATE;
	}

};


////////////////////////// STAND SHOOT //////////////////////////
void() grunt_shoot_stand;
void() grunt_shoot_stand_loop =
{
	self.weaponframe = self.weaponframe + 1;
	if(self.weaponframe > 7) 
	{
		if(self.currentammo)
		{
			ai_face();
			self.think = grunt_run;
			SUB_CheckRefire(grunt_shoot_stand);
		}
		else
		{
			self.think = grunt_reload;
		}
	}
	else
	{
		ai_face();
		grunt_fire();
	}
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

void() grunt_shoot_stand =
{
	setmodel(self, "models/npc/grunt_strafe_left.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	
	self.frame = 0;
	self.think = grunt_shoot_stand_loop;
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

////////////////////////// CROUCH SHOOT //////////////////////////

void() grunt_shoot_crouch;
void() grunt_shoot_crouch_loop =
{
	self.duck = 1;
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2 - GRUNT_CROUCH_SIZE);
	
	self.frame = self.frame + 1;
	if(self.frame > 15) 
	{
		ai_face();
		self.think = grunt_run;
		SUB_CheckRefire(grunt_shoot_crouch);
	}
	else if(self.frame < 12)
	{
		ai_face();
		grunt_fire();
	}
	else if(self.frame == 12)
	{
		if(self.currentammo) grunt_random_roll();
		else self.think = grunt_reload;
	}
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

void() grunt_shoot_crouch =
{
	setmodel(self, "models/npc/grunt_crouch_shoot.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	if(self.duck) self.frame = 4;
	else self.frame = 0;
	self.think = grunt_shoot_crouch_loop;
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

//////////////////////////// STRAFE LEFT /////////////////////////////////

void() grunt_strafe_left_loop =
{
	self.frame = self.frame + 1;
	if(self.frame > 13) 
	{
		if(self.currentammo) self.think = grunt_run;
		else self.think = grunt_reload;
	}
	else 
	{
		ai_face();
		grunt_fire();
		ai_strafeleft(4);
	}
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

void() grunt_strafe_left =
{
	setmodel(self, "models/npc/grunt_strafe_left.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	
	self.frame = 0;
	self.think = grunt_strafe_left_loop;
	self.nextthink = time + GRUNT_ANIM_SPEED;
	self.duck = 0;
};


//////////////////////////// STRAFE RIGHT /////////////////////////////////

void() grunt_strafe_right_loop =
{
	self.frame = self.frame + 1;
	if(self.frame > 13) 
	{
		if(self.currentammo) self.think = grunt_run;
		else self.think = grunt_reload;
	}
	else 
	{
		ai_face();
		grunt_fire();
		ai_straferight(4);
	}
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

void() grunt_strafe_right =
{
	setmodel(self, "models/npc/grunt_strafe_right.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	
	self.frame = 0;
	self.think = grunt_strafe_right_loop;
	self.nextthink = time + GRUNT_ANIM_SPEED;
	self.duck = 0;
};

////////////////////////// ATTACK //////////////////////////

void() grunt_missile = 
{
	ai_face();
	
	local float visible = FALSE;
	traceline(self.origin, self.enemy.origin, 0, self);
	if(trace_ent == self.enemy) visible = TRUE;
	// if(visible)
	{
		if (self.currentammo <= 0 || (!visible && self.currentammo <= 5))
		{
			self.think = grunt_reload; 
		}
		else
		{
			if (self.absmax_z - self.enemy.absmax_z > -50 && vlen(self.enemy.origin - self.origin) > 400 && random() < 0.45 && self.ammoGrenades > 0) // Check to see if grenades are throwable
			{
				self.think = grunt_grenade;
			}
			else
			{
				if(random() < 0.1) //ROLL
				{
					if(random() >= 0.5) grunt_roll_left();
					else grunt_roll_right();
				}
				else //SHOOT
				{
					local float temp = random();
					if(temp < 0.3) self.think = grunt_shoot_stand;
					else if(temp >= 0.3 && temp < 0.6) self.think = grunt_shoot_crouch;
					else 
					{
						if(random() >= 0.5) self.think = grunt_strafe_left;
						else self.think = grunt_strafe_right;
					}
				}
			}
		}
	}
	self.nextthink = time + GRUNT_ANIM_SPEED;
};

////////////////////////// PAIN //////////////////////////

void(entity attacker, float damage)	grunt_pain =
{
	local float rsnd = random_int(1, 5);
	local string fileName = "npc/pain";
	fileName = strcat(fileName, ftos(rsnd));
	fileName = strcat(fileName, ".wav");
	sound (self, CHAN_VOICE, fileName, 1, SoundRadius(450));
}

////////////////////////// DROP ITEMS ////////////////////////////

void(.float ammoType, float amount, string mdl, string name) DropAmmo =
{
	local entity item;
	item = spawn();
	item.origin = self.origin;// - '0 0 24';
	droptofloor();
	
	item.aflag = amount;
	item.ammoType = amount;
	item.weapon = self.weapon;
	item.netname = name;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, mdl);
	setsize (item, '-4 -4 0', '4 4 8');
	item.touch = ammo_touch;
	
	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;
};

////////////////////////// DEATH //////////////////////////


void() grunt_die1 =
{
	if(self.solid != SOLID_CORPSE)
	{
		setmodel(self, "models/npc/grunt_death1.md3");
		setsize (self, GRUNT_SIZE1, GRUNT_SIZE2 - '0 0 40');
		self.frame = 0;
	}
	else if(self.frame < 25) self.frame = self.frame + 1;
	self.solid = SOLID_CORPSE;
	self.think = grunt_die1;
	self.nextthink = time + GRUNT_ANIM_SPEED / 3;
};

void() grunt_die2 =
{
	if(self.solid != SOLID_CORPSE)
	{
		setmodel(self, "models/npc/grunt_death2.md3");
		setsize (self, GRUNT_SIZE1, GRUNT_SIZE2 - '0 0 40');
		self.frame = 0;
	}
	else if(self.frame < 29) self.frame = self.frame + 1;
	setsize(self, GRUNT_SIZE1, GRUNT_SIZE2 - '0 0 40');
	self.solid = SOLID_CORPSE;
	self.think = grunt_die2;
	self.nextthink = time + GRUNT_ANIM_SPEED / 3;
};

void() grunt_die3 =
{
	if(self.solid != SOLID_CORPSE)
	{
		setmodel(self, "models/npc/grunt_death3.md3");
		setsize (self, GRUNT_SIZE1, GRUNT_SIZE2 - '0 0 40');
		self.frame = 0;
	}
	else if(self.frame < 59) self.frame = self.frame + 1;
	self.solid = SOLID_CORPSE;
	self.think = grunt_die3;
	self.nextthink = time + GRUNT_ANIM_SPEED / 3;
};


void() grunt_headless =
{
	if(self.frame < 25)
	{
		self.frame = self.frame + 1;
		self.nextthink = time + GRUNT_ANIM_SPEED / 3;
	}
	else 
	{
		particle (self.origin, '0 0 3', 72,38);
		particle (self.origin, '0 3 3', 72,38);
		particle (self.origin, '0 -3 3', 72,38);
		particle (self.origin, '3 0 3', 72,38);
		particle (self.origin, '-3 0 3', 72,38);
		self.nextthink = -1;
	}
};

void() grunt_headshot =
{
	newmis = spawn();
	setmodel (newmis, "models/npc/grunt_headless.md3");
	newmis.modelflags = MF_ZOMGIB;
	newmis.origin = self.origin;
	newmis.angles = self.angles;
	newmis.scale = self.scale;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.takedamage = DAMAGE_NO;
	newmis.solid = SOLID_CORPSE;
	setsize (newmis, '-14 -14 0', '14 14 8');
	newmis.flags = newmis.flags - (newmis.flags & FL_ONGROUND);
	newmis.velocity = self.velocity * 0.25;
	newmis.think = grunt_headless;
	newmis.nextthink = time + GRUNT_ANIM_SPEED;
	
	ThrowHead("models/npc/grunt_head.md3", self.health);
};

void() grunt_die =
{
	if(self.weapon == WP_RIFLE) DropAmmo(ammo545x39, rint(random() * 10) + 1, self.gun.model, "AK-74");
	if(self.weapon == WP_SHOT) DropAmmo(ammoShells, rint(random() * 10) + 1, self.gun.model, "Shotgun");
	if(self.gun) remove(self.gun);
	if (self.health < -40)
	{
		Gib();
		return;
	}
	
	local float rsnd = random_int(1, 11);
	if(rsnd < 10)
	{
		local string fileName = "npc/death0";
		fileName = strcat(fileName, ftos(rsnd));
		fileName = strcat(fileName, ".wav");
		sound (self, CHAN_VOICE, fileName, 1, SoundRadius(450));
	}
	
	if (self.health < -11 && random() > 0.4)
	{
		if (self.hitbox == HITBOX_HEAD)
		{
			grunt_headshot();
			return;
		}
	}
	
	rsnd = rint(random() * 3);
	switch (rsnd)
	{
		case 1:
			grunt_die1();
			break;
		case 2:
			grunt_die2();
			break;
		case 3:
			grunt_die3();
			break;
		default:
			grunt_die1();
			break;
	}
	
};

////////////////////////// SIGHT //////////////////////////

void() grunt_sight =
{
	local float rsnd = random_int(1, 11);
	if(rsnd < 10)
	{
		local string fileName = "npc/sight0";
		fileName = strcat(fileName, ftos(rsnd));
		fileName = strcat(fileName, ".wav");
		sound (self, CHAN_VOICE, fileName, 1, SoundRadius(450));
	}
}


////////////////////////// INIT //////////////////////////


void() grunt_precache = 
{
	precache_model2("models/npc/grunt_stand.md3");
	precache_model2("models/npc/grunt_walk.md3");
	precache_model2("models/npc/grunt_run.md3");
	precache_model2("models/npc/grunt_melee.md3");
	precache_model2("models/npc/grunt_grenade.md3");
	precache_model2("models/npc/grunt_roll_right.md3");
	precache_model2("models/npc/grunt_roll_left.md3");
	precache_model2("models/npc/grunt_reload.md3");
	precache_model2("models/npc/grunt_shoot_stand.md3");
	precache_model2("models/npc/grunt_crouch_shoot.md3");
	precache_model2("models/npc/grunt_strafe_left.md3");
	precache_model2("models/npc/grunt_strafe_right.md3");
	precache_model2("models/npc/grunt_death1.md3");
	precache_model2("models/npc/grunt_death2.md3");
	precache_model2("models/npc/grunt_death3.md3");
	precache_model2("models/npc/grunt_headless.md3");
	precache_model2("models/npc/grunt_head.md3");
	
	precache_sound2("npc/pain1.wav");
	precache_sound2("npc/pain2.wav");
	precache_sound2("npc/pain3.wav");
	precache_sound2("npc/pain4.wav");
	precache_sound2("npc/pain5.wav");
	precache_sound2("npc/pain6.wav");
	
	precache_sound2("npc/grenade_ready_1.wav");
	precache_sound2("npc/grenade_ready_2.wav");
	precache_sound2("npc/grenade_ready_3.wav");
	precache_sound2("npc/grenade_ready_4.wav");
	precache_sound2("npc/grenade_ready_5.wav");
	precache_sound2("npc/grenade_ready_6.wav");
	precache_sound2("npc/grenade_ready_7.wav");
	
	precache_sound2("npc/death01.wav");
	precache_sound2("npc/death02.wav");
	precache_sound2("npc/death03.wav");
	precache_sound2("npc/death04.wav");
	precache_sound2("npc/death05.wav");
	precache_sound2("npc/death06.wav");
	precache_sound2("npc/death07.wav");
	precache_sound2("npc/death08.wav");
	precache_sound2("npc/death09.wav");
	precache_sound2("npc/death10.wav");
	
	
	precache_sound2("npc/sight01.wav");
	precache_sound2("npc/sight02.wav");
	precache_sound2("npc/sight03.wav");
	precache_sound2("npc/sight04.wav");
	precache_sound2("npc/sight05.wav");
	precache_sound2("npc/sight06.wav");
	precache_sound2("npc/sight07.wav");
	precache_sound2("npc/sight08.wav");
	precache_sound2("npc/sight09.wav");
	precache_sound2("npc/sight10.wav");
};

void() monster_grunt =
{	
	grunt_precache();

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
    setmodel(self, "models/npc/grunt_stand.md3");
	setsize (self, GRUNT_SIZE1, GRUNT_SIZE2);
	self.health = GRUNT_HEALTH;
	self.yaw_speed = 12;
	self.scale = 0.75;
	
	self.th_stand = grunt_stand;
	self.th_walk = grunt_walk;
	self.th_run = grunt_run;
	self.th_missile = grunt_missile;
    self.th_melee = grunt_melee;
	self.th_pain = grunt_pain;
	self.th_die = grunt_die;
	self.checkAttack = CheckAttack;
	self.signtSound = grunt_sight;

	if(!self.weapon) self.weapon = WP_RIFLE;
	if(self.weapon == WP_RIFLE)
	{
		if(!self.gun) self.gun = spawn();
		setmodel(self.gun, "models/weapons/w_ak74.md3");
		self.gun.origin = '-11.8 0 1.2';
		self.gun.scale = 0.75;
		self.gun.angles = '-10 0 0';
		// self.gun.angles = '180 90 168';
		setattachment(self.gun, self, "tag_weapon");
		self.currentammo = 30;
	}
	else if(self.weapon == WP_SHOT)
	{
		if(!self.gun) self.gun = spawn();
		setmodel(self.gun, "models/weapons/w_moss.md3");
		self.gun.origin = '-15.8 2 1.2';
		self.gun.scale = 0.7;
		self.gun.angles = '-10 0 0';
		setattachment(self.gun, self, "tag_weapon");
		self.currentammo = 6;
	}
	self.ammoGrenades = 3;
	walkmonster_start();
};

void() monster_light =
{
	if(self.origin_x == -1888 && self.origin_y == -528) return;
	self.weapon = WP_RIFLE;
	monster_grunt();
};
void() monster_heavy =
{
	self.weapon = WP_RIFLE;
	monster_grunt();
	self.health = 100;
};
void() monster_shotguner =
{
	self.weapon = WP_SHOT;
	monster_grunt();
};