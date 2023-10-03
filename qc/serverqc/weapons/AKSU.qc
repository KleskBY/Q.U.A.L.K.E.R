float AKSU_DAMAGE = 36;
float AKSU_MAX_CLIP = 30;
float AKSU_RATE = 0.1;
float AKSU_SEMI = 0;
float AKSU_DISTANCE = 4096;

.float AKSU_AMMO = ammo545x39;
.float AKSU_CLIP;
.float AKSU_PICKUP;

float AKSU_RELOAD_START_FRAME = 4;
float AKSU_RELOAD_END_FRAME = 94;
float AKSU_DRAW_START_FRAME = 95;
float AKSU_DRAW_END_FRAME = 125;
float AKSU_ATTACK_START_FRAME = 126;
float AKSU_ATTACK_END_FRAME = 141;
float AKSU_FRAMERATE = 0.02;

string AKSU_VIEW_MODEL = "models/weapons/v_aksu.md3";
string AKSU_PLAYER_MODEL = "models/player.md3";
string AKSU_WORLD_MODEL = "models/weapons/w_aksu.md3";

string AKSU_FIRE_SOUND = "weapons/aksu/shot.wav";
string AKSU_CLIPIN_SOUND = "weapons/ak74/clipin.wav";
string AKSU_CLIPOUT_SOUND = "weapons/ak74/clipout.wav";
string AKSU_SLIDE1_SOUND = "weapons/sniper/boltback.wav";
string AKSU_SLIDE2_SOUND = "weapons/sniper/boltrelease.wav";
string AKSU_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() AKSU_Fire = 
{
	self.AKSU_CLIP = self.AKSU_CLIP - 1;
	self.currentClip = self.AKSU_CLIP;
	
	local vector spread = Spread('17 17 0');
	fireBullet(spread, AKSU_DISTANCE, AKSU_DAMAGE);
	
	self.punchangle_x = random(-3, -5);
	self.punchangle_y = random(2, -2);
	
	sound (self, CHAN_WEAPON, AKSU_FIRE_SOUND, 1, SoundRadius(2500));
	
	MuzzleFlash(self.viewmodel.origin + '38 -8 -5.5', 2);
	pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -5 + v_forward * 25 + v_right * 6, self.velocity * 50, 1);
	eject_shell (self.origin + self.view_ofs + v_up * -10 + v_forward * 22 + v_right * 8, "models/shells/rifleShell.md3");
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////

void() AKSU_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + AKSU_FRAMERATE;
	
	if (self.weaponframe == 25) sound(self, CHAN_ITEM, AKSU_CLIPOUT_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe == 65) sound(self, CHAN_ITEM, AKSU_CLIPIN_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe == 70) sound(self, CHAN_ITEM, AKSU_SLIDE2_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe >= AKSU_RELOAD_END_FRAME || (self.currentClip > 0 && self.weaponframe > 117)) FinishReload(AKSU_AMMO, AKSU_CLIP, AKSU_MAX_CLIP);
};

void() AKSU_Reload
{
	self.currentClip = self.AKSU_CLIP;
	if(self.AKSU_CLIP >= AKSU_MAX_CLIP + 1) return;
	if(self.AKSU_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = AKSU_RELOAD_START_FRAME;
	self.nextthink = time + AKSU_FRAMERATE;
	self.think = AKSU_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, AKSU_NOAMMO_SOUND, 1, ATTN_NORM);
}


////////////////////////// ATTACK //////////////////////////////

void() AKSU_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + AKSU_FRAMERATE;
	if(self.weaponframe >= AKSU_ATTACK_END_FRAME) self.think = player_run;
	else self.think = AKSU_Attack2;
}

void() AKSU_Attack
{
	if(AKSU_SEMI && self.ShootsFired != 0) return;
	if(self.AKSU_AMMO <= 0 && self.AKSU_CLIP <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.AKSU_CLIP  > 0) 
	{
		self.attack_finished = time + AKSU_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = AKSU_ATTACK_START_FRAME;
		self.nextthink = time + AKSU_FRAMERATE;
		AKSU_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = AKSU_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, AKSU_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = player_run;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() AKSU_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + AKSU_FRAMERATE;
	self.currentammo = self.AKSU_AMMO;
	if(self.weaponframe >= AKSU_DRAW_END_FRAME)
	{
		self.think = player_run;
		self.reload = 0;
	}
};

void() AKSU_Switch
{
	if(!self.AKSU_PICKUP)
	{
		self.AKSU_PICKUP = TRUE;
		self.AKSU_CLIP = AKSU_MAX_CLIP;
	}
	self.weaponframe = AKSU_DRAW_START_FRAME;
	self.nextthink = time + AKSU_FRAMERATE;
	self.think = AKSU_Switch2;
	self.reload = 1;
	self.currentammo = self.AKSU_AMMO;
};

/////////////////////// SELECT //////////////////////

void() AKSU_Select =
{
	self.currentClip = self.AKSU_CLIP;
	self.currentammo = self.AKSU_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = AKSU_VIEW_MODEL;
	setmodel (self, AKSU_PLAYER_MODEL);
	if(self.duck) setsize(self, DUCK_SIZE_MIN, DUCK_SIZE_MAX);
	else setsize (self, STAND_SIZE_MIN, STAND_SIZE_MAX);
	self.weaponSwitch = AKSU_Switch;
	self.weaponAttack = AKSU_Attack;
	self.weaponReload = AKSU_Reload;
	self.weaponSelect = AKSU_Select;
	SetGun(AKSU_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() AKSU_Precache =
{
	precache_model2(AKSU_VIEW_MODEL);
	precache_model2(AKSU_PLAYER_MODEL);
	precache_model2(AKSU_WORLD_MODEL);
	precache_sound2(AKSU_FIRE_SOUND);
	precache_sound2(AKSU_CLIPIN_SOUND);
	precache_sound2(AKSU_CLIPOUT_SOUND);
	precache_sound2(AKSU_NOAMMO_SOUND);
};


