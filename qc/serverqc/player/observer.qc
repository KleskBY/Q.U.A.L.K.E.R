

void() PutObserverInServer =
{
	local entity spot;

	spot = SelectSpawnPoint();

	self.classname = "observer";
	self.health = 666;		//Otherwise if health < 0 death logic takes controll and pushes play undergorund	
	self.takedamage = DAMAGE_NO;  
	self.solid = SOLID_NOT;       	
	self.movetype = MOVETYPE_NOCLIP;
	self.show_hostile = 0;			
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.invincible_time = 0;
	self.effects = 0;
	

	self.items = IT_QUAD; //blue effect
	self.weapon = 0;
	self.currentammo =  0;
	self.weaponmodel = "";
	for(float i = 0; i < SLOT_AMOUNT; i++)
	{
		self.slot[i] = 0;
	}

	W_SetCurrentAmmo();

	self.attack_finished = time;	
	self.deadflag = DEAD_NO;
	self.pausetime = 0; 	// pausetime is set by teleporters to keep the player from moving a while
	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately

	setcolor(self, -1); //set team
	setmodel (self, ""); 

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 23';
	self.viewzoom = 1;

	PlayerThink();
	
	SelectNone();
};