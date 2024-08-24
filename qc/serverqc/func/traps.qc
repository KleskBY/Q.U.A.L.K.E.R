

//Those are just normal traps, no femboys in there
float SPAWNFLAG_SUPERSPIKE = 1;
float SPAWNFLAG_LASER = 2;

////////////////// TOUCH FUNCS /////////////////////
void(float damage) spawn_touchblood;
void() spike_touch =
{
	if (other == self.owner) return;
	if (other.solid == SOLID_TRIGGER) return; // trigger field, do nothing
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (other.takedamage) // hit something that bleeds
	{
		spawn_touchblood(9);
		T_Damage(other, self, self.owner, 9);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		if (self.classname == "wizspike") WriteByte(MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike") WriteByte(MSG_BROADCAST, TE_KNIGHTSPIKE);
		else WriteByte(MSG_BROADCAST, TE_SPIKE);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}

	remove(self);
};

void() superspike_touch =
{
	if (other == self.owner) return;
	if (other.solid == SOLID_TRIGGER) return; // trigger field, do nothing
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (other.takedamage) // hit something that bleeds
	{
		spawn_touchblood(18);
		T_Damage(other, self, self.owner, 18);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}

	remove(self);
};


void() Laser_Touch =
{
	vector org;

	if (other == self.owner)
		return; // don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood(org, self.velocity*0.2, 15);
		T_Damage(other, self, self.owner, 15);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}

	remove(self);
};

////////////////// LAUCNH FUNCS /////////////////////


void(vector org, vector dir) launch_spike =
{
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel(newmis, "models/shrap.md3");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);

	newmis.velocity = dir * 1000;
};

void(vector org, vector vec) LaunchLaser =
{
	if (self.classname == "monster_enforcer") sound(self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel(newmis, "progs/laser.mdl");
	setsize(newmis, '0 0 0', '0 0 0');

	setorigin(newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};




void() spikeshooter_use =
{
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		sound(self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		LaunchLaser(self.origin, self.movedir);
	}
	else
	{
		sound(self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
		launch_spike(self.origin, self.movedir);
		newmis.velocity = self.movedir * 500;
		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE) newmis.touch = superspike_touch;
	}
};

void() shooter_think =
{
	spikeshooter_use();
	self.nextthink = time + self.wait;
	newmis.velocity = self.movedir * 500;
};


/*QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
When triggered, fires a spike in the direction set in QuakeEd.
Laser is only for REGISTERED.
*/

void() trap_spikeshooter =
{
	SetMovedir();
	self.use = spikeshooter_use;
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		precache_model("progs/laser.mdl");

		precache_sound("enforcer/enfire.wav");
		precache_sound("enforcer/enfstop.wav");
	}
	else
	{
		precache_model("models/shrap.md3");
		precache_sound("weapons/spike2.wav");
	}
};


/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
Continuously fires spikes.
"wait" time between spike(1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/
void() trap_shooter =
{
	trap_spikeshooter();
	if (self.wait == 0) self.wait = 1;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};


