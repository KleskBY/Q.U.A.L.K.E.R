float GAUSS_DAMAGE = 450;
float GAUSS_MAX_CLIP = 10;
float GAUSS_RATE = 2;
float GAUSS_SEMI = 1;
float GAUSS_DISTANCE = 16384;
.float GAUSS_AMMO = ammoBat;
.float GAUSS_CLIP;
.float GAUSS_PICKUP;

float GAUSS_RELOAD_START_FRAME = 1;
float GAUSS_RELOAD_END_FRAME = 62;
float GAUSS_DRAW_START_FRAME = 64;
float GAUSS_DRAW_END_FRAME = 91;
float GAUSS_ATTACK_START_FRAME = 92;
float GAUSS_ATTACK_END_FRAME = 125;
float GAUSS_FRAMERATE = 0.025;

string GAUSS_VIEW_MODEL = "models/weapons/v_gauss.md3";
string GAUSS_PLAYER_MODEL = "models/player.md3";
string GAUSS_WORLD_MODEL = "models/weapons/w_gauss.md3";

string GAUSS_FIRE_SOUND = "weapons/gauss/shot.wav";
string GAUSS_CLIPIN_SOUND = "weapons/gauss/clipin.wav";
string GAUSS_CLIPOUT_SOUND = "weapons/gauss/clipout.wav";
string GAUSS_SLIDE1_SOUND = "weapons/svd/bolt.wav";
string GAUSS_SLIDE2_SOUND = "weapons/sniper/boltrelease.wav";
string GAUSS_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() GAUSS_Fire = 
{
	self.GAUSS_CLIP = self.GAUSS_CLIP - 1;
	self.currentClip = self.GAUSS_CLIP;
	
	fireBullet(Spread('2 2 0'), GAUSS_DISTANCE, GAUSS_DAMAGE);
	
	self.punchangle_x = random(-0.1, 0.1);
	self.punchangle_y = random(-0.1, 0.1);
	self.punchangle_z = random(-0.1, 0.1);
	
	sound (self, CHAN_WEAPON, GAUSS_FIRE_SOUND, 1, SoundRadius(3000));
	DrawLine(self.origin + self.view_ofs + v_up * -12 + v_right * 15, trace_endpos);
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////


void() GAUSS_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + GAUSS_FRAMERATE;
	
	if (self.weaponframe == 16) sound(self, CHAN_WEAPON, GAUSS_CLIPOUT_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 41) sound(self, CHAN_WEAPON, GAUSS_CLIPIN_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe >= GAUSS_RELOAD_END_FRAME) FinishReload(GAUSS_AMMO, GAUSS_CLIP, GAUSS_MAX_CLIP);

}

void() GAUSS_Reload
{
	self.currentClip = self.GAUSS_CLIP;
	if(self.GAUSS_CLIP >= GAUSS_MAX_CLIP) return;
	if(self.GAUSS_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = GAUSS_RELOAD_START_FRAME;
	self.nextthink = time + GAUSS_FRAMERATE;
	self.think = GAUSS_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, GAUSS_NOAMMO_SOUND, 1, ATTN_NORM);
}


////////////////////////// ATTACK //////////////////////////////

void() GAUSS_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + GAUSS_FRAMERATE;
	if(self.weaponframe >= GAUSS_ATTACK_END_FRAME) self.think = PlayerThink;
	else self.think = GAUSS_Attack2;
}

void() GAUSS_Attack
{
	if(GAUSS_SEMI && self.ShootsFired != 0) return;
	if(self.GAUSS_AMMO <= 0 && self.GAUSS_CLIP <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.GAUSS_CLIP > 0) 
	{
		self.attack_finished = time + GAUSS_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = GAUSS_ATTACK_START_FRAME;
		self.nextthink = time + GAUSS_FRAMERATE;
		GAUSS_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = GAUSS_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, GAUSS_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = PlayerThink;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() GAUSS_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + GAUSS_FRAMERATE;
	self.currentammo =  self.GAUSS_AMMO;
	if(self.weaponframe >= GAUSS_DRAW_END_FRAME)
	{
		self.think = PlayerThink;
		self.reload = 0;
	}
};

void() GAUSS_Switch
{
	if(!self.GAUSS_PICKUP)
	{
		self.GAUSS_PICKUP = TRUE;
		self.GAUSS_CLIP = GAUSS_MAX_CLIP;
	}
	self.weaponframe = GAUSS_DRAW_START_FRAME;
	self.nextthink = time + GAUSS_FRAMERATE;
	self.think = GAUSS_Switch2;
	self.reload = 1;
	self.currentammo = self.GAUSS_AMMO;
};

/////////////////////// SELECT //////////////////////

void() GAUSS_Select =
{
	self.currentClip = self.GAUSS_CLIP;
	self.currentammo = self.GAUSS_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = GAUSS_VIEW_MODEL;
	setmodel (self, GAUSS_PLAYER_MODEL);
	self.weaponSwitch = GAUSS_Switch;
	self.weaponAttack = GAUSS_Attack;
	self.weaponReload = GAUSS_Reload;
	self.weaponSelect = GAUSS_Select;
	SetGun(GAUSS_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() GAUSS_Precache =
{
	precache_model(GAUSS_VIEW_MODEL);
	precache_model(GAUSS_PLAYER_MODEL);
	precache_model(GAUSS_WORLD_MODEL);
	precache_sound(GAUSS_FIRE_SOUND);
	precache_sound(GAUSS_CLIPIN_SOUND);
	precache_sound(GAUSS_CLIPOUT_SOUND);
	precache_sound(GAUSS_NOAMMO_SOUND);
	precache_sound(GAUSS_SLIDE1_SOUND);
	precache_sound(GAUSS_SLIDE2_SOUND);
};


