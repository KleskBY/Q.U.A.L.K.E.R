void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void() PlayerThink;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, vector vel, float damage) SpawnBlood;
void BreakableHit(vector org, vector dir);

//============================================================================


vector() wall_velocity =
{
	local vector vel;
	vel = normalize(self.velocity);
	vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
	vel = vel + 2 * trace_plane_normal;
	vel = vel * 200;
	return vel;
};



/*
	================
	spawn_touchblood
	================
*/
void(float damage) spawn_touchblood =
{
	vector vel = wall_velocity() * 0.2;
	SpawnBlood(self.origin + vel * 0.01, vel, damage);
};


/*
	================
	SpawnChunk
	================
*/
void(vector org, vector vel) SpawnChunk =
{
	particle(org, vel * 0.02, 0, 10);
};

/*
	==============================================================================
	
	MULTI-DAMAGE
	
	Collects multiple small damages into a single damage
	
	==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent) return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit) return;
	if (hit != multi_ent)
	{
		ApplyMultiDamage();
		multi_damage = damage;
		multi_ent = hit;
	}
	else multi_damage = multi_damage + damage;
};

/*
	==============================================================================
	
	BULLETS
	
	==============================================================================
*/

/*
	================
	TraceAttack
	================
*/



float (float damage) DetectHitbox =
{
	if (trace_ent.absmax_z - trace_endpos_z <= 13 && !trace_ent.crouching) //headshot
	{
		damage = rint(damage * 1.7);
		trace_ent.hitbox = HITBOX_HEAD;
	}
	else if(trace_ent.crouching && trace_ent.absmax_z - trace_endpos_z <= 6)
	{
		damage = rint(damage * 1.7);
		trace_ent.hitbox = HITBOX_HEAD;
	}
	else if (trace_ent.absmax_z - trace_endpos_z > 30)	//legshot
	{
		trace_ent.hitbox = HITBOX_LEGS;
		damage = rint(damage * 0.7);
	}
	else trace_ent.hitbox = HITBOX_BODY;
	return damage;
}



float (float damage, vector org, vector dir) DetectObject =
{
	if(trace_ent.classname == "button")
	{
		AddMultiDamage(trace_ent, damage);
		return TRUE;
	}
	else if(trace_ent.classname == "breakable")
	{
		BreakableHit(org, dir);
		AddMultiDamage (trace_ent, damage);
		return TRUE;
	}
	return FALSE;
}

void (float damage, vector dir) TraceAttack = 
{
	local vector vel, org, meatdir;
	local float particle_color;

	vel = normalize (dir + v_up * random(-1, 1) + v_right * random(-1, 1));
	vel = vel + trace_plane_normal * 2;
	vel = vel * 200;
	org = trace_endpos - dir * 4;
	
	if(self.weapon == WP_KNIFE)
	{
		if (!trace_ent.takedamage || trace_ent.classname == "worldspawn")
		{
			sound(self, CHAN_WEAPON,"weapons/knife/miss.wav", 1, ATTN_IDLE);
			te_spark(org, randomvec() * 40, 4); 
			return;
		}
	}
	
	if(trace_ent.takedamage) 
	{
		if(DetectObject(damage, org, dir)) return;
		damage = DetectHitbox(damage);
		
		if(self.weapon == WP_KNIFE)
		{
			trace_ent.axhitme = 1;
			sound(self, CHAN_WEAPON, "weapons/knife/hit.wav", 1, ATTN_NORM);
		}
		
		//spawn blood if thing is allive
		if(trace_ent.flags & FL_MONSTER || trace_ent.flags & FL_CLIENT) 
		{
			particle_color = random();
			meatdir_x = random() * 300;
			meatdir_y = random() * 300;
			meatdir_z = random() * 300;
			makevectors(self.v_angle);
			
			if(particle_color < 0.7 && damage >= 6) 
			{
				SpawnBlood(org, vel * 0.2, damage * 100); 
			}
			if(damage >= 20)
			{
				SpawnBlood(org + '10 10 0', v_forward * 200, 10); 
				SpawnBlood(org, v_forward * 200, 10); 
			}
		}
		
		// if(damage <= 20 && damage > 0)
		// {
			// if (trace_ent.health <= damage && trace_ent.movetype != MOVETYPE_PUSH && trace_ent.duck != 1 && trace_ent.classname != "misc_explobox") 
			// {
				// trace_ent.flags = trace_ent.flags - FL_ONGROUND;
				// trace_ent.velocity = v_forward * 100;
				// trace_ent.velocity_z = 100 + random() * 100;
			// }
		// }
		// if(damage > 20)
		// {
			// if(trace_ent.health <= damage && trace_ent.movetype != MOVETYPE_PUSH && trace_ent.duck != 1) 
			// {
				// trace_ent.flags = trace_ent.flags - FL_ONGROUND;
				// trace_ent.velocity = v_forward * 150;
				// trace_ent.velocity_z = 100 + random() * 100;
			// }
		// }
		
		AddMultiDamage(trace_ent, damage);
		ImpactSoundSurface(trace_endpos);
	}
	else if(trace_ent.solid == SOLID_CORPSE)
	{
		SpawnBlood(org, vel * 0.2, damage * 100);
		trace_ent.health = trace_ent.health - damage;
		if(trace_ent.health < -260)
		{
			local entity oldself = self;
			self = trace_ent;
			Gib();
			self = oldself;
		}
		ImpactSoundBody(trace_endpos);
	}
	else 
	{
		ImpactSoundBody(org);
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST,org_x);
		WriteCoord (MSG_BROADCAST,org_y);
		WriteCoord (MSG_BROADCAST,org_z);
	}
	
};

