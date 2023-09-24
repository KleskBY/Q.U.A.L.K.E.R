

////////////////////////////////////////
///////////////// DEFS /////////////////
////////////////////////////////////////


float	FL_LADDERJUMP			= 8192;	// for ladders

//Half-life player size (real world scale)
// vector STAND_SIZE_MIN = '-16 -16 -36';
// vector STAND_SIZE_MAX = '16 16 36';

//Quakeplayer size (1.5m gnome scale)
vector STAND_SIZE_MIN = '-16 -16 -24';
vector STAND_SIZE_MAX = '16 16 32';

vector DUCK_SIZE_MIN = STAND_SIZE_MIN;
vector DUCK_SIZE_MAX = STAND_SIZE_MAX - '0 0 20';

float AUTOJUMP = 1;
float JUMPCOOLDOWN = 0.85;
float AUTOBOTS = 0;
float AUTORELOAD = 1;
float PUSHING_FACTOR = 5;
float CHECK_SURFACE = 0;

float HITBOX_HEAD = 1;
float HITBOX_LEGS = 0;
float HITBOX_BODY = -1;

////////////// WEAPONS /////////////////

float WP_KNIFE = 1;
float WP_PISTOL = 2;
float WP_RIFLE = 4;
float WP_AK74 = 4;
float WP_SHOT = 8;
float WP_SHOTGUN = 8;
float WP_MOSS = 8;
float WP_SNIPER = 16;
float WP_SVD = 16;
float WP_GRENADE = 32;
float WP_HAMMER = 64;
float WP_COLT = 2;
float WP_VAL = 256;
float WP_BARRET = 512;
float WP_AKSU = 1024;
float WP_MP5 = 2048;
float WP_VSS = 4096;
float WP_GAUSS = 8192;
float WP_SPAS = 16384;

float IsSniper(float weapon)
{
	if(weapon == WP_SNIPER || weapon == WP_SVD || weapon == WP_VSS || weapon == WP_GAUSS) return 1;
	return 0;
}




float SoundRadius(float radius)
{
	return (800 / radius); //	return ((cvar("snd_soundradius") / 1.5) / radius);
}


float MODE_COOP = 0;
float MODE_DM = 1;
float MODE_TDM = 2;


float STAT_ZOOM = 32;
float STAT_TOTALITEMS = 33;
float STAT_PICKED_ITEMS = 34;
float STAT_SHOTS = 35;
float STAT_HITS = 36;
float STAT_MEDKITS = 37;

float STATE_IDLE = 1;
float STATE_AIM = 2;
float STATE_RUN = 4;
float STATE_CROUCH = 8;


////////////////////////////////////////
//////////////// FIELDS ////////////////
////////////////////////////////////////

.float state;
.float reload;
.float blockSwitch;
.float hgrenade;
.float hitbox;
.float duck;
.float walk;
.float ShootsFired;
.float ammo9x18, ammo9x19, ammo545x39, ammo9x39, ammo745x54, ammoShells, ammoGrenades, ammoBat;
.float medkits;

.void() weaponAttack;
.void() weaponSwitch;
.void() weaponReload;
.void() weaponSelect;

.float slot1;
.float slot2;
.float slot3;
.float slot4;
.float slot5;
.float slot6;
float SLOT_AMOUNT = 6;
// .float slot[6];

.float currentClip;
.float weaponfired;
.float grenadetime;
.float weapons;
.float item;

.float picked_items;
.float total_shots;
.float total_hits;
.vector task_pos;
.string task;

.entity hook;
.float hooking;
.float timer;
.vector lastAngles;

.float lastTouch;
.float anim_finished;
.float footstep_finished;
.float lastNametag;


.entity gun;
.entity viewmodel;

.float() checkAttack;




