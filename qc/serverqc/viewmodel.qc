
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
	if (self.view_ofs == '0 0 0') // intermission or finale
	{
		setmodel(self.viewmodel, "");
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
	if(self.button4 && !self.reload && !self.button0 && !self.button3 && vlen(self.velocity) > 50) //sprint
	{
		if(self.weapon != WP_KNIFE)
		{
			self.viewmodel.origin = lerpv(self.viewmodel.origin, '2 -7 -1', 0.05);
			self.viewmodel.angles = lerpv(self.viewmodel.angles, '-10 55 0', 0.05);
			self.viewzoom = lerp(self.viewzoom, 1, 0.05);
			if(vlen(self.viewmodel.origin - '2 -7 -1') < 1) self.state = STATE_RUN;
		}
	}
	else if(self.button5 && self.weapon != WP_KNIFE) //aim
	{
		vector dest = stov(cvar_string("scratch2"));
		// if(self.weapon == WP_AK74) dest = '-2 4.86 2.2';
		// if(self.weapon == WP_PISTOL) dest = '-3 5.55 1.5';
		
		self.viewmodel.origin = lerpv(self.viewmodel.origin, dest + recoil, 0.05); //'-6 4.2 3.8'
		self.viewmodel.angles = lerpv(self.viewmodel.angles, '0 0 0', 0.05); //'0.35 0 0'
		if(IsSniper(self.weapon)) self.viewzoom = lerp(self.viewzoom, 0.4, 0.05);
		// else self.viewzoom = lerp(self.viewzoom, 0.7, 0.05);
		if(vlen(self.viewmodel.origin - dest) < 1) self.state = STATE_AIM;
	}
	else 
	{
		self.viewmodel.origin = lerpv(self.viewmodel.origin, '0 0 0', 0.05);
		self.viewmodel.angles = lerpv(self.viewmodel.angles, '0 0 0', 0.05);
		self.viewzoom = lerp(self.viewzoom, 1, 0.05);
		if(vlen(self.viewmodel.origin) < 1) self.state = STATE_IDLE;
	}
	
}