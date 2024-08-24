float PM_DAMAGE = 30;
float PM_MAX_CLIP = 8;
float PM_RATE = 0.05;
float PM_SEMI = 1;
float PM_DISTANCE = 2048;
.float PM_AMMO = ammo9x18;
.float PM_CLIP;
.float PM_PICKUP;

float PM_RELOAD_START_FRAME = 1;
float PM_RELOAD_END_FRAME = 66;
float PM_DRAW_START_FRAME = 68;
float PM_DRAW_END_FRAME = 88;
float PM_ATTACK_START_FRAME = 91;
float PM_ATTACK_END_FRAME = 120;
// float PM_RELOAD_START_FRAME = 1;
// float PM_RELOAD_END_FRAME = 87;
// float PM_DRAW_START_FRAME = 89;
// float PM_DRAW_END_FRAME = 125;
// float PM_ATTACK_START_FRAME = 127;
// float PM_ATTACK_END_FRAME = 155;
float PM_FRAMERATE = 0.03;

string PM_VIEW_MODEL = "models/weapons/v_pm.md3";
string PM_PLAYER_MODEL = "models/player.md3";
string PM_WORLD_MODEL = "models/weapons/w_pm.md3";

string PM_FIRE_SOUND = "weapons/pm/shot.wav";
string PM_CLIPIN_SOUND = "weapons/pm/clipin.wav";
string PM_CLIPOUT_SOUND = "weapons/pm/clipout.wav";
string PM_SLIDE1_SOUND = "weapons/pm/slideforward.wav";
string PM_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() PM_Fire = 
{
	self.PM_CLIP = self.PM_CLIP - 1;
	self.currentClip = self.PM_CLIP;
	
	fireBullet(Spread('5 5 0'), PM_DISTANCE, PM_DAMAGE);
	
	self.punchangle_x = random(-1, -2.5);
	self.punchangle_y = random(-2, 2);
	
	sound (self, CHAN_WEAPON, PM_FIRE_SOUND, 1, SoundRadius(1700));
	pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -4 + v_forward * 30 + v_right * 9, self.velocity * 50, 1);
	EjectShell(self.origin + self.view_ofs + v_up * -5 + v_forward * 22 + v_right * 7, "models/shells/pistolShell.md3");
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////

void() PM_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + PM_FRAMERATE;
	
	if (self.weaponframe == 10) sound(self, CHAN_WEAPON, PM_CLIPOUT_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 20) self.nextthink = time + 0.23;
	if (self.weaponframe == 33) sound(self, CHAN_WEAPON, PM_CLIPIN_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe == 48) sound(self, CHAN_WEAPON, PM_SLIDE1_SOUND, 0.7, ATTN_NORM);
	if (self.weaponframe >= PM_RELOAD_END_FRAME)
	{
		FinishReload(PM_AMMO, PM_CLIP, PM_MAX_CLIP);
	}
};

void() PM_Reload
{
	self.currentClip = self.PM_CLIP;
	if(self.PM_CLIP >= PM_MAX_CLIP + 1) return;
	if(self.PM_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = PM_RELOAD_START_FRAME;
	self.nextthink = time + PM_FRAMERATE;
	self.think = PM_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, PM_NOAMMO_SOUND, 1, ATTN_NORM);
}


////////////////////////// ATTACK //////////////////////////////

void() PM_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + PM_FRAMERATE;
	if(self.weaponframe >= PM_ATTACK_END_FRAME) self.think = PlayerThink;
	else self.think = PM_Attack2;
}

void() PM_Attack
{
	if(PM_SEMI && self.ShootsFired != 0) return;
	if(self.PM_AMMO <= 0 && self.PM_CLIP <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.PM_CLIP > 0) 
	{
		self.attack_finished = time + PM_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = PM_ATTACK_START_FRAME;
		self.nextthink = time + PM_FRAMERATE;
		PM_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = PM_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, PM_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = PlayerThink;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() PM_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + PM_FRAMERATE;
	self.currentammo = self.PM_AMMO;
	if(self.weaponframe >= PM_DRAW_END_FRAME)
	{
		self.think = PlayerThink;
		self.reload = 0;
	}
};

void() PM_Switch
{
	if(!self.PM_PICKUP)
	{
		self.PM_PICKUP = TRUE;
		self.PM_CLIP = PM_MAX_CLIP;
	}
	self.weaponframe = PM_DRAW_START_FRAME;
	self.nextthink = time + PM_FRAMERATE;
	self.think = PM_Switch2;
	self.reload = 1;
	self.currentammo = self.PM_AMMO;
};

/////////////////////// SELECT //////////////////////

void() PM_Select =
{
	self.currentClip = self.PM_CLIP;
	self.currentammo = self.PM_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = PM_VIEW_MODEL;
	setmodel (self, PM_PLAYER_MODEL);
	self.weaponSwitch = PM_Switch;
	self.weaponAttack = PM_Attack;
	self.weaponReload = PM_Reload;
	self.weaponSelect = PM_Select;
	SetGun(PM_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() PM_Precache =
{
	precache_model(PM_VIEW_MODEL);
	precache_model(PM_PLAYER_MODEL);
	precache_model(PM_WORLD_MODEL);
	precache_sound(PM_FIRE_SOUND);
	precache_sound(PM_CLIPIN_SOUND);
	precache_sound(PM_CLIPOUT_SOUND);
	precache_sound(PM_NOAMMO_SOUND);
	precache_sound(PM_SLIDE1_SOUND);
};


