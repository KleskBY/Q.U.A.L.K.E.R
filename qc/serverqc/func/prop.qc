
.float modelscale;


void() func_prop =
{
	self.solid = SOLID_BSP;
	if(self.model)
	{
		self.netname = self.model;
		precache_model(self.model);
		setmodel (self, self.model);
	}
	else if(self.weaponmodel)
	{
		self.netname = self.weaponmodel;
		precache_model(self.weaponmodel);
		setmodel (self, self.weaponmodel);
	}
	if(self.modelscale > 0)
	{
		self.scale = self.modelscale;
	}
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
void() test_ent_think =
{
	self.frame = self.frame + 2;
	if(self.frame > 335) self.frame = 0;
	self.nextthink = time + 0.1;
}


void test_ent()
{
	self.solid = SOLID_BSP;
	self.think = test_ent_think;
	self.nextthink = time + 0.1;
	self.netname = self.model;
	self.classname = "test_ent";
	precache_model(self.model);
	setmodel (self, self.model);
	
	self.yaw_speed = 12;
	// self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	self.health = 9999;


}