/*
	================
	FireBullet
	================
*/

void(vector spread, float dist, float dmg) fireBullet =
{
	local vector src, dir;
	local float len;
	
	self.total_shots = self.total_shots + 1;
	makevectors(self.angles);
	dir = aim(self, 1000);
	
	makevectors(self.v_angle + self.punchangle);	
	src = self.origin + v_forward * 10 + self.view_ofs;

	ClearMultiDamage();
	
	local float oldSolid = self.solid; //Corpse hit fix
	self.solid = SOLID_BBOX;
	traceline(src, (src + v_forward * dist) - (v_right * random(-1, 1) * spread_x) - (v_up * random(-1, 1) * spread_y), MOVE_HITMODEL, self);
	self.solid = oldSolid;
	// traceline (src, (src + v_forward * dist) - (v_right * random(-1, 1) * spread_x) - (v_up * random(-1, 1) * spread_y), FALSE, self);
	
	if (trace_fraction != 1.0)
	{
		if(trace_ent.takedamage) self.total_hits = self.total_hits + 1;
		len = vlen(trace_endpos - self.origin);
		if (len < 250) TraceAttack(dmg, dir);
		else if (len < 350 && len >= 250) TraceAttack(dmg * 0.9, dir);
		else TraceAttack(dmg * 0.8, dir);
	}
	ApplyMultiDamage();
};



/*
	============
	Weapon funcs
	============
*/

void(vector org, float scl) MuzzleFlash =
{
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.alpha = 0.7;
	newmis.effects = EF_FULLBRIGHT;
	if(random() >= 0.5) setmodel(newmis, "models/muzzle2.md3");
	else setmodel(newmis, "models/muzzle.md3");
	newmis.scale = scl;
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, org);
	newmis.angles_z = random(0, 359);
	newmis.nextthink = time + 0.025;
	newmis.think = SUB_Remove;
}

vector Spread(vector spread) =
{
	if (self.ShootsFired == 1) spread = spread * 1.5;
	else if (self.ShootsFired == 2) spread = spread * 2;
	else if (self.ShootsFired == 3) spread = spread * 3;
	else if (self.ShootsFired == 4) spread = spread * 3.5;
	else spread = spread * 5;
	if(IsSniper(self.weapon) && self.state != STATE_AIM) spread = spread * 5;
	if(self.crouching) spread = spread * 0.75;
	return spread;
};


void(string mdl) SetGun =
{
	if(!self.model) return;
	if(self.crouching) setsize(self, DUCK_SIZE_MIN, DUCK_SIZE_MAX);
	else setsize (self, STAND_SIZE_MIN, STAND_SIZE_MAX);
	
	if(!self.gun) self.gun = spawn();
	setmodel(self.gun, mdl);
	self.gun.model = mdl;
	// self.gun.scale = 0.8;
	self.gun.angles = '10 0 0';
	setattachment(self.gun, self, "tag_weapon");
};

void() SelectNone =
{
	self.currentClip = 0;
	self.currentammo = 0;
	self.weaponframe = 0;
	self.weaponmodel = "";
	self.weaponSwitch = SUB_Null;
	self.weaponAttack = SUB_Null;
	self.weaponReload = SUB_Null;
	self.weaponSelect = SUB_Null;
	SetGun("");
}

void(.float ammoType, .float clip, float clipSize) FinishReload =
{
	self.weaponframe = 0;
	if(self.ammoType >= clipSize)
	{
		self.ammoType = self.ammoType - (clipSize - self.clip);
		if(self.clip > 0) self.clip = clipSize + 1;
		else self.clip = clipSize;
		self.currentClip = self.clip;
	}
	else
	{
		self.clip = self.ammoType;
		self.currentClip = self.clip;
		self.ammoType = 0;
	}
	W_SetCurrentAmmo();
	self.think = PlayerThink;
};



