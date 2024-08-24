float AK74_DAMAGE = 40;
float AK74_MAX_CLIP = 30;
float AK74_RATE = 0.11;
float AK74_SEMI = 0;
float AK74_DISTANCE = 4096;

.float AK74_AMMO = ammo545x39;
.float AK74_CLIP;
.float AK74_PICKUP;

float AK74_RELOAD_START_FRAME = 1;
float AK74_RELOAD_END_FRAME = 101;
float AK74_DRAW_START_FRAME = 103;
float AK74_DRAW_END_FRAME = 133;
float AK74_ATTACK_START_FRAME = 135;
float AK74_ATTACK_END_FRAME = 150;
float AK74_FRAMERATE = 0.02;

string AK74_VIEW_MODEL = "models/weapons/v_ak74.md3";
string AK74_PLAYER_MODEL = "models/player.md3";
string AK74_WORLD_MODEL = "models/weapons/w_ak74.md3";

string AK74_FIRE_SOUND = "weapons/ak74/shot.wav";
string AK74_CLIPIN_SOUND = "weapons/ak74/clipin.wav";
string AK74_CLIPOUT_SOUND = "weapons/ak74/clipout.wav";
string AK74_SLIDE1_SOUND = "weapons/ak74/boltpull.wav";
string AK74_SLIDE2_SOUND = "weapons/sniper/boltrelease.wav";
string AK74_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() AK74_Fire = 
{
	self.AK74_CLIP = self.AK74_CLIP - 1;
	self.currentClip = self.AK74_CLIP;
	
	local vector spread = Spread('11 11 0');
	fireBullet(spread, AK74_DISTANCE, AK74_DAMAGE);
	
	self.punchangle_x = random(-3, -5);
	self.punchangle_y = random(2, -2);
	
	sound (self, CHAN_WEAPON, AK74_FIRE_SOUND, 1, SoundRadius(2500));
	
	MuzzleFlash(self.viewmodel.origin + '38 -8 -5.5', 2);
	pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -5 + v_forward * 30 + v_right * 6, self.velocity * 50, 1);
	EjectShell(self.origin + self.view_ofs + v_up * -11 + v_forward * 22 + v_right * 10, "models/shells/rifleShell.md3");
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////

void() AK74_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + AK74_FRAMERATE;
	
	if (self.weaponframe == 23) sound(self, CHAN_ITEM, AK74_CLIPOUT_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe == 55) sound(self, CHAN_ITEM, AK74_CLIPIN_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe == 72) sound(self, CHAN_ITEM, AK74_SLIDE1_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe >= AK74_RELOAD_END_FRAME) FinishReload(AK74_AMMO, AK74_CLIP, AK74_MAX_CLIP);
};

void() AK74_Reload
{
	self.currentClip = self.AK74_CLIP;
	if(self.AK74_CLIP >= AK74_MAX_CLIP + 1) return;
	if(self.AK74_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = AK74_RELOAD_START_FRAME;
	self.nextthink = time + AK74_FRAMERATE;
	self.think = AK74_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, AK74_NOAMMO_SOUND, 1, ATTN_NORM);
}


////////////////////////// ATTACK //////////////////////////////

void() AK74_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + AK74_FRAMERATE;
	if(self.weaponframe >= AK74_ATTACK_END_FRAME) self.think = PlayerThink;
	else self.think = AK74_Attack2;
}

void() AK74_Attack
{
	if(AK74_SEMI && self.ShootsFired != 0) return;
	if(self.AK74_AMMO <= 0 && self.AK74_CLIP <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.AK74_CLIP  > 0) 
	{
		self.attack_finished = time + AK74_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = AK74_ATTACK_START_FRAME;
		self.nextthink = time + AK74_FRAMERATE;
		AK74_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = AK74_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, AK74_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = PlayerThink;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() AK74_Switch2
{	
	if(self.weaponframe == AK74_DRAW_START_FRAME + 4) 	sound(self, CHAN_ITEM, AK74_SLIDE1_SOUND, 0.5, ATTN_NORM);

	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + AK74_FRAMERATE;
	self.currentammo = self.AK74_AMMO;
	if(self.weaponframe >= AK74_DRAW_END_FRAME)
	{
		self.think = PlayerThink;
		self.reload = 0;
	}
};

void() AK74_Switch
{
	if(!self.AK74_PICKUP)
	{
		self.AK74_PICKUP = TRUE;
		self.AK74_CLIP = AK74_MAX_CLIP;
	}
	self.weaponframe = AK74_DRAW_START_FRAME;
	self.nextthink = time + AK74_FRAMERATE;
	self.think = AK74_Switch2;
	self.reload = 1;
	self.currentammo = self.AK74_AMMO;
};

/////////////////////// SELECT //////////////////////

void() AK74_Select =
{
	self.currentClip = self.AK74_CLIP;
	self.currentammo = self.AK74_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = AK74_VIEW_MODEL;
	setmodel (self, AK74_PLAYER_MODEL);
	self.weaponSwitch = AK74_Switch;
	self.weaponAttack = AK74_Attack;
	self.weaponReload = AK74_Reload;
	self.weaponSelect = AK74_Select;
	SetGun(AK74_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() AK74_Precache =
{
	precache_model(AK74_VIEW_MODEL);
	precache_model(AK74_PLAYER_MODEL);
	precache_model(AK74_WORLD_MODEL);
	precache_sound(AK74_FIRE_SOUND);
	precache_sound(AK74_CLIPIN_SOUND);
	precache_sound(AK74_CLIPOUT_SOUND);
	precache_sound(AK74_NOAMMO_SOUND);
	precache_sound(AK74_SLIDE1_SOUND);
};


