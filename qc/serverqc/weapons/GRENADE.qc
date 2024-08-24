float GRENADE_DAMAGE = 135;
float GRENADE_MAX_CLIP = 8;
float GRENADE_RATE = 0.85;
float GRENADE_SEMI = 1;
float GRENADE_DISTANCE = 1024;
.float GRENADE_AMMO = ammoGrenades;
.float GRENADE_CLIP;
.float GRENADE_PICKUP;
float GRENADE_ITEM = IT_ROCKETS;

float GRENADE_RELOAD_START_FRAME = 84;
float GRENADE_RELOAD_END_FRAME = 112;
float GRENADE_DRAW_START_FRAME = 1;
float GRENADE_DRAW_END_FRAME = 32;
float GRENADE_ATTACK_START_FRAME = 33;
float GRENADE_ATTACK_END_FRAME = 83;
float GRENADE_FRAMERATE = 0.02;

string GRENADE_VIEW_MODEL = "models/weapons/v_he.md3";
string GRENADE_WORLD_MODEL = "models/weapons/w_he.md3";
string GRENADE_PLAYER_MODEL = "models/player.md3";
string GRENADE_FIRE_SOUND = "weapons/grenade/explosion.wav";
string GRENADE_PIN_SOUND = "weapons/grenade/pinpull.wav";
string GRENADE_HIT_SOUND = "weapons/grenade/hit.wav";

//////////////////////////// EXPLODE ////////////////////////////


void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, GRENADE_DAMAGE, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	local vector shrapdir;
	local float i;
	for (i = 0; i < 17; i = i+1)	
	{
      shrapdir_x = 0 - (random(-1,1) * 200);
      shrapdir_y = 0 - (random(-1,1) * 200);
      shrapdir_z = (random(-1,1) * 200);
      ShootShrapnel(self.origin , shrapdir);
	}

	sound (self, CHAN_WEAPON, GRENADE_FIRE_SOUND, 1, SoundRadius(3500));
	remove(self);
};



//////////////////////////// FIRE ///////////////////////////////

void() GRENADE_Touch =
{
	if (other == self.owner) return;		// don't explode on owner
	if(other.classname ==  "breakable")
	{
		T_Damage (other, self, self, 5);
		pointparticles(particleeffectnum("nailgun_muzzleflash"), self.origin, self.velocity * 50, 1);
	}
	sound (self, CHAN_WEAPON, GRENADE_HIT_SOUND, 1, ATTN_NORM);
	if (self.velocity == '0 0 0') self.avelocity = '0 0 0';
};

void() GRENADE_Fire = 
{
	self.GRENADE_AMMO = self.GRENADE_AMMO - 1;
	self.currentammo = self.GRENADE_AMMO;
	self.punchangle_x = -2;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.bouncefactor = 0.4;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "grenade";
	makevectors (self.v_angle);
	if (self.v_angle_x) newmis.velocity = v_forward * (25 * self.grenadetime) + v_up * 100 + (2*(random() - 0.5)) * v_right*10 + (2*(random() - 0.5)) *v_up*30;
	else
	{
		newmis.velocity = aim(self, 10000);
        newmis.velocity = newmis.velocity * 20 * self.grenadetime;
		newmis.velocity_z = 30;
	}
	newmis.avelocity = '300 300 300';
	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = GRENADE_Touch;
	newmis.nextthink = time + 3;
	newmis.think = GrenadeExplode;
	newmis.search_time = time + 3.0;
	newmis.nextthink   = time + 1.5; //Delay
    setmodel (newmis, GRENADE_WORLD_MODEL);
	setsize (newmis, '0 0 0', '1 1 1');
	setorigin (newmis, self.origin - (v_right * -6) + (v_up * 11));
	if(self.currentammo == 0) CycleWeaponReverseCommand();
	self.grenadetime = 0;
};


////////////////////////// ATTACK //////////////////////////////

void() GRENADE_Attack4
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + GRENADE_FRAMERATE;
	if (self.weaponframe == 90) GRENADE_Fire();
	if (self.weaponframe >= GRENADE_RELOAD_END_FRAME) self.think = PlayerThink;
}

void() GRENADE_Attack3 //charge (hold)
{
	self.nextthink = time + GRENADE_FRAMERATE;
	self.attack_finished = time + GRENADE_FRAMERATE;
	if (self.button0)
	{
		if (self.grenadetime <= 40)
		{
			self.grenadetime = self.grenadetime + GRENADE_FRAMERATE * 15; 
			local string temp;
			local float power;
			power = ((self.grenadetime-10) / 30) *100;
			temp = ftos(power);
			temp = substring(temp,0,strstrofs(temp, ".", 0));
			temp = strcat(temp, "%");
			centerprint (self, temp);
		}
	}
	else self.think = GRENADE_Attack4;
}

void() GRENADE_Attack2 //pin pull
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + GRENADE_FRAMERATE;
	if (self.weaponframe == 50) sound(self, CHAN_WEAPON, GRENADE_PIN_SOUND, 1, ATTN_NORM);
	if (self.weaponframe >= GRENADE_ATTACK_END_FRAME) self.think = GRENADE_Attack3;
}

void() GRENADE_Attack
{
	if(GRENADE_SEMI && self.ShootsFired != 0) return;
	if(self.GRENADE_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.grenadetime = 10;
	self.attack_finished = time + GRENADE_RATE;
	self.weaponframe = GRENADE_ATTACK_START_FRAME;
	self.nextthink = time + GRENADE_FRAMERATE;
	self.think = GRENADE_Attack2;
	self.ShootsFired = self.ShootsFired + 1;
}

///////////////// WEAPON CHANGE ///////////////////

void() GRENADE_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + GRENADE_FRAMERATE;
	self.currentammo =  self.GRENADE_AMMO;
	if(self.weaponframe >= GRENADE_DRAW_END_FRAME)
	{
		self.think = PlayerThink;
		self.reload = 0;
	}
};

void() GRENADE_Switch
{
	if(!self.GRENADE_PICKUP)
	{
		self.GRENADE_PICKUP = TRUE;
		self.GRENADE_CLIP = GRENADE_MAX_CLIP;
	}
	self.weaponframe = GRENADE_DRAW_START_FRAME;
	self.nextthink = time + GRENADE_FRAMERATE;
	self.think = GRENADE_Switch2;
	self.reload = 1;
	self.currentammo = self.GRENADE_AMMO;
};

/////////////////////// SELECT //////////////////////

void() GRENADE_Select =
{
	self.currentClip = self.GRENADE_CLIP;
	self.currentammo = self.GRENADE_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = GRENADE_VIEW_MODEL;
	if(self.currentammo == 0) self.weaponmodel = "";
	setmodel(self, GRENADE_PLAYER_MODEL);
	self.items = (self.items | GRENADE_ITEM);
	self.weaponSwitch = GRENADE_Switch;
	self.weaponAttack = GRENADE_Attack;
	self.weaponReload = SUB_Null;
	self.weaponSelect = GRENADE_Select;
	SetGun(GRENADE_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() GRENADE_Precache =
{
	precache_model(GRENADE_VIEW_MODEL);
	precache_model(GRENADE_PLAYER_MODEL);
	precache_model(GRENADE_WORLD_MODEL);
	precache_sound(GRENADE_FIRE_SOUND);
	precache_sound(GRENADE_PIN_SOUND);
	precache_sound(GRENADE_HIT_SOUND);
};


