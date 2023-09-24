float MP5_DAMAGE = 35;
float MP5_MAX_CLIP = 30;
float MP5_RATE = 0.08;
float MP5_SEMI = 0;
float MP5_DISTANCE = 4096;
// string MP5_AMMO = "5.45x39 Ammo";
.float MP5_AMMO = ammo9x19;
.float MP5_CLIP;
.float MP5_PICKUP;

float MP5_RELOAD_START_FRAME = 3;
float MP5_RELOAD_END_FRAME = 88;
float MP5_DRAW_START_FRAME = 89;
float MP5_DRAW_END_FRAME = 115;
float MP5_ATTACK_START_FRAME = 116;
float MP5_ATTACK_END_FRAME = 133;
float MP5_FRAMERATE = 0.025;

string MP5_VIEW_MODEL = "models/weapons/v_mp5.md3";
string MP5_PLAYER_MODEL = "models/player.md3";
string MP5_WORLD_MODEL = "models/weapons/w_mp5.md3";

string MP5_FIRE_SOUND = "weapons/mp5/shot.wav";
string MP5_CLIPIN_SOUND = "weapons/mp5/clipin.wav";
string MP5_CLIPOUT_SOUND = "weapons/mp5/clipout.wav";
string MP5_SLIDE1_SOUND = "weapons/mp5/bolt.wav";
string MP5_SLIDE2_SOUND = "weapons/sniper/boltrelease.wav";
string MP5_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() MP5_Fire = 
{
	self.MP5_CLIP = self.MP5_CLIP - 1;
	self.currentClip = self.MP5_CLIP;
	
	local vector spread = Spread('24 25 0');
	fireBullet(spread, MP5_DISTANCE, MP5_DAMAGE);
	
	self.punchangle_x = random(1.5, -1.5);
	self.punchangle_y = random(2, -2);
	
	sound (self, CHAN_WEAPON, MP5_FIRE_SOUND, 1, SoundRadius(2500));
	
	MuzzleFlash(self.viewmodel.origin + '38 -8 -5.5', 2);
	pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -5 + v_forward * 30 + v_right * 6, self.velocity * 50, 1);
	eject_shell (self.origin + self.view_ofs + v_up * -12 + v_forward * 24 - v_right * -10, "models/shells/pistolShell.md3");
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////

void() MP5_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + MP5_FRAMERATE;
	
	if (self.weaponframe == 12) sound(self, CHAN_WEAPON, MP5_SLIDE1_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 35) sound(self, CHAN_WEAPON, MP5_CLIPOUT_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 52) sound(self, CHAN_WEAPON, MP5_CLIPIN_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 67) sound(self, CHAN_WEAPON, MP5_SLIDE1_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe >= MP5_RELOAD_END_FRAME) FinishReload(MP5_AMMO, MP5_CLIP, MP5_MAX_CLIP);
};

void() MP5_Reload
{
	self.currentClip = self.MP5_CLIP;
	if(self.MP5_CLIP >= MP5_MAX_CLIP + 1) return;
	if(self.MP5_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = MP5_RELOAD_START_FRAME;
	self.nextthink = time + MP5_FRAMERATE;
	self.think = MP5_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, MP5_NOAMMO_SOUND, 1, ATTN_NORM);
}


////////////////////////// ATTACK //////////////////////////////

void() MP5_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + MP5_FRAMERATE;
	if(self.weaponframe >= MP5_ATTACK_END_FRAME) self.think = player_run;
	else self.think = MP5_Attack2;
}

void() MP5_Attack
{
	if(MP5_SEMI && self.ShootsFired != 0) return;
	if(self.MP5_AMMO <= 0 && self.MP5_CLIP <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.MP5_CLIP  > 0) 
	{
		self.attack_finished = time + MP5_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = MP5_ATTACK_START_FRAME;
		self.nextthink = time + MP5_FRAMERATE;
		MP5_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = MP5_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, MP5_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = player_run;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() MP5_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + MP5_FRAMERATE;
	self.currentammo = self.MP5_AMMO;
	if(self.weaponframe >= MP5_DRAW_END_FRAME)
	{
		self.think = player_run;
		self.reload = 0;
	}
};

void() MP5_Switch
{
	if(!self.MP5_PICKUP)
	{
		self.MP5_PICKUP = TRUE;
		self.MP5_CLIP = MP5_MAX_CLIP;
	}
	self.weaponframe = MP5_DRAW_START_FRAME;
	self.nextthink = time + MP5_FRAMERATE;
	self.think = MP5_Switch2;
	self.reload = 1;
	self.currentammo = self.MP5_AMMO;
};

/////////////////////// SELECT //////////////////////

void() MP5_Select =
{
	self.currentClip = self.MP5_CLIP;
	self.currentammo = self.MP5_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = MP5_VIEW_MODEL;
	setmodel (self, MP5_PLAYER_MODEL);
	if(self.duck) setsize(self, DUCK_SIZE_MIN, DUCK_SIZE_MAX);
	else setsize (self, STAND_SIZE_MIN, STAND_SIZE_MAX);
	self.weaponSwitch = MP5_Switch;
	self.weaponAttack = MP5_Attack;
	self.weaponReload = MP5_Reload;
	self.weaponSelect = MP5_Select;
	SetGun(MP5_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() MP5_Precache =
{
	precache_model2(MP5_VIEW_MODEL);
	precache_model2(MP5_PLAYER_MODEL);
	precache_model2(MP5_WORLD_MODEL);
	precache_sound2(MP5_FIRE_SOUND);
	precache_sound2(MP5_CLIPIN_SOUND);
	precache_sound2(MP5_CLIPOUT_SOUND);
	precache_sound2(MP5_NOAMMO_SOUND);
	precache_sound2(MP5_SLIDE1_SOUND);
};


