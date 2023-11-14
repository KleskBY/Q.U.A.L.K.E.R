
.float cullingDist;

float CULL_DIST = 1500;
.float lastCull;
float isVectorInsideBoundingBox(vector vec, vector min1, vector max2) 
{
    if (vec_x < min1_x || vec_x > max2_x) return FALSE;  // Vector is outside the bounding box along x-axis
    if (vec_y < min1_y || vec_y > max2_y) return FALSE;  // Vector is outside the bounding box along y-axis
    if (vec_z < min1_z || vec_z > max2_z) return FALSE;  // Vector is outside the bounding box along z-axis
    return TRUE;  // Vector is inside the bounding box along all dimensions
}


float() cullent_think = 
{  
	if(self.lastCull + 0.05 > time) return TRUE;
	self.lastCull = time;
	
	if(isVectorInsideBoundingBox(other.origin, self.absmin, self.absmax))
	{
		self.effects = 0;
	}
	else
	{
		local vector center = (self.absmin + self.absmax) * 0.5;

		makevectors(other.angles);
		vector vec = normalize(center - other.origin);
		float dot = vec * v_forward;

		if(dot > 0.25)
		{
			float dist = vlen(center - other.origin);
			if(dist < CULL_DIST) self.effects = 0;
			else self.effects = EF_NODRAW;
		}
		else self.effects = EF_NODRAW;
	}
	return TRUE;
};


void() func_wall_culled =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.customizeentityforclient = cullent_think;
};
