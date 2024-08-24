

void() shell_touch = 
{
	if (other.classname == "door") 
	{
		SUB_Remove();
		return;
	}
	if (self.owner.weapon == WP_SHOTGUN) sound (self, CHAN_WEAPON, "weapons/shell2.wav", 0.5, ATTN_NORM);
	else sound (self, CHAN_WEAPON, "weapons/shell1.wav", 0.5, ATTN_NORM);
};

void EjectShell(vector org, string mod)
{	
	makevectors(self.v_angle);
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	if (random() < 0.5) newmis.solid = SOLID_BBOX;
	else newmis.solid = SOLID_NOT;
	newmis.angles = v_forward * (random() + 1);
	newmis.classname = "shellcasing";
	newmis.touch = shell_touch;
	newmis.think = SUB_Remove;
	newmis.owner = self;
	newmis.nextthink = time + 3.5;
	setmodel (newmis, mod);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);
	newmis.avelocity_x = random(4000, 9000);
	newmis.avelocity_y = random(4000, 9000);
	newmis.velocity = (v_forward * random(10, 20)) + (v_right * random(60, 120)) + (v_up * random(70, 110));
};