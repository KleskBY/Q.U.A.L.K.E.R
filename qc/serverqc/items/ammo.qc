
/*
===============================================================================

AMMO

===============================================================================
*/

void() ammo_touch =
{
	local entity stemp;

	if (other.classname == "useprefab") other = other.owner;
	if (other.classname != "player" ) return;
	if (other.health <= 0) return;
	other.picked_items = other.picked_items + 1;


	other.ammo9x18 += self.ammo9x18;
	other.ammo9x19 += self.ammo9x19;
	other.ammo9x39 += self.ammo9x39;
	other.ammo545x39 += self.ammo545x39;
	other.ammo762x54 += self.ammo762x54;
	other.ammoShells += self.ammoShells;
	other.ammoGrenades += self.ammoGrenades;
	other.ammoBat += self.ammoBat;


	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, " ammo\n");
	
	sound (other, CHAN_ITEM, "player/pickup.wav", 1, SoundRadius(400));
	stuffcmd (other, "bf\n");

	if(!other.reload && !other.hgrenade)
	{
	// if changed current ammo, update it
		stemp = self;
		self = other;
		W_SetCurrentAmmo();
		self = stemp;
	}

	// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1) self.nextthink = time + 30;
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() item_shells =
{
	self.touch = ammo_touch;

	precache_model("models/items/shotgunammo.md3");
	setmodel (self, "models/items/shotgunammo.md3");
	self.ammoShells = 20;
	self.netname = "shells";
	setsize(self, '-18 -18 0', '18 18 56');
	StartItem();
};
