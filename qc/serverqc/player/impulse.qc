
void() W_ChangeWeapon;
void() CycleWeaponCommand;
void() CycleWeaponReverseCommand;
void() DropWeapon;
void() PlayerHeal;
void ImpulseCommands()
{
	if (self.blockSwitch) return;
	if (self.impulse >= 1 && self.impulse <= 8) W_ChangeWeapon();
	//if (self.impulse == 9) CheatCommand();
	if (self.impulse == 10) CycleWeaponCommand();
	if (self.impulse == 12) CycleWeaponReverseCommand();
	//if (self.impulse == 11) ServerflagsCommand();
	
	if (self.impulse == 13) DropWeapon();
	if (self.impulse == 15) //Healing
	{
		self.weaponframe = 0;
		PlayerHeal();
	}
	
	if (self.impulse == 100) //Reloading
	{
		self.impulse = 0;
		if(!self.reload && self.weaponReload) self.weaponReload();
	}
	if (self.impulse == 14)  //flashlight
	{
		FlashlightToggle();
		self.impulse = 0;
	}
};