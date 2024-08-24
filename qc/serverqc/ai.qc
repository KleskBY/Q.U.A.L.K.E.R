
float(float v) anglemod =
{
	while (v >= 360) v = v - 360;
	while (v < 0) v = v + 360;
	return v;
};


float	enemy_vis, enemy_infront, enemy_range;
float	enemy_yaw;

entity sight_entity;
float sight_entity_time;



//============================================================================

float(entity targ) range =
{
	local vector	spot1, spot2;
	local float		r;	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	
	r = vlen (spot1 - spot2);
	if (r < 80) return RANGE_MELEE;
	if (r < 500) return RANGE_NEAR;
	if (r < 1000) return RANGE_MID;
	return RANGE_FAR;
};


void() HuntTarget =
{
	self.goalentity = self.enemy;
	if(self.th_missile && random() > 0.73 && IsVisible(self.enemy)) self.think = self.th_missile;
	else self.think = self.th_run;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	self.attack_finished = time + 1; // wait a while before first attack
};

void() FoundTarget =
{
	if (self.enemy.classname == "player") // let other monsters see this monster for a while
	{ 
		sight_entity = self;
		sight_entity_time = time;
	}

	self.show_hostile = time + 1; // wake up other monsters

	if(sight_entity && IsAllive(sight_entity) && self.sightSound) self.sightSound();
	HuntTarget();
};

/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target

Returns TRUE if an enemy was sighted

When a player fires a missile, the point of impact becomes a fakeplayer so
that monsters that see the impact will respond as if they had seen the
player.

To avoid spending too much time, only a single client(or fakeclient) is
checked each frame.  This means multi player games will have slightly
slower noticing monsters.
============
*/
.float ignore_player_for;
float() FindTarget =
{
	entity client;
	float r;

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3))
	{
		client = sight_entity;
		if (client.enemy == self.enemy) return FALSE;
	}
	else
	{
		client = checkclient();
		if (!client) return FALSE; // current check entity isn't in PVS
	}

	if (client == self.enemy) return FALSE;
	if (client.flags & FL_NOTARGET) return FALSE;
	if (client.items & IT_INVISIBILITY) return FALSE;
	if (self.ignore_player_for > time) return FALSE;

	r = range(client);
	if (r == RANGE_FAR) return FALSE;
	if (!IsVisible(client)) return FALSE;

	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront(client.origin))
			return FALSE;
	}
	else if (r == RANGE_MID)
	{
		if (!infront(client.origin)) return FALSE;
	}

//
// got one
//
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}

	FoundTarget();

	return TRUE;
};

float() FacingIdeal =
{
	float delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315) return FALSE;
	return TRUE;
};



///////////////////////////////////////////
////////////////// ATTACK /////////////////
///////////////////////////////////////////

void ai_face();

void(float d) ai_charge =
{
	ai_face();	
	movetogoal(d);		// done in C code...
};

void() ai_run_missile =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw();
	if (FacingIdeal())
	{
		self.th_missile();
		self.attack_state = AS_STRAIGHT;
	}
};

void() ai_melee =
{
	if (!self.enemy) return;		// removed before stroke
	vector delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 90) return;
	float ldmg = (random() + random() + random()) * 4;
	T_Damage (self.enemy, self, self, ldmg);
	if(vlen(self.enemy.punchangle) < 1)
	{
		self.enemy.punchangle_x = random(-10, 10);
		self.enemy.punchangle_y = random(-10, 10);
		self.enemy.punchangle_z = random(-10, 10);
	}
};

void() ai_run_melee =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw();

	if (FacingIdeal())
	{
		self.th_melee();
		self.attack_state = AS_STRAIGHT;
	}
};


float() CheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ) return FALSE;		// don't have a clear shot
	if (trace_inopen && trace_inwater) return FALSE;			// sight line crossed contents

	// melee attack
	if (enemy_range == RANGE_MELEE)
	{	
		if (self.th_melee)
		{
			self.th_melee();
			return TRUE;
		}
	}
	
// missile attack
	if (!self.th_missile) return FALSE;
	if (time < self.attack_finished) return FALSE;
	if (enemy_range == RANGE_FAR) return FALSE;
		
	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
		self.attack_finished = 0;
	}
	else if (enemy_range == RANGE_NEAR)
	{
		if (self.th_melee) chance = 0.2;
		else chance = 0.4;
	}
	else if (enemy_range == RANGE_MID)
	{
		if (self.th_melee) chance = 0.05;
		else chance = 0.1;
	}
	else chance = 0;

	if (random() < chance) //&& self.attack_finished + 3 < time
	{
		self.th_missile();
		self.attack_finished += 2 * random();
		return TRUE;
	}

	return FALSE;
};




///////////////////////////////////////////
/////////////////// MOVE //////////////////
///////////////////////////////////////////



