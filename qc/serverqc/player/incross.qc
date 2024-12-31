
float INCROSS_NONE = 0;
float INCROSS_ENEMY = 1;
float INCROSS_FRIEND = 2;

void() PlayerInCross =
{
	makevectors(self.v_angle);
	vector src = self.origin + self.view_ofs; 
	traceline(src, src + v_forward * 1024, FALSE, self);
	if (trace_fraction != 1.0)
	{
		if (trace_ent.classname == "player") 
		{	
			centerprint(self, trace_ent.netname);
			if(coop) self.incross = INCROSS_FRIEND;
			else self.incross = INCROSS_ENEMY;
			return;
		}
		if (trace_ent.takedamage && (trace_ent.alpha == 0 || trace_ent.alpha >= 0.75))
		{
			self.incross = INCROSS_ENEMY;
			return;
		}
	}
	self.incross = INCROSS_NONE;
}