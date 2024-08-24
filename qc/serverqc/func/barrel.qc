
void() barrel_explode =
{
	self.takedamage = DAMAGE_NO;
	self.classname = "breakable";
	// T_RadiusDamage (self, self, 160, world);
	particle (self.origin, '0 0 0', 75, 255);
	self.origin_z = self.origin_z + 32;
	CreateExplosion();
};

void() barrel_burn 
{
	self.nextthink = time + 0.1;
	T_Damage (self, self.enemy, self.enemy, 1);
}

void(entity attacker, float damage) barrel_pain
{
	if(damage > 5)
	{
		self.enemy = attacker;
		self.effects = EF_FLAME; 
		self.think = barrel_burn;
		self.nextthink = time + 0.1;
	}
}


void() misc_explobox =
{
	local float	oldz;
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	precache_model ("models/items/barrel.md3");
	setmodel (self, "models/items/barrel.md3");
	self.health = 36;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	self.classname = "breakable";
	self.th_pain = barrel_pain;
	setsize (self, '-13 -13 0', '13 13 40');

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};
