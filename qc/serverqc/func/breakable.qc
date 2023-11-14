


.float material;


void (vector position, vector direction, float type) ShootGib = 
{
	if(!type) return;
	local entity blood;
	local float r;
	
	blood = spawn ();
	blood.owner = self;
	blood.movetype = MOVETYPE_BOUNCE;
	blood.solid = SOLID_NOT;
	makevectors (self.angles);
	blood.velocity = direction;
	blood.avelocity = '300 300 300';
	blood.angles = vectoangles(blood.velocity);
	blood.nextthink = time + random(2,4);
	blood.think = SUB_Remove;
	blood.touch = SUB_Remove;
	
	if(type == 1) 
	{
		blood.scale = random(0.6,1.6);
		r = rint(random() * 5) + 1;
		if(r == 1) setmodel (blood, "models/gibs/wood1.md3");
		else if(r == 2) setmodel (blood, "models/gibs/wood2.md3");
		else if(r == 3) setmodel (blood, "models/gibs/wood3.md3");
		else if(r == 4) setmodel (blood, "models/gibs/wood4.md3");
		else if(r == 5) setmodel (blood, "models/gibs/wood5.md3");
	}
	else if(type == 2) 
	{
		blood.alpha = 0.5;
		blood.scale = random(1,3);
		setmodel (blood,"models/gibs/glass.md3");
	}
	else 
	{
		blood.scale = random(0.6,1.6);
		r = rint(random() * 4) + 1;
		if(r == 1) setmodel (blood, "models/gibs/metal1.md3");
		else if(r == 2) setmodel (blood, "models/gibs/metal2.md3");
		else if(r == 3) setmodel (blood, "models/gibs/metal3.md3");
		else if(r == 4) setmodel (blood, "models/gibs/metal4.md3");
	}
	setsize (blood, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (blood, position);
	pointparticles(particleeffectnum("dust"), position, position, TRUE);
	//pointparticles(particleeffectnum("smoke"), position, direction, 1);
};
	


void(vector orig, float type) shootParts =
{
	local vector dir;
	local float i;
	if(self.lastTouch + 0.3 < time)
	{
		for (i = 0; i < 11; i = i+1)	
		{
			dir_x = 0 - (random(-1,1) * 100);
			dir_y = 0 - (random(-1,1) * 100);
			dir_z = (random(-1,1) * 100);
			
			ShootGib(orig, dir, type);
		}
		self.lastTouch = time;
	}
}


void BreakableHit(vector org, vector dir)
{
	if(trace_ent.lastTouch > time) return;
	trace_ent.lastTouch = time + 0.1;

	pointparticles(particleeffectnum("nailgun_muzzleflash"), org, '500 500 500', 1);
	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_GUNSHOT);
	WriteCoord (MSG_BROADCAST,org_x);
	WriteCoord (MSG_BROADCAST,org_y);
	WriteCoord (MSG_BROADCAST,org_z);
	
	for(float i = 0; i < 3; i++)
	{
		local vector meatdir;
		meatdir_x = ((random () * 100) + dir_x);
		meatdir_y = ((random () * 100) + dir_y);
		meatdir_z = ((random () * 100) + dir_z);
		ShootGib (org, meatdir, trace_ent.sounds);
	}
};






//on death or use
void() breakable_use =
{
	local vector center = (self.absmin + self.absmax) * 0.5;
	if (self.sounds == 1)
	{
		pointparticles(particleeffectnum("dust"), center, center, TRUE);
	}
	
	if(!self.pos1) shootParts(center, self.sounds);
	else shootParts(self.pos1, self.sounds);
	
	if(random() > 0.5) sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	else sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);

	self.think = SUB_Remove;
	self.nextthink = self.ltime + 1.01;
};

void() func_breakable =
{
	precache_model("models/gibs/wood1.md3");
	precache_model("models/gibs/wood2.md3");
	precache_model("models/gibs/wood3.md3");
	precache_model("models/gibs/wood4.md3");
	precache_model("models/gibs/wood5.md3");
	precache_model("models/gibs/metal1.md3");
	precache_model("models/gibs/metal2.md3");
	precache_model("models/gibs/metal3.md3");
	precache_model("models/gibs/metal4.md3");
	precache_model("models/gibs/glass.md3");

	if(!self.sounds) self.sounds = self.material;

	
	if (self.sounds == 0)
	{
		precache_sound ("misc/null.wav");
		self.noise1 = "misc/null.wav";
		self.noise2 = "misc/null.wav";
	}
	if (self.sounds == 1)
	{
		precache_sound("func/wood1.wav");
		precache_sound("func/wood2.wav");
		self.noise1 = "func/wood1.wav";
		self.noise2 = "func/wood2.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound("func/glass1.wav");
		precache_sound("func/glass2.wav");
		self.noise1 = "func/glass1.wav";
		self.noise2 = "func/glass2.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound("func/metal1.wav");
		precache_sound("func/metal2.wav");
		self.noise1 = "func/metal1.wav";
		self.noise2 = "func/metal2.wav";
	}
	
	self.max_health = self.health;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_NONE;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	
	self.classname = "breakable";
	if (self.health)
	{
		self.takedamage = DAMAGE_AIM;
		self.th_die = breakable_use;
	}
	self.use = breakable_use;
}