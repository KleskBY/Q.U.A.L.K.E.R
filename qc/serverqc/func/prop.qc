
void() func_prop =
{
	self.solid = SOLID_BSP;
	self.netname = self.weaponmodel;
	precache_model(self.weaponmodel);
	setmodel (self, self.weaponmodel);
	
};


void() prop_brush =
{
	func_prop();
}
void() prop_static =
{
	func_prop();
}
void() misc_model =
{
	func_prop();
};

/*
void() prop_think =
{

	self.nextthink = time + 0.1;
	self.origin = '0 0 0';
}


void() func_prop =
{
	// self.movetype = MOVE_HITMODEL;
	self.solid = SOLID_BSP;
	self.think = prop_think;
	self.nextthink = time + 0.1;
	self.netname = self.weaponmodel;
	precache_model(self.weaponmodel);
	setmodel (self, self.weaponmodel);
};

*/