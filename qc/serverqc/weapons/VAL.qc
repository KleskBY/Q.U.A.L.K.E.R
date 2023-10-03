float VAL_DAMAGE = 45;
float VAL_MAX_CLIP = 20;
float VAL_RATE = 0.08;
float VAL_SEMI = 0;
float VAL_DISTANCE = 4096;
.float VAL_AMMO = ammo9x39;
.float VAL_CLIP;
.float VAL_PICKUP;

float VAL_RELOAD_START_FRAME = 4;
float VAL_RELOAD_END_FRAME = 94;//117;
float VAL_DRAW_START_FRAME = 95;
float VAL_DRAW_END_FRAME = 125;
float VAL_ATTACK_START_FRAME = 126;
float VAL_ATTACK_END_FRAME = 141;
float VAL_FRAMERATE = 0.03;

string VAL_VIEW_MODEL = "models/weapons/v_val.md3";
string VAL_PLAYER_MODEL = "models/player.md3";
string VAL_WORLD_MODEL = "models/weapons/w_val.md3";

string VAL_FIRE_SOUND = "weapons/val/shot.wav";
string VAL_CLIPIN_SOUND = "weapons/ak74/clipin.wav";
string VAL_CLIPOUT_SOUND = "weapons/ak74/clipout.wav";
string VAL_SLIDE1_SOUND = "weapons/sniper/boltback.wav";
string VAL_SLIDE2_SOUND = "weapons/sniper/boltrelease.wav";
string VAL_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() VAL_Fire = 
{
	self.VAL_CLIP = self.VAL_CLIP - 1;
	self.currentClip = self.VAL_CLIP;
	
	local vector spread = Spread('11 11 0');
	fireBullet(spread, VAL_DISTANCE, VAL_DAMAGE);
	
	if (self.ShootsFired == 0) self.punchangle_x = (-random(2,3));
	else if (self.ShootsFired == 1) self.punchangle_x = (-random(3,4));
	else if (self.ShootsFired >= 2) self.punchangle_x = (-random(5,6));
	self.punchangle_z = (random(-1,1));
	
	
	sound (self, CHAN_WEAPON, VAL_FIRE_SOUND, 1, SoundRadius(1500));
	pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -6 + v_forward * 28 + v_right * 7, self.velocity * 50, 1);
	eject_shell (self.origin + self.view_ofs + v_up * -7.1 + v_forward * 23 - v_right * -16, "models/shells/rifleShell.md3");
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////


void() VAL_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + VAL_FRAMERATE;
	
	if (self.weaponframe == 25) sound(self, CHAN_ITEM, VAL_CLIPOUT_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe == 67) sound(self, CHAN_ITEM, VAL_CLIPIN_SOUND, 0.5, ATTN_NORM);
	if (self.weaponframe >= VAL_RELOAD_END_FRAME) FinishReload(VAL_AMMO, VAL_CLIP, VAL_MAX_CLIP);
};

void() VAL_Reload
{
	self.currentClip = self.VAL_CLIP;
	if(self.VAL_CLIP >= VAL_MAX_CLIP + 1) return;
	if(self.VAL_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = VAL_RELOAD_START_FRAME;
	self.nextthink = time + VAL_FRAMERATE;
	self.think = VAL_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, VAL_NOAMMO_SOUND, 1, ATTN_NORM);
}


////////////////////////// ATTACK //////////////////////////////

void() VAL_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + VAL_FRAMERATE;
	if(self.weaponframe >= VAL_ATTACK_END_FRAME) self.think = player_run;
	else self.think = VAL_Attack2;
}

void() VAL_Attack
{
	if(VAL_SEMI && self.ShootsFired != 0) return;
	if(self.VAL_AMMO <= 0 && self.currentClip <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.VAL_CLIP > 0) 
	{
		self.attack_finished = time + VAL_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = VAL_ATTACK_START_FRAME;
		self.nextthink = time + VAL_FRAMERATE;
		VAL_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = VAL_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, VAL_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = player_run;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() VAL_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + VAL_FRAMERATE;
	self.currentammo = self.VAL_AMMO;
	if(self.weaponframe >= VAL_DRAW_END_FRAME)
	{
		self.think = player_run;
		self.reload = 0;
	}
};

void() VAL_Switch
{
	if(!self.VAL_PICKUP)
	{
		self.VAL_PICKUP = TRUE;
		self.VAL_CLIP = VAL_MAX_CLIP;
	}
	self.weaponframe = VAL_DRAW_START_FRAME;
	self.nextthink = time + VAL_FRAMERATE;
	self.think = VAL_Switch2;
	self.reload = 1;
	self.currentammo = self.VAL_AMMO;
};

/////////////////////// SELECT //////////////////////

void() VAL_Select =
{
	self.currentClip = self.VAL_CLIP;
	self.currentammo = self.VAL_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = VAL_VIEW_MODEL;
	setmodel (self, VAL_PLAYER_MODEL);
	if(self.duck) setsize(self, DUCK_SIZE_MIN, DUCK_SIZE_MAX);
	else setsize (self, STAND_SIZE_MIN, STAND_SIZE_MAX);
	self.weaponSwitch = VAL_Switch;
	self.weaponAttack = VAL_Attack;
	self.weaponReload = VAL_Reload;
	self.weaponSelect = VAL_Select;
	SetGun(VAL_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() VAL_Precache =
{
	precache_model2(VAL_VIEW_MODEL);
	precache_model2(VAL_PLAYER_MODEL);
	precache_model2(VAL_WORLD_MODEL);
	precache_sound2(VAL_FIRE_SOUND);
	precache_sound2(VAL_CLIPIN_SOUND);
	precache_sound2(VAL_CLIPOUT_SOUND);
	precache_sound2(VAL_NOAMMO_SOUND);
};


