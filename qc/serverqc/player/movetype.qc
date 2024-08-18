
string runcmd = "cl_forwardspeed 225; cl_backspeed 90; cl_sidespeed 175;\n";
string walkcmd = "cl_forwardspeed 125; cl_backspeed 100; cl_sidespeed 100;\n";
string crouchcmd = "cl_forwardspeed 80; cl_backspeed 80; cl_sidespeed 80;\n";
void() Duck =
{
	if (clienttype(self) != CLIENTTYPE_BOT)
	{
		if(self.button3)
		{
			if(!self.duck)
			{
				self.duck = 1;
				setsize(self, DUCK_SIZE_MIN, DUCK_SIZE_MAX);
				self.view_ofs = '0 0 11';
				stuffcmd(self, crouchcmd);
			}
		}
		else
		{
			if(self.duck)
			{
				local vector tempvec = STAND_SIZE_MAX;
				tempvec_z = -tempvec_z;
				traceline(self.origin, self.origin - tempvec, FALSE, self);
				if(trace_fraction == 1)
				{
					traceline(self.origin, self.origin + STAND_SIZE_MAX, FALSE, self);
					if(trace_fraction == 1)
					{
						tracebox(self.origin, STAND_SIZE_MIN, STAND_SIZE_MAX, self.origin + '0 0 10', FALSE, self);
						if(trace_fraction == 1)
						{
							self.duck = 0;
							setsize(self, STAND_SIZE_MIN, STAND_SIZE_MAX);
							self.view_ofs = '0 0 23';
							if(self.walk) stuffcmd(self, runcmd);
							else stuffcmd(self, walkcmd);
						}
					}
				}
			}
		}
		if(self.button4 && !self.button0)
		{
			if(!self.duck && !self.walk)
			{
				self.walk = TRUE;
				stuffcmd(self, runcmd);
			}
		}
		else if(!self.duck && self.walk)
		{
			self.walk = FALSE;
			stuffcmd(self, walkcmd);
		}
	}
}