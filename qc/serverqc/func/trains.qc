


//============================================================================

void() train_next;
void() func_train_find;

void() train_blocked =
{
	if (time < self.attack_finished) return;
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg);
};
void() train_use =
{
	if (self.think != func_train_find) return;		// already activated
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	train_next();
};

void() train_wait =
{
	if (self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	}
	else self.nextthink = self.ltime + 0.1;
	self.think = train_next;
};

void() train_next =
{
	local entity targ, t;
	targ = find (world, targetname, self.target);
	self.target = targ.target;
	if(targ.speed) self.speed = targ.speed;
	if(!self.speed) self.speed = 100;
	if(!self.target) objerror ("train_next: no next target");
	if(targ.wait) self.wait = targ.wait;
	else self.wait = 0;
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	SUB_CalcMove (targ.origin - self.mins, self.speed, train_wait);
	if (targ.killtarget) // kill the killtagets
	{
		t = world;
		do
		{
			t = find (t, targetname, targ.killtarget);
			if (!t) return;
			ambientsound (self.origin, "misc/null.wav", 1, ATTN_NONE);
			remove (t);
		} 
		while ( 1 );
	}
};

void() func_train_find =
{
	local entity	targ;

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	setorigin (self, targ.origin - self.mins);
	if (!self.targetname)
	{	// not triggered, so start immediately
		self.nextthink = self.ltime + 0.1;
		self.think = train_next;
	}
};

/*QUAKED func_train (0 .5 .8) ?
Trains are moving platforms that players can ride.
The targets origin specifies the min point of the train at each corner.
The train spawns at the first target it is pointing at.
If the train is the target of a button or trigger, it will not begin moving until activated.
speed	default 100
dmg		default	2
sounds
1) ratchet metal

*/
void() func_train =
{	
	if (!self.speed) self.speed = 100;
	if (!self.target) objerror ("func_train without a target");
	if (!self.dmg) self.dmg = 2;

	if (self.sounds == 0)
	{
		self.noise = ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound ("misc/null.wav");
	}
	else if (self.sounds == 1)
	{
		precache_sound ("func/train.wav");
		self.noise = ("func/train.wav");
		self.noise1 = ("func/train.wav");
	}
	else if (self.sounds == 2)
	{
		precache_sound("func/doormove2.wav");
		precache_sound("func/doorstop1.wav");
		self.noise = "func/doorstop1.wav";
		self.noise1 = "func/doormove2.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound("misc/null.wav");
		precache_sound("func/doorstop3.wav");
		self.noise = "misc/null.wav";
		self.noise1 = "func/doorstop3.wav";
	}
	self.cnt = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.classname = "train";

	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

/*QUAKED misc_teleporttrain (0 .5 .8) (-8 -8 -8) (8 8 8)
This is used for the final bos
*/
void() misc_teleporttrain =
{	
	if (!self.speed) self.speed = 100;
	if (!self.target) objerror ("func_train without a target");

	self.cnt = 1;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.avelocity = '100 200 300';

	//self.noise = ("misc/null.wav");
	//precache_sound ("misc/null.wav");
	//self.noise1 = ("misc/null.wav");
	//precache_sound ("misc/null.wav");

	precache_model2 ("progs/teleport.mdl");
	setmodel (self, "progs/teleport.mdl");
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

