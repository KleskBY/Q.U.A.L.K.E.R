

void PlayerPrecache();
void WeaponsPrecache();
void PlayerFootstepsPrecache();
void PlayerAmbientPrecache();
void GibPrecache();

void MISC_Precache()
{
	precache_sound("misc/talk.wav");

	precache_sound("misc/h2ohit1.wav");
	precache_sound("misc/item_respawn.wav");
	
	precache_model("models/weapons/v_med.md3");
};


void Precache()
{
	PlayerPrecache();
	PlayerFootstepsPrecache();
	PlayerAmbientPrecache();
	WeaponsPrecache();
	MISC_Precache();
	GibPrecache();
};