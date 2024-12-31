


void ShellsPrecache()
{
	precache_model("models/shells/pistolShell.md3");
	precache_model("models/shells/shotgunShell.md3");
	precache_model("models/shells/rifleShell.md3");
	precache_sound("weapons/shell1.wav");
	precache_sound("weapons/shell2.wav");
};



void WeaponsPrecache()
{
	KNIFE_Precache();
	PM_Precache();
	AK74_Precache();
	GRENADE_Precache();
	MOSS_Precache();
	SVD_Precache();
	AKSU_Precache();
	GAUSS_Precache();
	MP5_Precache();
	SPAS_Precache();
	SVD_Precache();
	VAL_Precache();
	VSS_Precache();
	BOLT_Precache();
	
	ShellsPrecache();
	ImpactSoundPrecache();
};