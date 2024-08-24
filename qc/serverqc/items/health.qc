
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
	precache_model("models/items/medkit.md3");
	setmodel(self, "models/items/medkit.md3");
	precache_sound("player/pickup.wav");
	self.noise = "player/pickup.wav";

	
	setsize(self, '-6 -6 0', '6 6 56');
	StartItem();
};