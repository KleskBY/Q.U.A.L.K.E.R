float AKSU_DAMAGE = 36;
float AKSU_MAX_CLIP = 30;
float AKSU_RATE = 0.1;
float AKSU_SEMI = 0;
float AKSU_DISTANCE = 4096;

.float AKSU_AMMO = ammo545x39;
.float AKSU_CLIP;
.float AKSU_PICKUP;

float AKSU_RELOAD_START_FRAME = 1;
float AKSU_RELOAD_END_FRAME = 100;
float AKSU_DRAW_START_FRAME = 103;
float AKSU_DRAW_END_FRAME = 133;
float AKSU_ATTACK_START_FRAME = 135;
float AKSU_ATTACK_END_FRAME = 150;
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
	
	self.punchangle_x += random(-1.1, -2.35);
	self.punchangle_y += random(1, -1);
	
	sound (self, CHAN_WEAPON, AKSU_FIRE_SOUND, 1, SoundRadius(2500));
	
	MuzzleFlash(self.viewmodel.origin + '38 -8 -5.5', 2);
	pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -5 + v_forward * 25 + v_right * 6, self.velocity * 50, 1);
	EjectShell(self.origin + self.view_ofs + v_up * -10 + v_forward * 22 + v_right * 8, "models/shells/rifleShell.md3");
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////

void() AKSU_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + AKSU_FRAMERATE;
	
	if (self.weaponframe == 23) sound(self, CHAN_ITEM, AK74_CLIPOUT_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe == 55) sound(self, CHAN_ITEM, AK74_CLIPIN_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe == 72) sound(self, CHAN_ITEM, AK74_SLIDE1_SOUND, 0.5, ATTN_NORM);
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
	if(self.weaponframe >= AKSU_ATTACK_END_FRAME) self.think = PlayerThink;
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
		self.think = PlayerThink;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() AKSU_Switch2
{	
	if(self.weaponframe == AKSU_DRAW_END_FRAME + 4) 	sound(self, CHAN_ITEM, AK74_SLIDE1_SOUND, 0.5, ATTN_NORM);

	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + AKSU_FRAMERATE;
	self.currentammo = self.AKSU_AMMO;
	if(self.weaponframe >= AKSU_DRAW_END_FRAME)
	{
		self.think = PlayerThink;
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
	self.weaponSwitch = AKSU_Switch;
	self.weaponAttack = AKSU_Attack;
	self.weaponReload = AKSU_Reload;
	self.weaponSelect = AKSU_Select;
	SetGun(AKSU_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() AKSU_Precache =
{
	precache_model(AKSU_VIEW_MODEL);
	precache_model(AKSU_PLAYER_MODEL);
	precache_model(AKSU_WORLD_MODEL);
	precache_sound(AKSU_FIRE_SOUND);
	precache_sound(AKSU_CLIPIN_SOUND);
	precache_sound(AKSU_CLIPOUT_SOUND);
	precache_sound(AKSU_NOAMMO_SOUND);
};


