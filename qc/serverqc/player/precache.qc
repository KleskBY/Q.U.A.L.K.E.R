


void PrecachePlayerPain()
{
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
};

void PrecachePlayerDeath()
{
	precache_sound("player/death01.wav");
	precache_sound("player/death02.wav");
	precache_sound("player/death03.wav");
	precache_sound("player/death04.wav");
	precache_sound("player/death05.wav");
};

void PlayerPrecache()
{
	precache_model("models/shrap.md3");

	precache_sound("player/jump1.wav");
	precache_sound("player/land1.wav");
	precache_sound("player/land2.wav");

	precache_sound("player/gib.wav");
	precache_sound("player/heal.wav");
	precache_sound("player/pickup.wav");
	precache_sound("player/switch.wav");

	precache_model("models/muzzle.md3");
	precache_model("models/muzzle2.md3");
	
	PrecachePlayerPain();
	PrecachePlayerDeath();
	
	precache_sound("player/ladder1.wav");
	precache_sound("player/ladder2.wav");
	precache_sound("player/ladder3.wav");
	precache_sound("player/ladder4.wav");
	
	precache_sound("misc/h2ohit1.wav");
	
	precache_sound("weapons/shell1.wav");
	precache_sound("weapons/shell2.wav");
	
	precache_sound("player/breath.wav");
	precache_sound("misc/null.wav");

};
