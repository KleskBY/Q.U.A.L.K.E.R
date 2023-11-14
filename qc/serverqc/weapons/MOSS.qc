float MOSS_DAMAGE = 8;
float MOSS_MAX_CLIP = 6;
float MOSS_RATE = 0.66;
float MOSS_SEMI = 1;
float MOSS_DISTANCE = 2048;
.float MOSS_AMMO = ammoShells;
.float MOSS_CLIP;
.float MOSS_PICKUP;

float MOSS_RELOAD_START_FRAME = 1;
float MOSS_RELOAD_END_FRAME = 69;
float MOSS_DRAW_START_FRAME = 70;
float MOSS_DRAW_END_FRAME = 100;
float MOSS_ATTACK_START_FRAME = 101;
float MOSS_ATTACK_END_FRAME = 145;
float MOSS_FRAMERATE = 0.022;

string MOSS_VIEW_MODEL = "models/weapons/v_moss.md3";
string MOSS_PLAYER_MODEL = "models/player.md3";
string MOSS_WORLD_MODEL = "models/weapons/w_moss.md3";

string MOSS_FIRE_SOUND = "weapons/shotgun/shot.wav";
string MOSS_CLIPIN_SOUND = "weapons/shotgun/insertshell.wav";
string MOSS_SLIDE1_SOUND = "weapons/shotgun/pump.wav";
string MOSS_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() MOSS_Fire = 
{
	self.MOSS_CLIP = self.MOSS_CLIP - 1;
	self.currentClip = self.MOSS_CLIP;
	
	local float i;
	i = 16;
	while (i > 0)
	{
		fireBullet('90 90 0', MOSS_DISTANCE, MOSS_DAMAGE);
		i = i -1;
	}
	
	self.punchangle_x = random (-2,-6);
	self.punchangle_z = -2;
	sound(self, CHAN_WEAPON, MOSS_FIRE_SOUND, 1, SoundRadius(2500));
	pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + self.view_ofs + v_up * -2.6 + v_forward * 26 + v_right*3.7, self.velocity*50, 1);
	MuzzleFlash('40 -5 -8', 3);
	eject_shell (self.origin + self.view_ofs + v_up * -6 + v_forward * 20 + v_right * 8, "models/shells/shotgunShell.md3");
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////

void() MOSS_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + MOSS_FRAMERATE;
	
	if(self.weaponframe == 30) //put shell in chamber
	{
		self.MOSS_AMMO = self.MOSS_AMMO - 1;
		self.MOSS_CLIP = self.MOSS_CLIP + 1;
		self.currentClip = self.MOSS_CLIP;
		sound(self,CHAN_AUTO, MOSS_CLIPIN_SOUND, 0.6, ATTN_NORM);
		self.currentammo = self.MOSS_AMMO;
	}
	if(self.weaponframe == 36 && self.MOSS_CLIP < MOSS_MAX_CLIP && self.MOSS_AMMO > 1) {  self.weaponframe = 19; self.nextthink = time + 0.25; }//go back to put more shells
	if(self.weaponframe == 50) sound(self,CHAN_AUTO, MOSS_SLIDE1_SOUND, 0.6, ATTN_NORM);
	if (self.weaponframe == 69) //Done reloading
	{
		self.think = player_run;
		W_SetCurrentAmmo();
	}
	if(self.button0 && self.weaponframe < 38) self.weaponframe = 38;
};

void() MOSS_Reload
{
	self.currentClip = self.MOSS_CLIP;
	if(self.MOSS_CLIP >= MOSS_MAX_CLIP) return;
	if(self.MOSS_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = MOSS_RELOAD_START_FRAME;
	self.nextthink = time + MOSS_FRAMERATE;
	self.think = MOSS_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, MOSS_NOAMMO_SOUND, 1, ATTN_NORM);
}

////////////////////////// ATTACK //////////////////////////////

void() MOSS_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + MOSS_FRAMERATE;
	if(self.weaponframe == 60) sound(self, CHAN_ITEM, MOSS_SLIDE1_SOUND, 0.5, ATTN_NORM);
	if(self.weaponframe >= MOSS_ATTACK_END_FRAME) self.think = player_run;
	else self.think = MOSS_Attack2;
}

void() MOSS_Attack
{
	if(MOSS_SEMI && self.ShootsFired != 0) return;
	if(self.MOSS_AMMO <= 0 && self.MOSS_CLIP <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.MOSS_CLIP > 0) 
	{
		self.attack_finished = time + MOSS_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = MOSS_ATTACK_START_FRAME;
		self.nextthink = time + MOSS_FRAMERATE;
		MOSS_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = MOSS_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, MOSS_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = player_run;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() MOSS_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + MOSS_FRAMERATE;
	self.currentammo =  self.MOSS_AMMO;
	if(self.weaponframe >= MOSS_DRAW_END_FRAME)
	{
		self.think = player_run;
		self.reload = 0;
	}
};

void() MOSS_Switch
{
	if(!self.MOSS_PICKUP)
	{
		self.MOSS_PICKUP = TRUE;
		self.MOSS_CLIP = MOSS_MAX_CLIP;
	}
	self.weaponframe = MOSS_DRAW_START_FRAME;
	self.nextthink = time + MOSS_FRAMERATE;
	self.think = MOSS_Switch2;
	self.reload = 1;
	self.currentammo = self.MOSS_AMMO;
};

/////////////////////// SELECT //////////////////////

void() MOSS_Select =
{
	self.currentClip = self.MOSS_CLIP;
	self.currentammo = self.MOSS_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = MOSS_VIEW_MODEL;
	setmodel(self, MOSS_PLAYER_MODEL);
	if(self.duck) setsize(self, DUCK_SIZE_MIN, DUCK_SIZE_MAX);
	else setsize (self, STAND_SIZE_MIN, STAND_SIZE_MAX);
	self.weaponSwitch = MOSS_Switch;
	self.weaponAttack = MOSS_Attack;
	self.weaponReload = MOSS_Reload;
	self.weaponSelect = MOSS_Select;
	SetGun(MOSS_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() MOSS_Precache =
{
	precache_model2(MOSS_VIEW_MODEL);
	precache_model2(MOSS_PLAYER_MODEL);
	precache_model2(MOSS_WORLD_MODEL);
	if(deathmatch) precache_model("models/weapons/v_shot_usa.md3");
	precache_sound2(MOSS_FIRE_SOUND);
	precache_sound2(MOSS_CLIPIN_SOUND);
	precache_sound2(MOSS_NOAMMO_SOUND);
	precache_sound2(MOSS_SLIDE1_SOUND);
};


