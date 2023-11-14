
.string visible1, visible2, visible3, visible4, visible5, visible6;
string CULLING_CLASS = "func_wall_culled";



float isVectorInsideBoundingBox(vector vec, vector min1, vector max2) 
{
    // Check each dimension (x, y, z) individually
    if (vec_x < min1_x || vec_x > max2_x) {
        return FALSE;  // Vector is outside the bounding box along x-axis
    }

    if (vec_y < min1_y || vec_y > max2_y) {
        return FALSE;  // Vector is outside the bounding box along y-axis
    }

    if (vec_z < min1_z || vec_z > max2_z) {
        return FALSE;  // Vector is outside the bounding box along z-axis
    }

    return TRUE;  // Vector is inside the bounding box along all dimensions
}


float() cullent_think = 
{  
	if(self.lastTouch + 0.05 > time) return TRUE;
	self.lastTouch = time;
	
	//SMART ASS CULLING
	// if(isVectorInsideBoundingBox(other.origin, self.absmin, self.absmax))
	// {
		// self.effects = 0;
	// }
	// else
	// {
		// local vector center = (self.absmin + self.absmax) * 0.5;

		// makevectors(other.angles);
		// vector vec = normalize(center - other.origin);
		// float dot = vec * v_forward;

		// if(dot > 0.4)
		// {
			// local float dist = vlen(center - other.origin);
			// if(dist < 1500) self.effects = 0;
			// else self.effects = EF_NODRAW;
		// }
		// else self.effects = EF_NODRAW;
	// }
	
	
	//MANUAL CULLING FROM ENT FILE
	traceline(other.origin, other.origin - '0 0 64', TRUE, other);
	if (trace_ent == self)	
	{
		self.effects = 0;
		local entity head = find(world, classname, CULLING_CLASS);
		while (head)
		{
			if(head == self || 
			head.model == self.visible1 || head.model == self.visible2 || head.model == self.visible3 
			|| head.model == self.visible4 || head.model == self.visible5)
			{
				head.effects = 0;
			}
			else head.effects = EF_NODRAW; 
			
			
			head = find(head, classname, CULLING_CLASS);
		}
	}
	
	// traceline(other.origin, other.origin - '0 0 64', TRUE, other);
	// if (trace_ent == self)
	// {
		// self.effects = 0; 
		
		// local entity head = find(world, classname, "prop_brush");
		// while (head)
		// {
			// if(head == self || head.netname == self.netname || 
			// head.netname == self.visible1 || head.netname == self.visible2 || head.netname == self.visible3 
			// || head.netname == self.visible4 || head.netname == self.visible5)
			// {
				// head.effects = 0;
			// }
			// else head.effects = EF_NODRAW; 
			// print(head.netname, " ", self.netname, " ", self.visible1, "\n");
			// head = find(head, classname, "prop_brush");
		// }
		
	// }
	


	
	
	// if(isVectorInsideBoundingBox(other.origin, self.absmin, self.absmax)) self.effects = 0;
	// else 
	// {
		// local vector center = (self.absmin + self.absmax) * 0.5;
		
		// if(self.absmax_z + 100 < other.origin_z)
		// {
			// self.effects = EF_NODRAW; 
			// return TRUE;
		// }
		
		// vector corners[8];
		// corners[0] = self.absmin;                                      // Corner 1
		// corners[1] = [ self.absmax_x, self.absmin_y, self.absmin_z ];          // Corner 2
		// corners[2] = [ self.absmin_x, self.absmax_y, self.absmin_z ];          // Corner 3
		// corners[3] = [ self.absmax_x, self.absmax_y, self.absmin_z ];          // Corner 4
		// corners[4] = [ self.absmin_x, self.absmin_y, self.absmax_z ];          // Corner 5
		// corners[5] = [ self.absmax_x, self.absmin_y, self.absmax_z ];          // Corner 6
		// corners[6] = [ self.absmin_x, self.absmax_y, self.absmax_z ];          // Corner 7
		// corners[7] = self.absmax; 
		// for(float i = 0; i < 7; i++)
		// {
			// local float dist = vlen(corners[7] - other.origin);
			// if(dist > cvar("scratch2"))
			// {
				// self.effects = EF_NODRAW; 
			// }
			// else 
			// {
				// self.effects = 0;
				// return TRUE;
			// }
		// }
	// }
	
	// if(isVectorInsideBoundingBox(other.origin, self.absmin, self.absmax)) self.effects = 0;
	// else 
	// {
		// local float dist = vlen(center - other.origin);
		// local float dist2 = vlen(self.absmin - other.origin);
		// local float dist3 = vlen(self.absmax - other.origin);
		// if(dist > cvar("scratch2") && dist2 > cvar("scratch2") && dist3 > cvar("scratch2"))
		// {
			// self.effects = EF_NODRAW; 
		// }
		// else 
		// {
			// self.effects = 0;
		// }
	// }

	
	return TRUE;
};

void() OcclusionCullinInit =
{
	self.customizeentityforclient = cullent_think;
}

void() func_wall_culled =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	OcclusionCullinInit();
};