void() ai_stand =
{
	if (FindTarget()) return;
	if (time > self.pausetime)
	{
		self.th_walk();
		return;
	}
};

void(float dist) ai_walk =
{
	movedist = dist;
	if (FindTarget()) return; // check for noticing a player
	movetogoal(dist);
};


void(float dist) ai_forward =
{
	walkmove(self.angles_y, dist);
};

void(float dist) ai_back =
{
	walkmove((self.angles_y+180), dist);
};

void(float dist) ai_painforward =
{
	walkmove(self.ideal_yaw, dist);
};

void() ai_face =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

void() ai_run_slide =
{
	float ofs;

	self.ideal_yaw = enemy_yaw;
	ChangeYaw();
	if (self.lefty) ofs = 90;
	else ofs = -90;

	if (walkmove(self.ideal_yaw + ofs, movedist))
		return;

	self.lefty = 1 - self.lefty;
	
	walkmove(self.ideal_yaw - ofs, movedist);
};

void(float dist) ai_run =
{
	movedist = dist;

	if (self.enemy.health <= 0) // see if the enemy is dead
	{
		self.enemy = world;
	// FIXME: look all around for other targets
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget();
		}
		else
		{
			if (self.movetarget) self.th_walk();
			else self.th_stand();
			return;
		}
	}

	self.show_hostile = time + 1; // wake up other monsters
	enemy_vis = IsVisible(self.enemy); // check knowledge of enemy
	if (enemy_vis) self.search_time = time + 5;
	if (self.search_time < time) // look for other coop players
	{
		if (FindTarget()) return;
	}

	enemy_infront = infront(self.enemy.origin);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);

	if (self.attack_state == AS_MISSILE)
	{
		ai_run_missile();
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
		ai_run_melee();
		return;
	}
	
	if(self.checkAttack)
	{
		if (enemy_vis && self.checkAttack()) return;
	}
	else 
	{
		if(enemy_vis && CheckAttack()) return;
	}

	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide();
		return;
	}

	movetogoal(dist); //head straight in. done in C code...
};




///////////////////////////////////////////
///////////////// MONSTER /////////////////
///////////////////////////////////////////




//Using a monster makes it angry at the current activator
void() monster_use =
{
	if (self.enemy) return;
	if (self.health <= 0) return;
	if (activator.items & IT_INVISIBILITY) return;
	if (activator.flags & FL_NOTARGET) return;
	if (activator.classname != "player") return;

	// delay reaction so if the monster is teleported, its sound is still heard
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

//When a mosnter dies, it fires all of its targets with the current enemy as activator.
void() monster_death_use =
{
	// fall to ground
	if (self.flags & FL_FLY) self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM) self.flags = self.flags - FL_SWIM;
	if (!self.target) return;

	activator = self.enemy;
	SUB_UseTargets();
};


void() walkmonster_start_go =
{
	self.origin_z = self.origin_z + 1; // raise off floor a bit
	droptofloor();

	if (!walkmove(0,0))
	{
		dprint("walkmonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}

	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed) self.yaw_speed = 15;
	self.view_ofs = [0, 0, self.size_z - 5];
	self.use = monster_use;

	self.flags = self.flags | FL_MONSTER;

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint("Monster can't find target at ");
			dprint(vtos(self.origin));
			dprint("\n");
		}
		
		// this used to be an objerror
		if (self.movetarget.classname == "path_corner") self.th_walk();
		else
		{
			self.pausetime = 99999999;
			self.th_stand();
		}
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand();
	}

	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random() * 0.5;
};


void() walkmonster_start =
{
	self.nextthink = self.nextthink + random() * 0.5; // delay drop to floor to make sure all doors have been spawned spread think times so they don't all happen at same time
	self.think = walkmonster_start_go;
	total_monsters = total_monsters + 1;
};



/*
==============================================================================

MOVETARGET CODE

The angle of the movetarget effects standing and bowing direction, but has no effect on movement, which allways heads to the next target.

targetname
must be present.  The name of this movetarget.

target
the next spot to move to.  If not present, stop here for good.

pausetime
The number of seconds to spend standing or bowing for path_stand or path_bow

==============================================================================
*/

void() t_movetarget;
void() movetarget_f =
{
	if (!self.targetname)
		objerror("monster_movetarget: no targetname");

	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize(self, '-8 -8 -8', '8 8 8');

};

/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
*/
void() path_corner =
{
	movetarget_f();
};


/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void() t_movetarget =
{
	entity temp;

	if (other.movetarget != self)
		return;

	if (other.enemy)
		return; // fighting, not following a path

	temp = self;
	self = other;
	other = temp;
	self.goalentity = self.movetarget = find(world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if (!self.movetarget)
	{
		self.pausetime = time + 999999;
		self.th_stand();
		return;
	}
};