/*
	===============================================================================
	PLAYER WEAPON USE 
	FX Weapon ammo
	===============================================================================
*/



void SetSlotIcon()
{
	for(float i = 1; i < SLOT_AMOUNT - 1; i++)
	{
		stuffcmd(self, strcat("slot", ftos(i), " ", ftos(self.slot[i]), "\n"));
	}
}


void SelectCurrentWeapon();
void() W_SetCurrentAmmo =
{
	SetSlotIcon();
	SelectCurrentWeapon();
	PlayerThink();		// get out of any weapon firing states
	if(self.weaponSelect) self.weaponSelect();
};



/*
	============
	W_Attack
	
	An attack impulse can be triggered now
	============
*/

void() W_Attack =
{
	if (self.reload) return;
	if (self.running) return;
	if (self.state == STATE_RUN) return;
    self.weaponfired = self.weapon;
	makevectors	(self.v_angle);		// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up
	if(self.weaponAttack) self.weaponAttack();
};



/*
	============
	W_ChangeWeapon
	============
*/



void() W_ChangeWeapon =
{
	local float slotID = self.impulse;
	
	self.impulse = 0;
	
	if(slotID < 1 || slotID > 6) return;
	if(self.weapon == self.slot[slotID]) return;
	if(self.slot[slotID] == WP_GRENADE && !self.ammoGrenades) return;
	if(self.slot[slotID]) self.weapon = self.slot[slotID];
	else { sprint (self, "No weapon\n"); return; }

	W_SetCurrentAmmo();
	sound(self, CHAN_AUTO, "player/switch.wav", random(0.3, 0.8), SoundRadius(400));
	if(self.weaponSwitch) self.weaponSwitch();
}


float GetCurrentSlot()
{
	for(float i = 0; i < SLOT_AMOUNT; i++)
	{
		if(self.slot[i] == self.weapon) return i;
	}
	return -1;
}


/*
	============
	CycleWeaponCommand
	Go to the next weapon with ammo
	============
*/


void() CycleWeaponCommand =
{
	self.impulse = 0;
	if(self.weapon <= 0) return;
	
	float currentSlot = GetCurrentSlot();
	for(float i = 1; i < SLOT_AMOUNT - 1; i++)
	{
		float needSlot = currentSlot + i;
		if(needSlot > SLOT_AMOUNT - 1) needSlot = needSlot - SLOT_AMOUNT + 1;
		if(self.slot[needSlot]) 
		{
			self.impulse = needSlot;
			break;
		}
	}
};



/*
	============
	CycleWeaponReverseCommand
	Go to the prev weapon with ammo
	============
*/

void() CycleWeaponReverseCommand =
{
	self.impulse = 0;
	if(self.weapon <= 0) return;
	
	float currentSlot = GetCurrentSlot();
	for(float i = 1; i < SLOT_AMOUNT - 1; i++)
	{
		float needSlot = currentSlot - i;
		if(needSlot < 1) needSlot = needSlot + (SLOT_AMOUNT - 1);
		if(self.slot[needSlot]) 
		{
			self.impulse = needSlot;
			break;
		}
	}
};






/*
	============
	W_WeaponFrame
	Called every frame so impulse events can be handled as well as possible
	============
*/

void() W_WeaponFrame =
{
	if (time < self.attack_finished) return;
	ImpulseCommands();
	if (!self.button0) self.ShootsFired = 0;
	if (self.button0) W_Attack();	// check for attack
};


void() PM_Select;
void() AK74_Select;
void() KNIFE_Select;
void() MOSS_Select;
void() SPAS_Select;
void() GRENADE_Select;
void() SVD_Select;
void() VAL_Select;
void() AKSU_Select;
void() MP5_Select;
void() VSS_Select;
void() GAUSS_Select;
void() BOLT_Select;
void() SelectCurrentWeapon
{
	if(self.weapon == WP_AK74) AK74_Select();
	else if(self.weapon == WP_PISTOL) PM_Select();
	else if(self.weapon == WP_SNIPER) SVD_Select();
	else if(self.weapon == WP_KNIFE) KNIFE_Select();
	else if(self.weapon == WP_MOSS) MOSS_Select();
	else if(self.weapon == WP_SPAS) SPAS_Select();
	else if(self.weapon == WP_GRENADE) GRENADE_Select();
	else if(self.weapon == WP_VAL) VAL_Select();
	else if(self.weapon == WP_AKSU) AKSU_Select();
	else if(self.weapon == WP_MP5) MP5_Select();
	else if(self.weapon == WP_VSS) VSS_Select();
	else if(self.weapon == WP_GAUSS) GAUSS_Select();
	else if(self.weapon == WP_BOLT) BOLT_Select();
};



