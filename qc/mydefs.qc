

////////////////////////////////////////
///////////////// DEFS /////////////////
////////////////////////////////////////

#define printline(...)  print(VA_ARGS, "\n") // DP varadic yes

// message protocol defines
float SVC_SETVIEWPORT	= 5;
float SVC_SETVIEWANGLES	= 10;

float	FL_LADDERJUMP			= 8192;	// for ladders

//Half-life player size (real world scale)
// vector STAND_SIZE_MIN = '-16 -16 -36';
// vector STAND_SIZE_MAX = '16 16 36';

//Quakeplayer size (1.5m gnome scale)
vector STAND_SIZE_MIN = '-16 -16 -24';
vector STAND_SIZE_MAX = '16 16 32';

//My 0 coordinate scale
//vector STAND_SIZE_MIN = '-15 -15 0';
//vector STAND_SIZE_MAX = '15 15 70';

vector DUCK_SIZE_MIN = STAND_SIZE_MIN;
vector DUCK_SIZE_MAX = STAND_SIZE_MAX - '0 0 24';

//vector STAND_VIEW_OFS = '0 0 68';
//vector DUCK_VIEW_OFS = '0 0 40';
vector STAND_VIEW_OFS = '0 0 24';
vector DUCK_VIEW_OFS = '0 0 6';


float AUTOJUMP = 0;
float JUMPCOOLDOWN = 0.95;
float AUTOBOTS = 0;
float AUTORELOAD = 1;
float PUSHING_FACTOR = 0;
float ANTIAFK = 30;
float OLD_SERVER = 0;

float HITBOX_HEAD = 1;
float HITBOX_LEGS = 0;
float HITBOX_BODY = -1;

float MODE_COOP = 0;
float MODE_DM = 1;
float MODE_SURV = 2;

////////////// PLAYER STATES /////////////////

float STATE_IDLE = 1;
float STATE_AIM = 2;
float STATE_RUN = 4;
float STATE_CROUCH = 8;

////////////// PLAYER STATS /////////////////

float STAT_ZOOM = 32;
float STAT_TOTALITEMS = 33;
float STAT_PICKED_ITEMS = 34;
float STAT_SHOTS = 35;
float STAT_HITS = 36;
float STAT_MEDKITS = 37;
float STAT_MONEY = 38;

////////////////// MATH /////////////////////

float SoundRadius(float radius)
{
	return (800 / radius);
//	return ((cvar("snd_soundradius") / 1.5) / radius);
}

float VectorAbsSum(vector v) 
{
    return fabs(v_x) + fabs(v_y) + fabs(v_z);
}

vector BetterNormalize(vector v)
{
	float absSum = VectorAbsSum(v);
	if(absSum == 0) return v;
	return v / absSum;
}

vector(vector angle) NormalizeAngle =
{
	while (angle_x < -180) angle_x += 360;
	while (angle_x > 180) angle_x -= 360;

	while (angle_y < -180) angle_y += 360;
	while (angle_y > 180) angle_y -= 360;

	while (angle_z < -180) angle_z += 360;
	while (angle_z > 180) angle_z -= 360;

	return angle;
}

vector(vector angle) ClampAngle =
{
	while (angle_y > 180) angle_y -= 360;
	while (angle_y < -180) angle_y += 360;

	if (angle_x > 89.0) angle_x = 89.0;
	if (angle_x < -89.0) angle_x = -89.0;

	angle_z = 0;

	return angle;
}

float Lerp(float a, float b, float factor)
{
    return a * (1.0 - factor) + (b * factor);
}

vector LerpVector(vector a, vector b, float factor)
{
    return a * (1.0 - factor) + (b * factor);
}

float RandomInt(float minf, float maxf)
{
	return rint(random(minf, maxf));
	// return rint(random(minf - 0.5, maxf + 0.5));
	// return rint(random() * (maxf - minf)) + minf;	
}

////////////////////////////////////////
//////////////// FIELDS ////////////////
////////////////////////////////////////


.void() sightSound;
.float() checkAttack;

.float lastTouch;

.float timer;
.entity hook;

.float reload;
.entity viewmodel;
.float blockSwitch;
.float hitbox;

//Stance
.float crouching;
.float running;
.float stamina;

.float footstep_finished;


//WEAPONS
.void() weaponAttack;
.void() weaponSwitch;
.void() weaponReload;
.void() weaponSelect;
.entity gun;

.float weapons;
.float ammo9x18, ammo9x19, ammo545x39, ammo9x39, ammo745x54, ammo762x54, ammoBat, ammoShells, ammoGrenades;
.float ShootsFired;
.float weaponfired;
.float currentClip;

float WP_KNIFE = 1;
float WP_PISTOL = 2;
float WP_AK74 = 4;
float WP_SHOT = 8;
float WP_SHOTGUN = 8;
float WP_MOSS = 8;
float WP_SNIPER = 16;
float WP_SVD = 16;
float WP_GRENADE = 32;
float WP_VAL = 256;
float WP_AKSU = 1024;
float WP_MP5 = 2048;
float WP_VSS = 4096;
float WP_GAUSS = 8192;
float WP_SPAS = 16384;

float SLOT_AMOUNT = 7;
.float slot[SLOT_AMOUNT];

float IsSniper(float weapon)
{
	if(weapon == WP_SNIPER || weapon == WP_SVD || weapon == WP_VSS || weapon == WP_GAUSS) return 1;
	return 0;
}

