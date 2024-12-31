
float CheckIfButtonIsVisible(entity targ)
{
	vector spot1 = self.origin + self.view_ofs;
	vector spot2 = (targ.absmin + targ.absmax) * 0.5;
	traceline(spot1, spot2, 1, self); // Trace line, ignore monsters
	if (trace_ent == targ) return TRUE;
	return FALSE;
}

entity FindNearestEntityByClass(vector src, string clname)
{
	entity e, nearest;
	for (e = findchain(classname, clname); e; e = e.chain) 
	{
		if (!nearest)
		{
			nearest = e;
			continue;
		}
		
		vector center = (e.absmin + e.absmax) * 0.5;
		vector nearest_center = (nearest.absmin + nearest.absmax) * 0.5;
		if(CheckIfButtonIsVisible(e) && (vlen(center - src) < vlen(nearest_center - src))) nearest = e;
	}
	return nearest;
};

void PlayerTooltip()
{
	entity it = FindNearestEntityByClass(self.origin, "button");
	if(it)
	{
		vector center = (it.absmin + it.absmax) * 0.5;
		self.vec1 = center_x;
		self.vec2 = center_y;
		self.vec3 = center_z;
	}
	else 
	{
		self.vec1 = 0;
		self.vec2 = 0;
		self.vec3 = 0;
	}
}