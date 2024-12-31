


void make_bubbles();
void bubble_bob();


void acid_touch()
{
	if(self.lastTouch + 0.4 < time)
	{
		sound (self, CHAN_BODY, "anomalies/buzz_hit.wav", 1, ATTN_NORM);
		sound (other, CHAN_BODY, "anomalies/buzz_hit.wav", 1, ATTN_NORM);
		T_Damage (other, self, world, self.dmg);
		self.lastTouch = time;
	}
}

void make_bubbles()
{
	entity bubble = spawn();

	bubble.model		= "particles/bubble.spr32";
	bubble.origin		= [ random(self.absmin_x, self.absmax_x), random(self.absmin_y, self.absmax_y), self.absmin_z ] ;
	bubble.scale		= 0.15;
	bubble.colormod		=  '0.25 .8 0.2'; 
	// bubble.alpha = 0.5;

	setmodel (bubble, bubble.model);
	setorigin (bubble, bubble.origin);

	bubble.movetype		= MOVETYPE_NOCLIP;
	bubble.solid		= SOLID_NOT;
	bubble.velocity		= '0 0 15';
	bubble.nextthink	= time + 0.1;
	bubble.think		= bubble_bob;

	bubble.classname	= "bubble";
	bubble.frame		= 0;
	bubble.cnt			= 0;

	setsize (bubble, '-8 -8 -8', '8 8 8');
}

void bubble_split()
{
	entity	bubble		= spawn();	

	bubble.model		= self.model;
	bubble.origin		= self.origin;
	bubble.scale		= self.scale;
	bubble.colormod		= self.colormod;
	// bubble.alpha = 0.5;

	setmodel (bubble, bubble.model);
	setorigin (bubble, bubble.origin);

	bubble.movetype		= MOVETYPE_NOCLIP;
	bubble.solid		= SOLID_NOT;
	bubble.velocity		= self.velocity;

	bubble.nextthink = time + 0.5;
	bubble.think		= bubble_bob;

	bubble.classname	= "bubble";
	bubble.frame		= 1;
	bubble.cnt			= 10;

	setsize (bubble, '-8 -8 -8', '8 8 8');

	self.frame			= 1;
	self.cnt			= 10;
}


void bubble_bob()
{
	self.cnt = self.cnt + 1;
	if (self.cnt == 4) bubble_split();
	if (self.cnt == 30) remove(self);

	vector newvel = randomvec() * 10;
	newvel_z = 8;
	self.velocity = newvel;

	// self.alpha = self.alpha - 0.01;
		
	self.nextthink = time + 0.1;
	self.think = bubble_bob;
}

void acid_think()
{
	if(self.attack_finished < time) 
	{
		sound (self, CHAN_BODY, "anomalies/buzz_idle.wav", 1, ATTN_NORM);
		self.attack_finished = time + 4.5;
	}
	make_bubbles();
	self.nextthink = time + 0.5;
};

void anomaly_acid()
{
	precache_model ("particles/bubble.spr32");
	precache_sound ("anomalies/buzz_idle.wav");
	precache_sound ("anomalies/buzz_hit.wav");

	InitTrigger();
	setsize (self, '-30 -30 0', '30 30 25');
	self.touch = acid_touch;
	self.think = acid_think;

	self.nextthink = time + 0.1;
	if (!self.dmg) self.dmg = 2;
}