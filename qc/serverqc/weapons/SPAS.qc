
//ММММ МЕДОВЫЙ СПАС!
float SPAS_DAMAGE = 8;
float SPAS_MAX_CLIP = 8;
float SPAS_RATE = 0.45;
float SPAS_SEMI = 0;
float SPAS_DISTANCE = 2048;
.float SPAS_AMMO = ammoShells;
.float SPAS_CLIP;
.float SPAS_PICKUP;

float SPAS_RELOAD_START_FRAME = 1;
float SPAS_RELOAD_END_FRAME = 65;
float SPAS_DRAW_START_FRAME = 67;
float SPAS_DRAW_END_FRAME = 97;
float SPAS_ATTACK_START_FRAME = 101;
float SPAS_ATTACK_END_FRAME = 145;
float SPAS_FRAMERATE = 0.022;

string SPAS_VIEW_MODEL = "models/weapons/v_spas.md3";
string SPAS_PLAYER_MODEL = "models/player.md3";
string SPAS_WORLD_MODEL = "models/weapons/w_spas.md3";

string SPAS_FIRE_SOUND = "weapons/shotgun/spas.wav";
string SPAS_CLIPIN_SOUND = "weapons/shotgun/insertshell.wav";
string SPAS_SLIDE1_SOUND = "weapons/shotgun/pump.wav";
string SPAS_NOAMMO_SOUND = "weapons/noammo.wav";

//////////////////////////// FIRE ///////////////////////////////

void() SPAS_Fire = 
{
	self.SPAS_CLIP = self.SPAS_CLIP - 1;
	self.currentClip = self.SPAS_CLIP;
	
	local float i;
	i = 16;
	while (i > 0)
	{
		fireBullet('100 100 0', SPAS_DISTANCE, SPAS_DAMAGE);
		i = i -1;
	}
	
	self.punchangle_x = random (-2,-6);
	self.punchangle_z = -2;
	
	sound(self, CHAN_WEAPON, SPAS_FIRE_SOUND, 1, SoundRadius(2500));
	pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + self.view_ofs + v_up * -2.6 + v_forward * 26 + v_right*3.7, self.velocity*50, 1);
	MuzzleFlash('40 -5 -8', 3);
	eject_shell (self.origin + self.view_ofs + v_up * -8 + v_forward * 14 + v_right * 10, "models/shells/shotgunShell.md3");
};


//////////////////////// RELOADING ПЕРЕЗАРЯДКА ///////////////////////////

void() SPAS_Reload2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + SPAS_FRAMERATE;
	
	if(self.weaponframe == 36) //put shell in chamber
	{
		self.SPAS_AMMO = self.SPAS_AMMO - 1;
		self.SPAS_CLIP = self.SPAS_CLIP + 1;
		self.currentClip = self.SPAS_CLIP;
		sound(self,CHAN_AUTO, SPAS_CLIPIN_SOUND, 0.6, ATTN_NORM);
		self.currentammo = self.SPAS_AMMO;
	}
	if(self.weaponframe == 49 && self.SPAS_CLIP < SPAS_MAX_CLIP && self.SPAS_AMMO > 1) {  self.weaponframe = 19; self.nextthink = time + 0.2; }//go back to put more shells
	if (self.weaponframe == SPAS_RELOAD_END_FRAME) //Done reloading
	{
		self.think = player_run;
		W_SetCurrentAmmo();
	}
	if(self.button0 && self.weaponframe < 51) self.weaponframe = 51;
};

void() SPAS_Reload
{
	self.currentClip = self.SPAS_CLIP;
	if(self.SPAS_CLIP >= SPAS_MAX_CLIP) return;
	if(self.SPAS_AMMO <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	self.weaponframe = SPAS_RELOAD_START_FRAME;
	self.nextthink = time + SPAS_FRAMERATE;
	self.think = SPAS_Reload2;
	self.reload = 1;
	sound(self, CHAN_ITEM, SPAS_NOAMMO_SOUND, 1, ATTN_NORM);
}

////////////////////////// ATTACK //////////////////////////////

void() SPAS_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + SPAS_FRAMERATE;
	if(self.weaponframe == 60) sound(self, CHAN_ITEM, SPAS_SLIDE1_SOUND, 0.5, ATTN_NORM);
	if(self.weaponframe >= SPAS_ATTACK_END_FRAME) self.think = player_run;
	else self.think = SPAS_Attack2;
}

void() SPAS_Attack
{
	if(SPAS_SEMI && self.ShootsFired != 0) return;
	if(self.SPAS_AMMO <= 0 && self.SPAS_CLIP <= 0)
	{
		CycleWeaponReverseCommand();
		return;
	}
	if (self.SPAS_CLIP > 0) 
	{
		self.attack_finished = time + SPAS_RATE;
		self.effects = self.effects | EF_MUZZLEFLASH;
		self.weaponframe = SPAS_ATTACK_START_FRAME;
		self.nextthink = time + SPAS_FRAMERATE;
		SPAS_Fire();
		self.ShootsFired = self.ShootsFired + 1;
		self.think = SPAS_Attack2;
	}                           
	else 
	{
		sound(self, CHAN_ITEM, SPAS_NOAMMO_SOUND, 1, ATTN_NORM);
		self.attack_finished = time + 0.4;
		if (AUTORELOAD) self.impulse = 100;
		self.think = player_run;
	}
}

///////////////// WEAPON CHANGE ///////////////////

void() SPAS_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + SPAS_FRAMERATE;
	self.currentammo =  self.SPAS_AMMO;
	if(self.weaponframe >= SPAS_DRAW_END_FRAME)
	{
		self.think = player_run;
		self.reload = 0;
	}
};

void() SPAS_Switch
{
	if(!self.SPAS_PICKUP)
	{
		self.SPAS_PICKUP = TRUE;
		self.SPAS_CLIP = SPAS_MAX_CLIP;
	}
	self.weaponframe = SPAS_DRAW_START_FRAME;
	self.nextthink = time + SPAS_FRAMERATE;
	self.think = SPAS_Switch2;
	self.reload = 1;
	self.currentammo = self.SPAS_AMMO;
};

/////////////////////// SELECT //////////////////////

void() SPAS_Select =
{
	self.currentClip = self.SPAS_CLIP;
	self.currentammo = self.SPAS_AMMO;
	self.weaponframe = 0;
	self.weaponmodel = SPAS_VIEW_MODEL;
	setmodel(self, SPAS_PLAYER_MODEL);
	if(self.duck) setsize(self, DUCK_SIZE_MIN, DUCK_SIZE_MAX);
	else setsize (self, STAND_SIZE_MIN, STAND_SIZE_MAX);
	self.weaponSwitch = SPAS_Switch;
	self.weaponAttack = SPAS_Attack;
	self.weaponReload = SPAS_Reload;
	self.weaponSelect = SPAS_Select;
	SetGun(SPAS_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() SPAS_Precache =
{
	precache_model2(SPAS_VIEW_MODEL);
	precache_model2(SPAS_PLAYER_MODEL);
	precache_model2(SPAS_WORLD_MODEL);
	if(deathmatch) precache_model("models/weapons/v_shot_usa.md3");
	precache_sound2(SPAS_FIRE_SOUND);
	precache_sound2(SPAS_CLIPIN_SOUND);
	precache_sound2(SPAS_NOAMMO_SOUND);
	precache_sound2(SPAS_SLIDE1_SOUND);
};


