


void() springboard_touch =
{
	if(self.lastTouch + 2.5 < time)
	{
		sound (self, CHAN_BODY, "anomalies/springboard_hit.wav", 1, ATTN_NORM);
		sound (other, CHAN_BODY, "anomalies/springboard_hit.wav", 1, ATTN_NORM);
		local vector dir = normalize(other.origin - self.origin);
		other.flags = other.flags - FL_ONGROUND;
		other.velocity = other.velocity + dir * 450;
		other.velocity_z = 250;
	
		T_Damage (other, self, self, self.dmg);
		self.lastTouch = time;
		te_teleport(self.origin);
		self.timer = time + 2.5;
		// te_smallflash(self.origin);
	}
	
};

void() springboard_think = 
{
	// if(self.timer < time) 
	{
		
		if(self.timer < time) 
		{
			te_explosion2(self.origin, 246, 256);
			self.timer = time + 2.5 + random();
		}
		if(self.attack_finished < time) 
		{
			sound (self, CHAN_BODY, "anomalies/springboard_idle.wav", 1, ATTN_NORM);
			self.attack_finished = time + 5;
		}
		self.nextthink = time + 0.25;
	}
};
void() anomaly_springboard =
{
	precache_sound("anomalies/springboard_hit.wav");
	precache_sound("anomalies/springboard_idle.wav");
	InitTrigger ();
	setsize (self, '-40 -40 0', '40 40 40');
	self.touch = springboard_touch;
	self.think = springboard_think;
	self.nextthink = time + 0.1;
	if (!self.dmg) self.dmg = 15;
};