

void() ambient_precahe;

void() PLAYER_Precache
{
	precache_model2("models/player.md3");
	precache_model2("models/shrap.md3");
	precache_model2("models/shells/pistolShell.md3");
	precache_model2("models/shells/shotgunShell.md3");
	precache_model2("models/shells/rifleShell.md3");
	precache_model2("models/glass.md3");
	precache_model2("models/gib1.md3");
	precache_model2("models/gib2.md3");
	precache_model2("models/gib3.md3");
	precache_model2("models/muzzle.md3");
	precache_model2("models/muzzle2.md3");
	precache_model2("models/weapons/v_med.md3");

	precache_sound2("player/jump1.wav");
	precache_sound2("player/land1.wav");
	precache_sound2("player/land2.wav");
	precache_sound2("player/ladder1.wav");
	precache_sound2("player/ladder2.wav");
	precache_sound2("player/ladder3.wav");
	precache_sound2("player/ladder4.wav");
	precache_sound2("player/footstep1.wav");
	precache_sound2("player/footstep2.wav");
	precache_sound2("player/footstep3.wav");
	precache_sound2("player/footstep4.wav");
	precache_sound2("player/heal.wav");
	precache_sound2("player/pickup.wav");
	precache_sound2("player/switch.wav");
	precache_sound2("player/pain01.wav");
	precache_sound2("player/pain02.wav");
	precache_sound2("player/pain03.wav");
	precache_sound2("player/pain04.wav");
	precache_sound2("player/pain05.wav");
	precache_sound2("player/pain06.wav");
	precache_sound2("player/pain07.wav");
	precache_sound2("player/pain08.wav");
	precache_sound2("player/pain09.wav");
	precache_sound2("player/pain10.wav");
	precache_sound2("player/pain11.wav");
	precache_sound2("player/pain12.wav");
	precache_sound2("player/pain13.wav");
	precache_sound2("player/pain14.wav");
	precache_sound2("player/pain15.wav");
	precache_sound2("player/pain16.wav");
	precache_sound2("player/pain17.wav");
	precache_sound2("player/pain18.wav");
	precache_sound2("player/pain19.wav");
	precache_sound2("player/pain20.wav");
	precache_sound2("player/pain21.wav");
	precache_sound2("player/pain22.wav");
	precache_sound2("player/pain23.wav");
	
	precache_sound2("player/death01.wav");
	precache_sound2("player/death02.wav");
	precache_sound2("player/death03.wav");
	precache_sound2("player/death04.wav");
	precache_sound2("player/death05.wav");
	
	precache_sound2("player/gib.wav");
	
	ambient_precahe();
};

void MISC_Precache()
{
	precache_sound2("impacts/hit1.wav");
	precache_sound2("impacts/hit2.wav");
	precache_sound2("impacts/hit3.wav");
	precache_sound2("impacts/hit4.wav");
	
	precache_sound2("impacts/metal1.wav");
	precache_sound2("impacts/metal2.wav");
	precache_sound2("impacts/metal3.wav");
	precache_sound2("impacts/metal4.wav");
	precache_sound2("impacts/metal5.wav");
	
	precache_sound2("impacts/wood1.wav");
	precache_sound2("impacts/wood2.wav");
	precache_sound2("impacts/wood3.wav");
	precache_sound2("impacts/wood4.wav");
	
	precache_sound2("impacts/body1.wav");
	precache_sound2("impacts/body2.wav");
	precache_sound2("impacts/body3.wav");
	precache_sound2("impacts/body4.wav");
	precache_sound2("impacts/body5.wav");
	
	precache_sound2("impacts/ric1.wav");
	precache_sound2("impacts/ric2.wav");
	
	precache_sound2("weapons/shell1.wav");
	precache_sound2("weapons/shell2.wav");
	precache_sound2("misc/talk.wav");

	precache_sound2("misc/h2ohit1.wav");
	precache_sound2("misc/item_respawn.wav");
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