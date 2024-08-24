
void() burner_think =
{
	self.nextthink = time + 0.01;
	pointparticles(particleeffectnum("anomaly_burner"), self.origin, VEC_ORIGIN, TRUE);
	if(self.attack_finished < time) 
	{
		sound(self, CHAN_VOICE, "anomalies/burner_idle.wav", 1, SoundRadius(250));
		self.attack_finished = time + 8;
	}
	// pointparticles(particleeffectnum("g_weaponeffect"), self.origin, VEC_ORIGIN, TRUE);
};


void() burner_burn =
{
	if(self.timer > time)
	{
		self.effects = EF_FLAME; 
		te_flamejet(self.origin, '0 0 400', 25);
		self.think = burner_burn;
		self.nextthink = time + 0.01;
	}
	else 
	{
		self.effects = 0; 
		self.think = burner_think;
		self.nextthink = time + 0.01;
	}
};

void() burner_touch =
{
	if(self.timer < time) sound(self, CHAN_BODY, "anomalies/burner_hit.wav", 1, ATTN_NORM);
	
	self.timer = time + 4;
	burner_burn();
	if(self.lastTouch + 0.1 < time)
	{
		T_Damage (other, self, self, self.dmg);
		self.lastTouch = time;
	}
};


void() anomaly_burner =
{
	precache_sound("anomalies/burner_hit.wav");
	precache_sound("anomalies/burner_idle.wav");

	InitTrigger ();
	setsize (self, '-35 -35 0', '35 35 100');
	self.touch = burner_touch;
	if (!self.dmg) self.dmg = 5;
	self.effects = 0; 
	self.think = burner_think;
	self.nextthink = time + 0.1;
};