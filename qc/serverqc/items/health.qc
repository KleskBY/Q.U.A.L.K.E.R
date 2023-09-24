/*
=========================================================================

HEALTH BOX

=========================================================================
*/
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float healamount, float ignore) T_Heal =
{
	if (e.health <= 0) return 0;
	if ((!ignore) && (e.health >= e.max_health)) return 0;
	healamount = ceil(healamount);
	e.health = e.health + healamount;
	if ((!ignore) && (e.health >= e.max_health)) e.health = e.max_health;
	if (e.health > 250) e.health = 250;
	return 1;
};

void() health_touch =
{
	if (other.classname != "player") return;
	if (other.medkits >= 5) return;
	other.medkits = other.medkits + 1;
	other.picked_items = other.picked_items + 1;
	sprint(other, "You found a medkit\n");
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.model = string_null;
	self.solid = SOLID_NOT;
	
	activator = other;
	SUB_UseTargets();
};	

void() item_health =
{	
	self.touch = health_touch;	
	precache_model2("models/items/medkit.md3");
	setmodel(self, "models/items/medkit.md3");
	precache_sound("player/pickup.wav");
	self.noise = "player/pickup.wav";

	
	setsize(self, '-6 -6 0', '6 6 56');
	StartItem();
};


void() player_run;
void CycleWeaponReverseCommand();
void CycleWeaponCommand();
void() player_heal = 
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + 0.025;
	self.think = player_heal;
	
	self.reload = TRUE;
	self.blockSwitch = TRUE;
	if(self.weaponframe == 60) 
	{
		sound(self, CHAN_AUTO, "player/heal.wav", random(0.3, 0.8), SoundRadius(400));
		stuffcmd (self, "bf .1 .6 .1\n");
	}
	if(self.weaponframe > 70 && self.weaponframe & 2 == 0)
	{
		T_Heal(self, 1, 0);
	}
	if(self.weaponframe > 120)
	{
		self.reload = FALSE;
		self.blockSwitch = FALSE;
		self.think = player_run;
		self.weaponSelect();
		self.weaponSwitch();
		// CycleWeaponReverseCommand();
		// CycleWeaponCommand();
	}
	

};

void() Heal =
{
	self.impulse = 0;
	if(!allive(self)) return;
	if(self.health >= 100) return;
	if(self.medkits <= 0) return;
	if(self.think == player_heal) return;
	self.medkits = self.medkits - 1;
	
	self.weaponmodel = "models/weapons/v_med.md3";
	setmodel(self.viewmodel, self.weaponmodel);
	sound(self, CHAN_AUTO, "player/switch.wav", random(0.3, 0.8), SoundRadius(400));
	
	self.think = player_heal;
	self.nextthink = time + 0.03;
};