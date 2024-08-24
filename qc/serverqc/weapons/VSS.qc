float VSS_DAMAGE = 90;
float VSS_MAX_CLIP = 10;
float VSS_RATE = 0.1;
float VSS_SEMI = 0;
float VSS_DISTANCE = 8192;
.float VSS_AMMO = ammo9x39;
.float VSS_CLIP;
.float VSS_PICKUP;

float VSS_RELOAD_START_FRAME = 1;
float VSS_RELOAD_END_FRAME = 152;
float VSS_DRAW_START_FRAME = 95;
float VSS_DRAW_END_FRAME = 152;
float VSS_ATTACK_START_FRAME = 224;
float VSS_ATTACK_END_FRAME = 247;
float VSS_FRAMERATE = 0.015;

string VSS_VIEW_MODEL = "models/weapons/v_vss.md3";
string VSS_PLAYER_MODEL = "models/player.md3";
string VSS_WORLD_MODEL = "models/weapons/w_vss.md3";

string VSS_FIRE_SOUND = "weapons/vss/shot.wav";
string VSS_CLIPIN_SOUND = "weapons/vss/clipin.wav";
string VSS_CLIPOUT_SOUND = "weapons/vss/clipout.wav";
string VSS_SLIDE1_SOUND = "weapons/vss/bolt.wav";
string VSS_SLIDE2_SOUND = "weapons/sniper/boltrelease.wav";
string VSS_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() VSS_Fire = 
{
	self.VSS_CLIP = self.VSS_CLIP - 1;
	self.currentClip = self.VSS_CLIP;
	
	fireBullet(Spread('20 20 0'), VSS_DISTANCE, VSS_DAMAGE);
	
	self.punchangle_x = random(-3, -6);
	self.punchangle_y = random(2, -2);
	self.punchangle_z = random(-1, 1);
	
	sound (self, CHAN_WEAPON, VSS_FIRE_SOUND, 1, SoundRadius(1700));
	if(self.state == STATE_AIM)
	{
		pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_right * 6 + v_forward * 35 + v_up * -4, self.velocity * 50, 1);
		MuzzleFlash('55 -9 -7', 2);
	}
	EjectShell(self.origin + self.view_ofs + v_up * -13 + v_forward * 19 + v_right * 8, "models/shells/rifleShell.md3");	
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////


void() VSS_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + VSS_FRAMERATE;
	
	if (self.weaponframe == 35) sound(self, CHAN_WEAPON, VSS_CLIPOUT_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 85) sound(self, CHAN_WEAPON, VSS_CLIPIN_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 111) sound(self, CHAN_WEAPON, VSS_SLIDE1_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe >= VSS_RELOAD_END_FRAME) FinishReload(VSS_AMMO, VSS_CLIP, VSS_MAX_CLIP);
};

void() VSS_Reload
{
	self.currentClip = self.VSS_CLIP;
	if(self.VSS_CLIP >= VSS_MAX_CLIP) return;
	if(self.VSS_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = VSS_RELOAD_START_FRAME;
	self.nextthink = time + VSS_FRAMERATE;
	self.think = VSS_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, VSS_NOAMMO_SOUND, 1, ATTN_NORM);
}


////////////////////////// ATTACK //////////////////////////////

void() VSS_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + VSS_FRAMERATE;
	if(self.weaponframe >= VSS_ATTACK_END_FRAME) self.think = PlayerThink;
	else self.think = VSS_Attack2;
}

void() VSS_Attack
{
	if(VSS_SEMI && self.ShootsFired != 0) return;
	if(self.VSS_AMMO <= 0 && self.VSS_CLIP <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.VSS_CLIP > 0) 
	{
		self.attack_finished = time + VSS_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = VSS_ATTACK_START_FRAME;
		self.nextthink = time + VSS_FRAMERATE;
		VSS_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = VSS_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, VSS_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = PlayerThink;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() VSS_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + VSS_FRAMERATE;
	self.currentammo =  self.VSS_AMMO;
	if(self.weaponframe >= VSS_DRAW_END_FRAME)
	{
		self.think = PlayerThink;
		self.reload = 0;
	}
};

void() VSS_Switch
{
	if(!self.VSS_PICKUP)
	{
		self.VSS_PICKUP = TRUE;
		self.VSS_CLIP = VSS_MAX_CLIP;
	}
	self.weaponframe = VSS_DRAW_START_FRAME;
	self.nextthink = time + VSS_FRAMERATE;
	self.think = VSS_Switch2;
	self.reload = 1;
	self.currentammo = self.VSS_AMMO;
};

/////////////////////// SELECT //////////////////////

void() VSS_Select =
{
	self.currentClip = self.VSS_CLIP;
	self.currentammo = self.VSS_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = VSS_VIEW_MODEL;
	setmodel (self, VSS_PLAYER_MODEL);
	self.weaponSwitch = VSS_Switch;
	self.weaponAttack = VSS_Attack;
	self.weaponReload = VSS_Reload;
	self.weaponSelect = VSS_Select;
	SetGun(VSS_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() VSS_Precache =
{
	precache_model(VSS_VIEW_MODEL);
	precache_model(VSS_PLAYER_MODEL);
	precache_model(VSS_WORLD_MODEL);
	precache_sound(VSS_FIRE_SOUND);
	precache_sound(VSS_CLIPIN_SOUND);
	precache_sound(VSS_CLIPOUT_SOUND);
	precache_sound(VSS_NOAMMO_SOUND);
	precache_sound(VSS_SLIDE1_SOUND);
	precache_sound(VSS_SLIDE2_SOUND);
};


