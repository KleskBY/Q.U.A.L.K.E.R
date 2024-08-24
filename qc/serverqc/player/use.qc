

void() PlayerUse =
{
	if(!self.buttonuse) return;

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_TRIGGER;
	newmis.classname = "useprefab";
	newmis.bouncefactor = 0;

	makevectors(self.v_angle);
	newmis.velocity = v_forward * 1000;
	
	newmis.nextthink = time + 0.1;
	newmis.think = SUB_Remove;
	
	newmis.angles = self.v_angle;
	setsize(newmis, '-1 -1 -1', '1 1 1');
	setorigin(newmis, self.origin + self.view_ofs);
	
}