//Stats
.float picked_items;
.float total_shots;
.float total_hits;
.float total_items;
.float item;

.vector task_pos;
.string task;


.float medkits;
.float grenadetime;
.vector lastAngles;
.float stopViewmodel;

.float pages;


//MONEY SYSTEM
.float money;



////////////// ITEMS /////////////////

float ITEM_9X18 = -2;
float ITEM_9X19 = -3;
float ITEM_9X39 = -4;
float ITEM_545X39 = -5;
float ITEM_762x54 = -6;
float ITEM_SHELLS = -7;
float ITEM_BATTS = -8;
float ITEM_MEDKIT = -9;
float ITEM_GRENADE = -10;



string GetSlotIcon(float id)
{
	if(id == WP_AK74) return "gfx/icon_ak74";
	if(id == WP_AKSU) return "gfx/icon_aksu";
	if(id == WP_VAL) return "gfx/icon_val";
	if(id == WP_GAUSS) return "gfx/icon_gauss";
	if(id == WP_SVD) return "gfx/icon_svd";
	if(id == WP_VSS) return "gfx/icon_vss";
	if(id == WP_MP5) return "gfx/icon_mp5";
	if(id == WP_SPAS) return "gfx/icon_spas";
	if(id == WP_MOSS) return "gfx/icon_moss";
	if(id == WP_PISTOL) return "gfx/icon_pm";
	if(id == WP_KNIFE) return "gfx/icon_knife";
	
	if(id == ITEM_MEDKIT) return "gfx/medkit";
	if(id == ITEM_9X18) return "gfx/sb_9x18";
	if(id == ITEM_9X19) return "gfx/sb_9x19";
	if(id == ITEM_9X39) return "gfx/sb_9x39";
	if(id == ITEM_545X39) return "gfx/sb_545x39";
	if(id == ITEM_762x54) return "gfx/sb_762x54";
	if(id == ITEM_SHELLS) return "gfx/sb_shells";
	if(id == ITEM_GRENADE) return "gfx/sb_rocket";
	if(id == ITEM_BATTS) return "gfx/sb_batts";
	
	return "";
}

string GetSlotItemName(float id)
{
	if(id == WP_AK74) return "AK-74";
	if(id == WP_AKSU) return "AKsu";
	if(id == WP_VAL) return "VAL";
	if(id == WP_GAUSS) return "Gauss rifle";
	if(id == WP_SVD) return "SVD";
	if(id == WP_VSS) return "VSS";
	if(id == WP_MP5) return "MP5";
	if(id == WP_SPAS) return "SPAS";
	if(id == WP_MOSS) return "Mossberg";
	if(id == WP_PISTOL) return "PM";
	if(id == WP_KNIFE) return "Knife";
	
	if(id == ITEM_MEDKIT) return "Medkit";
	if(id == ITEM_9X18) return "9x18 ammo";
	if(id == ITEM_9X19) return "9x19 ammo";
	if(id == ITEM_9X39) return "9x39 ammo";
	if(id == ITEM_545X39) return "5.45x39 ammo";
	if(id == ITEM_762x54) return "7.62x54 ammo";
	if(id == ITEM_SHELLS) return "Shotgun ammo";
	if(id == ITEM_BATTS) return "Batteries";
	if(id == ITEM_GRENADE) return "Grenade";
	
	return "";
}


float GetItemID(string name)
{
	name = strtoupper(name);
	if(name == "AK74") return WP_AK74;
	if(name ==  "AKSU") return WP_AKSU;
	if(name ==  "MP5") return WP_MP5;
	if(name ==  "VAL") return WP_VAL;
	if(name ==  "SPAS") return WP_SPAS;
	if(name ==  "MOSS") return WP_MOSS;
	if(name ==  "VSS") return WP_VSS;
	if(name ==  "SVD") return WP_SVD;
	if(name ==  "GAUSS") return WP_GAUSS;
	
	if(name == "9X18") return ITEM_9X18;
	if(name == "9X19") return ITEM_9X19;
	if(name == "9X39") return ITEM_9X39;
	if(name == "545X39") return ITEM_545X39;
	if(name == "762X54") return ITEM_762x54;
	if(name == "SHELLS") return ITEM_SHELLS;
	if(name == "BATTS") return ITEM_BATTS;
	if(name == "MEDKIT") return ITEM_MEDKIT;
	if(name == "GRENADE") return ITEM_GRENADE;
	
	return 0;
}

float GetPriceFromID(float id)
{
	if(id == WP_AKSU) return 800;
	if(id == WP_AK74) return 1000;
	if(id == WP_MP5) return 1500;
	if(id == WP_VAL) return 5000;
	if(id == WP_MOSS) return 4000;
	if(id == WP_SPAS) return 5500;
	if(id == WP_GAUSS) return 22000;
	if(id == WP_SVD) return 12500;
	if(id == WP_VSS) return 10500;
	
	if(id == ITEM_9X18) return 40;
	if(id == ITEM_9X19) return 90;
	if(id == ITEM_545X39) return 120;
	if(id == ITEM_9X39) return 150;
	if(id == ITEM_762x54) return 200;
	if(id == ITEM_SHELLS) return 150;
	if(id == ITEM_BATTS) return 500;
	if(id == ITEM_MEDKIT) return 400;
	if(id == ITEM_GRENADE) return 300;
	
	return 0;
}
