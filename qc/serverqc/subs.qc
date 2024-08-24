
////////////////////////////// BASIC //////////////////////////////

void SUB_Null()
{

};

void SUB_Remove()
{ 
	remove(self); 
};

void SUB_null_pain(entity attacker, float damage)
{

};



//Calculate self.avelocity and self.nextthink to reach destangle from self.angles rotating
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt =
{
	entity stemp;
	stemp = self;
	self = ent;
	SUB_CalcAngleMove(destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove =
{
	vector destdelta;
	float len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");

// set destdelta to the vector needed to move
	destdelta = destangle - self.angles;

// calculate length ofvector
	len = vlen(destdelta);

// divide by speed to get time to reach dest
	traveltime = len / tspeed;

// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime);

	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

//After rotating, set angle to exact final angle
void() SUB_CalcAngleMoveDone =
{
	self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};


/*
=============
SUB_CalcMove

calculate self.velocity and self.nextthink to reach dest from
self.origin traveling at speed
===============
*/
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt =
{
	entity stemp;
	stemp = self;
	self = ent;

	SUB_CalcMove(tdest, tspeed, func);
	self = stemp;
};

void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
	vector vdestdelta;
	float len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");

	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}

// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;

// calculate length of vector
	len = vlen(vdestdelta);

// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	if (traveltime < 0.1)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}

// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime); // qcc won't take vec/float
};

void()  SUB_CalcMoveDone =
{
	setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};


/*
==============================
SUB_UseTargets

the global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
and removes them, so some events can remove other triggers.

Search for(string)targetname in all entities that
match(string)self.target and call their .use function

==============================
*/

void() DelayThink =
{
	activator = self.enemy;
	SUB_UseTargets();
	remove(self);
};

void() SUB_UseTargets =
{
	entity t, stemp, otemp, act;

//
// check for a delay
//
	if (self.delay)
	{
	// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}


//
// print the message
//
	if (activator.classname == "player" && self.message != "")
	{
		centerprint(activator, self.message);
		if (!self.noise)
			sound(activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

//
// kill the killtagets
//
	if (self.killtarget)
	{
		t = world;
		do
		{
			t = find(t, targetname, self.killtarget);
			if (!t)
				return;
			remove(t);
		} while (1);
	}

//
// fire targets
//
	if (self.target)
	{
		act = activator;
		t = world;
		do
		{
			t = find(t, targetname, self.target);
			if (!t)
			{
				return;
			}
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use)
					self.use();
			}
			self = stemp;
			other = otemp;
			activator = act;
		} while (1);
	}


};


/*
QuakeEd only writes a single float for angles(bad idea), so up and down are
just constant angles.
*/
void() SetMovedir =
{
	if (self.angles == '0 -1 0') self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0') self.movedir = '0 0 -1';
	else
	{
		makevectors(self.angles);
		self.movedir = v_forward;
	}
	self.angles = '0 0 0';
};

/*
================
InitTrigger
================
*/
void() InitTrigger =
{
// trigger angles are used for one-way touches.  An angle of 0 is assumed
// to mean no restrictions, so use a yaw of 360 instead.
	if (self.angles != '0 0 0') SetMovedir();
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model); // set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
};















////////////////////////////// GENERAL //////////////////////////////

float InFront(vector targ)
{
	makevectors(self.angles);
	vector vec = normalize(targ - (self.origin + self.view_ofs));
	float dot = vec * v_forward;
	if(dot > 0.7) return TRUE;
	return FALSE;
};

float infront(vector targ)
{
	makevectors(self.angles);
	vector vec = normalize(targ - (self.origin + self.view_ofs));
	float dot = vec * v_forward;
	if(dot > 0.35) return TRUE;
	return FALSE;
};



float IsVisible(entity targ)
{
	vector spot1 = self.origin + self.view_ofs;
	vector spot2 = targ.origin + self.view_ofs;
	traceline(spot1, spot2, TRUE, self); // Trace line, ignore monsters
	if (trace_inopen && trace_inwater) return FALSE; // Do not see an object in the water if you are on land
	if (trace_fraction == 1) return TRUE;
	return FALSE;
};


float IsAllive(entity e)
{
	if(e.health > 0 && !e.deadflag) return TRUE;
	return FALSE;
};

entity FindNearestPlayer(vector src)
{
	local entity e, nearest;
	for (e = findchain(classname, "player"); e; e = e.chain) 
	{
		if(e != self && e.deadflag != DEAD_DEAD && e.deadflag != DEAD_DYING && e.deadflag != DEAD_RESPAWNABLE)
		{
			if (!nearest || !IsVisible(nearest)) nearest = e;
			if(IsVisible(e))
			{
				if (!nearest) nearest = e;
				else if(vlen(e.origin - src) < vlen(nearest.origin - src)) nearest = e;
			}
			else if (!nearest) nearest = e;
		}
	}
	return nearest;
	
};


void(void() thinkst) SUB_CheckRefire =
{
	if (skill != 3) return;
	if (self.cnt == 1) return;
	if (!IsVisible(self.enemy)) return;
	self.cnt = 1;
	self.think = thinkst;
};


////////////////////////////// DEBUG //////////////////////////////

void(vector start, vector dst) DrawLine = //cl_beams_quakepositionhack
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, start_x);
	WriteCoord (MSG_BROADCAST, start_y);
	WriteCoord (MSG_BROADCAST, start_z);
	WriteCoord (MSG_BROADCAST, dst_x);
	WriteCoord (MSG_BROADCAST, dst_y);
	WriteCoord (MSG_BROADCAST, dst_z);
};

void(vector vec) PrintVector =
{
	bprint(ftos(vec_x));
	bprint(" ");
	bprint(ftos(vec_y));
	bprint(" ");
	bprint(ftos(vec_z));
	bprint("\n");
}

void() PrintAllConchars =
{
	local float i;
	for(i = 0; i < 256; i++)
	{
		bprint(strcat(ftos(i), ": ", chr2str(i), "\n"));
	}
}
