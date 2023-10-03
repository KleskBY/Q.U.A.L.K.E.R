
void() CheatCommand =
{
	if (deathmatch || coop) return;
	
	self.slot[4] = WP_GAUSS;
	self.slot[3] = WP_VAL;
	self.ammo9x39 = 200;
	self.ammoBat = 200;
	self.ammo9x18 = 200;
	self.ammoGrenades = 100;
	self.ammoShells = 100;
	self.money = 99999;

	self.impulse = 0;
	W_SetCurrentAmmo();
};


void() ServerflagsCommand =
{
	if (deathmatch) return;
	serverflags = serverflags * 2 + 1;
};

void() W_ChangeWeapon;
void() CycleWeaponCommand;
void() CycleWeaponReverseCommand;

void() DropWeapon;
void() flashlight_toggle;
// void(float num) DropItem;
// void(float num) UseItem;
// void() info_loot;
void() ImpulseCommands =
{
	if (self.blockSwitch) return;
	if (self.impulse >= 1 && self.impulse <= 8) W_ChangeWeapon();
	if (self.impulse == 9) CheatCommand();
	if (self.impulse == 10) CycleWeaponCommand();
	if (self.impulse == 12) CycleWeaponReverseCommand();
	if (self.impulse == 11) ServerflagsCommand();
	
	if (self.impulse == 13) DropWeapon();
	if (self.impulse == 14) flashlight_toggle();//Flashlight
	if (self.impulse == 15) //Healing
	{
		self.weaponframe = 0;
		Heal();
	}
	
	if (self.impulse == 100) //Reloading
	{
		self.impulse = 0;
		if(!self.reload && self.weaponReload) self.weaponReload();
	}
}