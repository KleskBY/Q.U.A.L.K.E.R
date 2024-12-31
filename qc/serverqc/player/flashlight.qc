

.entity flashlight;

void flashlight_think2()
{
	if (self.owner.view_ofs == '0 0 0' || self.owner.health <= 0) 
	{
		self.think = SUB_Remove;
		self.owner.flashlight = world;
	}
	
	makevectors(self.owner.v_angle);
	setorigin(self, self.owner.origin + v_forward * 6 + self.owner.view_ofs - v_up * 2);
	// setorigin (self, trace_endpos + '0 0 10');
	self.angles_x = -(self.owner.v_angle_x - 180);
	self.angles_y = self.owner.v_angle_y;
	self.angles_z = self.owner.v_angle_z;
	
	self.v_angle_x = self.owner.v_angle_x;
	
	self.nextthink = time + 0.01;
};

void flashlight_think()
{
	if (self.owner.view_ofs == '0 0 0' || self.owner.health <= 0) 
	{
		self.think = SUB_Remove;
		self.owner.flashlight = world;
	}
	
	self.v_angle_x = self.owner.v_angle_x;
	self.nextthink = time + 0.01;
};

void FlashlightEnable()
{	
	self.flashlight = spawn();

	setmodel(self.flashlight, ""); 
	setsize(self.flashlight, '0 0 0', '0 0 0');
	self.flashlight.pflags = PFLAGS_FULLDYNAMIC|PFLAGS_NOSHADOW;
	self.flashlight.light_lev = 350;
	self.flashlight.color = '1.95 1.8 1.7'; //'1 1 1.5';
	self.flashlight.skin = 237; //cubemap texture
	self.flashlight.owner = self;
	self.flashlight.classname = "flashlight";
	
	self.flashlight.movetype = MOVETYPE_FOLLOW;
	self.flashlight.solid = SOLID_NOT;
	self.flashlight.aiment = self;
	self.flashlight.v_angle_y = 180;
	self.flashlight.v_angle_x = self.v_angle_x;
	
	// self.flashlight.movetype = MOVETYPE_NONE;
	// self.flashlight.solid = SOLID_NOT;
	// self.flashlight.aiment = self;
	// self.flashlight.v_angle = '0 180 0';
	
	// makevectors(self.v_angle);
	// setorigin(self.flashlight, self.origin + v_forward * 6 + self.owner.view_ofs - v_up * 2);

	self.flashlight.think = flashlight_think;
	self.flashlight.nextthink = time + 0.1;
};


void FlashlightToggle()
{
	if(self.classname != "player") return;
	if(!IsAllive(self)) return;
	if (self.flashlight)
	{
		remove(self.flashlight);
		self.flashlight = world;
	}
	else
	{
		FlashlightEnable();
	}
};