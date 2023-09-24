

.float flashlight_flag;
void() flashlight_update =
{
	if (self.owner.view_ofs == '0 0 0' || self.owner.health <= 0) self.think = SUB_Remove;
	makevectors(self.owner.v_angle);
	traceline(self.owner.origin, self.owner.origin + v_forward * 6, FALSE, self);
	setorigin (self, trace_endpos + '0 0 10');
	self.angles_x = -(self.owner.v_angle_x - 180);
	self.angles_y = self.owner.v_angle_y;
	self.angles_z = self.owner.v_angle_z;
	self.light_lev = 300 - random(-5,5); //random to add flickering
	
	if(self.owner.classname == "observer") self.think = SUB_Remove;
	self.nextthink = time + 0.02;
};

void() flashlight_on =
{
	local entity myflash;
	
	if(self.classname != "observer")
	{
		myflash = spawn();
		myflash.movetype = MOVETYPE_NONE;
		myflash.solid = SOLID_NOT;
		setmodel(myflash, ""); 
		setsize(myflash, '0 0 0', '0 0 0');
		myflash.pflags = PFLAGS_FULLDYNAMIC|PFLAGS_NOSHADOW;
		myflash.light_lev = 350;
		myflash.color = '1.95 1.8 1.7'; //'1 1 1.5';
		myflash.skin = 237; 
		myflash.owner = self;
		myflash.classname = "flashlight";
		
		makevectors(self.v_angle);
		traceline(self.origin, self.origin + v_forward * 6 + v_up * 20, FALSE, self);
		setorigin(myflash, trace_endpos);
		self.angles = self.owner.angles;

		myflash.think = flashlight_update;
		myflash.nextthink = time + 0.02;
	}
};


void() flashlight_toggle =
{
	self.impulse = 0;
	local entity flashlight;

	if (self.flashlight_flag == FALSE)
	{       
		self.flashlight_flag = TRUE;
		flashlight_on();
	}
	else
	{
		for (flashlight = findchain(classname, "flashlight"); flashlight; flashlight = flashlight.chain) 
		{
			if (flashlight.owner == self)
			{
			   self.flashlight_flag = FALSE;
			   remove(flashlight);
			   return;
			}
		}
	}
};