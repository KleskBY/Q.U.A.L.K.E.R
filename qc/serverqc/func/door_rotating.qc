
void() door_open;

float(entity targ) infrontofdoor =
{
	float sign = 1;
	float loX = self.mins_x + self.origin_x;
	float loY = self.mins_y + self.origin_y;

	float hiX = self.maxs_x + self.origin_x;
	float hiY = self.maxs_y + self.origin_y;

	float momentArmX = targ.origin_x - self.origin_x;
	float momentArmY = targ.origin_y - self.origin_y;
	if (loX > targ.origin_x)
	{
		if (targ.origin_y < loY)
		{
			if (fabs(momentArmY) > fabs(momentArmX))
				sign = (momentArmY < 0) ? 1 : -1;
			else
				sign = (momentArmX > 0) ? 1 : -1;
		}
		else if (targ.origin_y > hiY)
		{
			if (fabs(momentArmY) > fabs(momentArmX))
				sign = (momentArmY < 0) ? 1 : -1;
			else
				sign = (momentArmX < 0) ? 1 : -1;
		}
		else
			sign = (momentArmY < 0) ? 1 : -1;
	}
	else
	{
		if (targ.origin_x <= hiX)
		{
			if (targ.origin_y < loY)
				sign = (momentArmX > 0) ? 1 : -1;
			else if (targ.origin_y > hiY)
				sign = (momentArmX < 0) ? 1 : -1;
		}
		else if (targ.origin_y < loY)
		{
			if (fabs(momentArmY) > fabs(momentArmX))
				sign = (momentArmY > 0) ? 1 : -1;
			else
				sign = (momentArmX > 0) ? 1 : -1;
		}
		else if (targ.origin_y > hiY)
		{
			if (fabs(momentArmY) > fabs(momentArmX))
				sign = (momentArmY > 0) ? 1 : -1;
			else
				sign = (momentArmX < 0) ? 1 : -1;
		}
		else
			sign = (momentArmY > 0) ? 1 : -1;
	}
	
	if(sign == 1) return TRUE;
	else return FALSE;
};


void() door_closed =
{
   self.avelocity = '0 0 0';
   self.state = 0;
   self.nextthink = self.ltime + 99999;
   sound (self, CHAN_VOICE, self.noise3, 1, ATTN_IDLE);
   self.touch = door_open;
};

void() door_closing =
{
	self.nextthink = self.ltime + (1 / self.speed);
	self.think = door_closed;

	self.avelocity = [0, 90 * -self.speed, 0];
	if (self.lefty) self.avelocity = -self.avelocity; //reverse

	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_IDLE); 
};


void() door_opened =
{
	if (!self.targetname)
	{
		self.avelocity = '0 0 0';
		self.nextthink = self.ltime + 2;
		self.think = door_closing;
	}
};

void() door_opening =
{
	self.nextthink = self.ltime + (1 / self.speed);
	self.think = door_opened;

	self.avelocity = [0, 90 * self.speed, 0];
	if (self.lefty) self.avelocity = -self.avelocity; //reverse
};




void() door_open =
{
    self.avelocity = '0 0 0';
    self.touch = SUB_Null;

	if(self.spawnflags == 0)
	{
		if (!infrontofdoor(other)) self.lefty = 1; //reverse
		if (infrontofdoor(other)) self.lefty = 0;
	}
	if(self.spawnflags == 1) self.lefty = 0;
	if(self.spawnflags == 2) self.lefty = 1; //reverse

	if (self.state == 0)
	{
		self.state = 1;
		door_opening();
		sound (self, CHAN_BODY, self.noise1, 1, ATTN_IDLE);
	}
};



void() func_door_rotating =
{
  	if (self.sounds == 0)
	{
		precache_sound ("misc/null.wav");
		self.noise1 = "misc/null.wav";
		self.noise2 = "misc/null.wav";
		self.noise3 = "misc/null.wav";
	}
	if (self.sounds == 1)
	{
		precache_sound("func/door_start.wav");
		precache_sound("func/door_closing.wav");
		precache_sound("func/door_stop.wav");
		self.noise1 = "func/door_start.wav";
		self.noise2 = "func/door_closing.wav";
		self.noise3 = "func/door_stop.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound("func/doorstop2.wav");
		self.noise1 = "func/doorstop2.wav";
		self.noise2 = "func/doorstop2.wav";
		self.noise3 = "misc/null.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound("func/doorstop3.wav");
		self.noise1 = "func/doorstop3.wav";
		self.noise2 = "func/doorstop3.wav";
		self.noise3 = "misc/null.wav";
	}
	if (self.sounds == 4)
	{
		precache_sound("func/doorstop4.wav");
		precache_sound("func/doormove4.wav");
		self.noise1 = "func/doorstop4.wav";
		self.noise2 = "func/doormove4.wav";
		self.noise3 = "misc/null.wav";
	}
       
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	self.classname = "func_door_rotating";
	setsize (self, self.mins, self.maxs);
	self.state = 0;

	if (!self.targetname) self.touch = door_open;

	self.nextthink = self.ltime + 99999;
	self.think = door_open;

	if (!self.speed) self.speed = 10;
	if (!self.wait) self.wait = 0.1;
	if (self.targetname) self.use = door_open;
};
