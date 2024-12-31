
void(entity targ, entity attacker) ClientObituary;
void() monster_death_use;
void(entity targ, entity attacker) ProcessKillMoney;
//============================================================================

// void() HuntTarget =
// {
	// self.goalentity = self.enemy;
	// if(self.th_missile && random() > 0.73 && IsVisible(self.enemy)) self.think = self.th_missile;
	// else self.think = self.th_run;
	// self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	// self.nextthink = time + 0.1;
	// SUB_AttackFinished(1); // wait a while before first attack
// };

// void() FoundTarget =
// {
	// if (self.enemy.classname == "player") // let other monsters see this monster for a while
	// { 
		// sight_entity = self;
		// sight_entity_time = time;
	// }

	// self.show_hostile = time + 1; // wake up other monsters

	// if(sight_entity && allive(sight_entity) && self.sightSound) self.sightSound();
	// HuntTarget();
// };


/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	entity oself;

	oself = self;
	self = targ;

	if (self.health < -99) self.health = -99; // don't let sbar look bad if a player
	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE) // doors, triggers, etc
	{
		self.th_die();
		self = oself;
		return;
	}

	self.enemy = attacker;

// bump the monster counter
	if (self.flags & FL_MONSTER)
	{
		killed_monsters = killed_monsters + 1;
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
	}
	
	ProcessKillMoney(targ, attacker);
	
	
	ClientObituary(self, attacker);

	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die();

	self = oself;
};





void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	vector dir;
	entity oldself;
	float save;
	float take;

	if (!targ.takedamage) return;

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

	if (targ.classname == "player" && !deathmatch && !skill) damage = rint(damage * 0.75);
	if (attacker.super_damage_finished > time) damage = damage * 4; // check for quad damage powerup on the attacker

// save damage based on the target's armor level

	save = ceil(targ.armortype * damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = 0; // lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	}

	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

	// figure momentum add
	if (inflictor != world && targ.movetype != MOVETYPE_NONE && targ.movetype != MOVETYPE_NOCLIP && targ.classname != "monster_snork" /*&& (targ.movetype == MOVETYPE_WALK)*/)
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir * damage * PUSHING_FACTOR;
	}

	if (targ.flags & FL_GODMODE) return; // check for godmode or invincibility
	if (teamplay && targ.classname == "player" && attacker.classname == "player" && targ.team == attacker.team && targ != attacker) return; // team play damage avoidance
	targ.health = targ.health - take;
	if (targ.health <= 0)
	{
		Killed(targ, attacker);
		return;
	}

// react to the damage
	oldself = self;
	self = targ;

	if ((self.flags & FL_MONSTER) && attacker != world)
	{
		if (self != attacker && attacker != self.enemy) // get mad unless of the same class(except for soldiers)
		{
			if (self.classname != attacker.classname)
			{
				if (self.enemy.classname == "player") self.oldenemy = self.enemy;
				self.enemy = attacker;
				FoundTarget();
			}
		}
	}

	if (self.th_pain)
	{
		self.th_pain(attacker, take);
		if (skill == 3) self.pain_finished = time + 5; // nightmare mode monsters don't go into pain frames often
	}

	self = oldself;
};


/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
{
	float points;
	entity head;
	vector org;

	head = findradius(inflictor.origin, damage + 40);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs) * 0.5;
				points = 0.5 * vlen(inflictor.origin - org);
				if (points < 0) points = 0;
				points = damage - points;
				if (head == attacker) points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage(head, inflictor))
					{
						T_Damage(head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};


void() ShrapnelTouch =
{
	if (other == self.owner) return;
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}	

	if (other.takedamage) // hit something that bleeds
	{
        makevectors(self.v_angle);
		Shoot_Blood (other.origin,v_forward * 2000);
        T_Damage (other, self, self, 20);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	remove(self);
};
void(vector org, vector dir) ShootShrapnel =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir);
	newmis.touch = ShrapnelTouch;
    newmis.classname = "shrapnel";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 1.5;
	setmodel (newmis, "models/shrap.md3");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);
	newmis.modelflags = MF_GRENADE;
	newmis.velocity = dir * 3;
};

void() CreateExplosion =
{
	//T_GrenadeRadiusDamage (self, self.owner, GRENADE_DAMAGE, world);
	T_RadiusDamage (self, self.owner, 155, world);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	vector shrapdir;
	float i;
	for (i = 0; i < 17; i = i+1)	
	{
      shrapdir_x = 0 - (random(-1,1) * 200);
      shrapdir_y = 0 - (random(-1,1) * 200);
      shrapdir_z = (random(-1,1) * 200);
      ShootShrapnel(self.origin , shrapdir);
	}
	sound (self, CHAN_WEAPON, "weapons/grenade/explosion.wav", 1, SoundRadius(3500));
	remove(self);
};

float(entity e, float healamount, float ignore) T_Heal =
{
	if (e.health <= 0) return 0;
	if ((!ignore) && (e.health >= other.max_health)) return 0;
	healamount = ceil(healamount);

	e.health = e.health + healamount;
	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;

	if (e.health > 250) e.health = 250;
	return 1;
};

float (entity e, float healamount, float ignore) T_HealSelf =
{
	if (e.health <= 0) return 0;
	if ((!ignore) && (e.health >= e.max_health)) return 0;
	healamount = ceil(healamount);
	e.health = e.health + healamount;
	if ((!ignore) && (e.health >= e.max_health)) e.health = e.max_health;
	if (e.health > 250) e.health = 250;
	return 1;
};




/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/

float(entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};
