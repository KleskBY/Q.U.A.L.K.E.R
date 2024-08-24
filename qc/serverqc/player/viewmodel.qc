
.entity viewmodel;

void() Viewmodel =
{
	if(!self.viewmodel)
	{
		self.viewmodel = spawn();
		self.viewmodel.viewmodelforclient = self;
		self.viewmodel.movetype = MOVETYPE_NONE;
		self.viewmodel.solid = SOLID_NOT;
		self.viewmodel.owner = self;
		setsize(self.viewmodel, '0 0 0', '0 0 0');
	}
	
	if(self.health < 0 || self.health == 666)
	{
		self.weaponmodel = "";
		if(self.viewmodel) setmodel(self.viewmodel, "");
		return;
	}
	
	if(self.weaponmodel != "" || self.viewmodel.model == "")
	{
		setmodel(self.viewmodel, self.weaponmodel);
		self.weaponmodel = "";
	}
	self.viewmodel.frame = self.weaponframe;

	local vector recoil = self.punchangle * 0.1;
	recoil_z = vlen(recoil) * 1;
	if(self.stopViewmodel) return;
	if(self.button4 && !self.button3 && !self.button1 && self.running && !self.reload && !self.button0  && vlen(self.velocity) > 50) //sprint
	{
		if(self.weapon != WP_KNIFE && self.weapon != WP_GRENADE)
		{
			self.viewmodel.origin = LerpVector(self.viewmodel.origin, '2 -7 -1', 0.05);
			self.viewmodel.angles = LerpVector(self.viewmodel.angles, '-10 55 0', 0.05);
			self.viewzoom = Lerp(self.viewzoom, 1, 0.05);
			if(vlen(self.viewmodel.origin - '2 -7 -1') < 1) self.state = STATE_RUN;
		}
	}
	else if(self.button5 && IsSniper(self.weapon) && self.state != STATE_RUN) //aim
	{
		self.viewmodel.origin = LerpVector(self.viewmodel.origin, '0 0 0' + recoil, 0.05);
		self.viewmodel.angles = LerpVector(self.viewmodel.angles, '0 0 0', 0.05); //'0.35 0 0'
		self.viewzoom = Lerp(self.viewzoom, 0.35, 0.05);
		if(vlen(self.viewmodel.origin - '-6 4.2 3.8') < 1) self.state = STATE_AIM;
	}
	else 
	{
		self.viewmodel.origin = LerpVector(self.viewmodel.origin, '0 0 0', 0.05);
		self.viewmodel.angles = LerpVector(self.viewmodel.angles, '0 0 0', 0.05);
		self.viewzoom = Lerp(self.viewzoom, 1, 0.05);
		if(vlen(self.viewmodel.origin) < 1) self.state = STATE_IDLE;
	}
	
}