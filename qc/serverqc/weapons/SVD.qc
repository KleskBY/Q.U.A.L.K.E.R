float SVD_DAMAGE = 125;
float SVD_MAX_CLIP = 10;
float SVD_RATE = 0.15;
float SVD_SEMI = 1;
float SVD_DISTANCE = 16384;
.float SVD_AMMO = ammo762x54;
.float SVD_CLIP;
.float SVD_PICKUP;

float SVD_RELOAD_START_FRAME = 1;
float SVD_RELOAD_END_FRAME = 81;
float SVD_DRAW_START_FRAME = 82;
float SVD_DRAW_END_FRAME = 122;
float SVD_ATTACK_START_FRAME = 125;
float SVD_ATTACK_END_FRAME = 148;
float SVD_FRAMERATE = 0.025;

string SVD_VIEW_MODEL = "models/weapons/v_svd.md3";
string SVD_PLAYER_MODEL = "models/player.md3";
string SVD_WORLD_MODEL = "models/weapons/w_svd.md3";

string SVD_FIRE_SOUND = "weapons/svd/shot.wav";
string SVD_CLIPIN_SOUND = "weapons/svd/clipin.wav";
string SVD_CLIPOUT_SOUND = "weapons/svd/clipout.wav";
string SVD_SLIDE1_SOUND = "weapons/svd/bolt.wav";
string SVD_SLIDE2_SOUND = "weapons/sniper/boltrelease.wav";
string SVD_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() SVD_Fire = 
{
	self.SVD_CLIP = self.SVD_CLIP - 1;
	self.currentClip = self.SVD_CLIP;
	
	fireBullet(Spread('20 20 0'), SVD_DISTANCE, SVD_DAMAGE);
	
	self.punchangle_x = random(-4, -8);
	self.punchangle_y = random(-1, -4);
	self.punchangle_z = random(3, 6);
	
	sound (self, CHAN_WEAPON, SVD_FIRE_SOUND, 1, SoundRadius(3000));
	if(self.state != STATE_AIM)
	{
		pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_right * 7 + v_forward * 40 + v_up * -3.5, self.velocity * 50, 1);
		MuzzleFlash('55 -8 -6', 2);
	}
	eject_shell (self.origin + self.view_ofs + v_up * -15 + v_forward * 28 - v_right * -6, "models/shells/rifleShell.md3");	
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////


void() SVD_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + SVD_FRAMERATE;
	
	if (self.weaponframe == 12) sound(self, CHAN_WEAPON, SVD_CLIPOUT_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 28) sound(self, CHAN_WEAPON, SVD_CLIPIN_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 56) sound(self, CHAN_WEAPON, SVD_SLIDE1_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe >= SVD_RELOAD_END_FRAME) FinishReload(SVD_AMMO, SVD_CLIP, SVD_MAX_CLIP);
};

void() SVD_Reload
{
	self.currentClip = self.SVD_CLIP;
	if(self.SVD_CLIP >= SVD_MAX_CLIP) return;
	if(self.SVD_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = SVD_RELOAD_START_FRAME;
	self.nextthink = time + SVD_FRAMERATE;
	self.think = SVD_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, SVD_NOAMMO_SOUND, 1, ATTN_NORM);
}


////////////////////////// ATTACK //////////////////////////////

void() SVD_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + SVD_FRAMERATE;
	if(self.weaponframe >= SVD_ATTACK_END_FRAME) self.think = player_run;
	else self.think = SVD_Attack2;
}

void() SVD_Attack
{
	if(SVD_SEMI && self.ShootsFired != 0) return;
	if(self.SVD_AMMO <= 0 && self.SVD_CLIP <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.SVD_CLIP > 0) 
	{
		self.attack_finished = time + SVD_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = SVD_ATTACK_START_FRAME;
		self.nextthink = time + SVD_FRAMERATE;
		SVD_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = SVD_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, SVD_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = player_run;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() SVD_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + SVD_FRAMERATE;
	self.currentammo =  self.SVD_AMMO;
	if(self.weaponframe >= SVD_DRAW_END_FRAME)
	{
		self.think = player_run;
		self.reload = 0;
	}
};

void() SVD_Switch
{
	if(!self.SVD_PICKUP)
	{
		self.SVD_PICKUP = TRUE;
		self.SVD_CLIP = SVD_MAX_CLIP;
	}
	self.weaponframe = SVD_DRAW_START_FRAME;
	self.nextthink = time + SVD_FRAMERATE;
	self.think = SVD_Switch2;
	self.reload = 1;
	self.currentammo = self.SVD_AMMO;
};

/////////////////////// SELECT //////////////////////

void() SVD_Select =
{
	self.currentClip = self.SVD_CLIP;
	self.currentammo = self.SVD_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = SVD_VIEW_MODEL;
	setmodel (self, SVD_PLAYER_MODEL);
	if(self.duck) setsize(self, DUCK_SIZE_MIN, DUCK_SIZE_MAX);
	else setsize (self, STAND_SIZE_MIN, STAND_SIZE_MAX);
	self.weaponSwitch = SVD_Switch;
	self.weaponAttack = SVD_Attack;
	self.weaponReload = SVD_Reload;
	self.weaponSelect = SVD_Select;
	SetGun(SVD_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() SVD_Precache =
{
	precache_model2(SVD_VIEW_MODEL);
	precache_model2(SVD_PLAYER_MODEL);
	precache_model2(SVD_WORLD_MODEL);
	precache_sound2(SVD_FIRE_SOUND);
	precache_sound2(SVD_CLIPIN_SOUND);
	precache_sound2(SVD_CLIPOUT_SOUND);
	precache_sound2(SVD_NOAMMO_SOUND);
	precache_sound2(SVD_SLIDE1_SOUND);
	precache_sound2(SVD_SLIDE2_SOUND);
};


