


.float lastCull;
float() cullent_think = 
{  
	if(self.lastCull + 0.5 > time) return TRUE;
	self.lastCull = time;
	// self.effects = EF_NODRAW; 

	local vector center = (self.absmin + self.absmax) * 0.5;
	local float dist = vlen(center - other.origin);
	if(dist > cvar("scratch2"))
	{
		self.effects = EF_NODRAW; 
	}
	else 
	{
		self.effects = 0;
	}
	return TRUE;
};

void() OcclusionCullinInit =
{
	self.customizeentityforclient = cullent_think;
}

void() OcclusionCulling =
{
	if(!cvar("scratch2")) return;
	if(self.lastCull + 1 > time) return;
	if(clienttype(self) == CLIENTTYPE_BOT) return;
	self.lastCull = time;
	
	local entity cullent = find(world, classname, "func_wall");
	while (cullent != world)
	{
		cullent.customizeentityforclient = cullent_think;
		cullent = find(cullent, classname, "func_wall");
	}
}



float() light_think = 
{  
	if(self.lastCull + 0.5 > time) return TRUE;
	self.lastCull = time;
	
	float h = vlen([0, 0, self.origin_z] - [0, 0, other.origin_z]);
	print(ftos(h));
	print("\n");

	if(vlen(self.origin - other.origin) > cvar("scratch2") || h > 110)
	{
		self.effects = EF_NODRAW; 
		self.light_lev = 0;
	}
	else 
	{
		self.light_lev = 350;
		self.effects = 0;
	}
	return TRUE;
}

void() dlight =
{
	print("d1\n");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, ""); 
	setsize(self, '0 0 0', '0 0 0');
	self.pflags = PFLAGS_FULLDYNAMIC;
	self.customizeentityforclient = light_think;
	self.light_lev = 350;
	self.color = '0.95 0.8 0.7';
	// self.style = 2;
};