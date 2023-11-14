

void() ambient_precahe;

void() PLAYER_Precache
{
	precache_model("models/player.md3");
	precache_model("models/shrap.md3");
	precache_model("models/shells/pistolShell.md3");
	precache_model("models/shells/shotgunShell.md3");
	precache_model("models/shells/rifleShell.md3");
	precache_model("models/glass.md3");
	precache_model("models/gib1.md3");
	precache_model("models/gib2.md3");
	precache_model("models/gib3.md3");
	precache_model("models/muzzle.md3");
	precache_model("models/muzzle2.md3");
	precache_model("models/weapons/v_med.md3");

	precache_sound("player/jump1.wav");
	precache_sound("player/land1.wav");
	precache_sound("player/land2.wav");
	precache_sound("player/ladder1.wav");
	precache_sound("player/ladder2.wav");
	precache_sound("player/ladder3.wav");
	precache_sound("player/ladder4.wav");
	precache_sound("player/footstep1.wav");
	precache_sound("player/footstep2.wav");
	precache_sound("player/footstep3.wav");
	precache_sound("player/footstep4.wav");
	precache_sound("player/heal.wav");
	precache_sound("player/pickup.wav");
	precache_sound("player/switch.wav");
	precache_sound("player/pain01.wav");
	precache_sound("player/pain02.wav");
	precache_sound("player/pain03.wav");
	precache_sound("player/pain04.wav");
	precache_sound("player/pain05.wav");
	precache_sound("player/pain06.wav");
	precache_sound("player/pain07.wav");
	precache_sound("player/pain08.wav");
	precache_sound("player/pain09.wav");
	precache_sound("player/pain10.wav");
	precache_sound("player/pain11.wav");
	precache_sound("player/pain12.wav");
	precache_sound("player/pain13.wav");
	precache_sound("player/pain14.wav");
	precache_sound("player/pain15.wav");
	precache_sound("player/pain16.wav");
	precache_sound("player/pain17.wav");
	precache_sound("player/pain18.wav");
	precache_sound("player/pain19.wav");
	precache_sound("player/pain20.wav");
	precache_sound("player/pain21.wav");
	precache_sound("player/pain22.wav");
	precache_sound("player/pain23.wav");
	
	precache_sound("player/death01.wav");
	precache_sound("player/death02.wav");
	precache_sound("player/death03.wav");
	precache_sound("player/death04.wav");
	precache_sound("player/death05.wav");
	
	precache_sound("player/gib.wav");
	
	ambient_precahe();
};

void MISC_Precache()
{
	precache_sound("impacts/hit1.wav");
	precache_sound("impacts/hit2.wav");
	precache_sound("impacts/hit3.wav");
	precache_sound("impacts/hit4.wav");
	
	precache_sound("impacts/metal1.wav");
	precache_sound("impacts/metal2.wav");
	precache_sound("impacts/metal3.wav");
	precache_sound("impacts/metal4.wav");
	precache_sound("impacts/metal5.wav");
	
	precache_sound("impacts/wood1.wav");
	precache_sound("impacts/wood2.wav");
	precache_sound("impacts/wood3.wav");
	precache_sound("impacts/wood4.wav");
	
	precache_sound("impacts/body1.wav");
	precache_sound("impacts/body2.wav");
	precache_sound("impacts/body3.wav");
	precache_sound("impacts/body4.wav");
	precache_sound("impacts/body5.wav");
	
	precache_sound("impacts/ric1.wav");
	precache_sound("impacts/ric2.wav");
	
	precache_sound("weapons/shell1.wav");
	precache_sound("weapons/shell2.wav");
	precache_sound("misc/talk.wav");

	precache_sound("misc/h2ohit1.wav");
	precache_sound("misc/item_respawn.wav");
};

void() Precache
{
	PLAYER_Precache();
	MISC_Precache();

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
};