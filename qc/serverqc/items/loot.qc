


float LOOT_SPAWN_TIMER = 60;




///////////////////// LOOT ////////////


void(entity weap) SetWorldModel =
{
	if(weap.weapon == WP_AK74) setmodel (weap, AK74_WORLD_MODEL);
	else if(weap.weapon == WP_VAL) setmodel (weap, VAL_WORLD_MODEL);
	else if(weap.weapon == WP_MP5) setmodel (weap, MP5_WORLD_MODEL);
	else if(weap.weapon == WP_AKSU) setmodel (weap, AKSU_WORLD_MODEL);
	else if(weap.weapon == WP_SHOT) setmodel(weap, MOSS_WORLD_MODEL);
	else if(weap.weapon == WP_SPAS) setmodel(weap, SPAS_WORLD_MODEL);
	else if(weap.weapon == WP_VSS) setmodel(weap, VSS_WORLD_MODEL);
	else if(weap.weapon == WP_SVD) setmodel(weap, SVD_WORLD_MODEL);
	else if(weap.weapon == WP_GAUSS) setmodel(weap, GAUSS_WORLD_MODEL);
	return;	
};




float() RandomWeapon =
{
	local float rsnd = random_int(1, 9);
	if(rsnd == 1) return WP_VAL;
	else if(rsnd == 2) return WP_AKSU;
	else if(rsnd == 3) return WP_MP5;
	else if(rsnd == 4) return WP_SHOT;
	else if(rsnd == 5) return WP_SPAS;
	else if(rsnd == 6) return WP_VSS;
	else if(rsnd == 7) return WP_SVD;
	else if(rsnd == 8) return WP_GAUSS;
	else return WP_AK74;
}

void() info_weapon;
void() loot_spawner_think =
{
	local entity loot = spawn();
	loot.owner = self;
	loot.netname = "loot";
	loot.origin = self.origin;
	entity oldself = self;
	self = loot;
	
	self.weapon = RandomWeapon();
	self.currentammo = -1;
	if(self.weapon == WP_VAL) self.currentammo = 40;
	else if(self.weapon == WP_AK74) self.currentammo = 60;
	else if(self.weapon == WP_AKSU) self.currentammo = 60;
	else if(self.weapon == WP_MP5) self.currentammo = 60;
	else if(self.weapon == WP_SVD) self.currentammo = 20;
	else if(self.weapon == WP_VSS) self.currentammo =20;
	else if(self.weapon == WP_GAUSS) self.currentammo = 20;
	else if(self.weapon == WP_MOSS) self.currentammo = 20;
	else if(self.weapon == WP_SPAS) self.currentammo = 20;
	info_weapon();
	
	self = oldself;
	// bprint(self.hook.netname);
	// bprint("\n");
	// self.nextthink = time + LOOT_SPAWN_TIMER;
};

void() info_loot =
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = loot_spawner_think;
};

void() loot_touch =
{
	if(other.classname == "useprefab") other = other.owner;
	if(other.classname != "player") return;
	if(other.slot[3] && other.slot[4] && other.slot[3] != self.weapon && other.slot[4] != self.weapon) return;
	
	sound (other, CHAN_ITEM, "player/pickup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	
	other.weapons = other.weapons | self.weapon;
	if(other.slot[3] != self.weapon && other.slot[4] != self.weapon)
	{
		if(!other.slot[3]) 
		{
			other.slot[3] = self.weapon;
			other.impulse = 3;
		}
		else 
		{
			other.slot[4] = self.weapon;
			other.impulse = 4;
		}
	}
	
	if(self.currentammo > 0)
	{
		if(self.weapon == WP_VAL) other.VAL_AMMO = other.VAL_AMMO + self.currentammo;
		else if(self.weapon == WP_AK74) other.AK74_AMMO = other.AK74_AMMO + self.currentammo;
		else if(self.weapon == WP_AKSU) other.AK74_AMMO = other.AK74_AMMO + self.currentammo;
		else if(self.weapon == WP_MP5) other.MP5_AMMO = other.MP5_AMMO + self.currentammo;
		else if(self.weapon == WP_SVD) other.SVD_AMMO = other.SVD_AMMO + self.currentammo;
		else if(self.weapon == WP_VSS) other.VSS_AMMO = other.VSS_AMMO + self.currentammo;
		else if(self.weapon == WP_GAUSS) other.GAUSS_AMMO = other.GAUSS_AMMO + self.currentammo;
		else if(self.weapon == WP_MOSS) other.MOSS_AMMO = other.MOSS_AMMO + self.currentammo;
		else if(self.weapon == WP_SPAS) other.SPAS_AMMO = other.SPAS_AMMO + self.currentammo;
	}
	
	if(self.owner) self.owner.nextthink = time + LOOT_SPAWN_TIMER;
	remove(self);
};


void() info_weapon =
{
	SetWorldModel(self);
	self.netname = "weapon";
	self.touch = loot_touch;
	setsize (self, '-8 -8 0', '8 8 16');
	StartItem();
};


void() DropWeapon =
{
	self.impulse = 0;
	if(self.weapon == WP_KNIFE || self.weapon == WP_GRENADE || self.weapon == WP_PISTOL) return;
	
	local entity missile;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_TRIGGER;
	missile.classname = "weapon";
	makevectors (self.v_angle);
	missile.velocity = v_forward * random(100, 150);
	missile.avelocity = [0, random(100, 300), 0];
	missile.currentammo = 0;
	missile.currentClip = self.currentClip;
	missile.weapon = self.weapon;
	missile.nextthink = time + 0.5;
	missile.think = info_weapon;
	setorigin(missile, self.origin + v_up * 20);
	SetWorldModel(missile);
	setsize(missile, '-1 -1 -1', '1 1 1');
	
	CycleWeaponReverseCommand();
	if(self.slot[4] == missile.weapon) self.slot[4] = 0;
	else if(self.slot[3] == missile.weapon) self.slot[3] = 0;
	else if(self.slot[2] == missile.weapon) self.slot[2] = 0;
};