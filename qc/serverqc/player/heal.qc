

void() PlayerThink;
void CycleWeaponReverseCommand();
void CycleWeaponCommand();
void() player_heal = 
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + 0.025;
	self.think = player_heal;
	
	self.reload = TRUE;
	self.blockSwitch = TRUE;
	if(self.weaponframe == 60) 
	{
		sound(self, CHAN_AUTO, "player/heal.wav", random(0.3, 0.8), SoundRadius(400));
		stuffcmd (self, "bf .1 .6 .1\n");
	}
	if(self.weaponframe > 70 && self.weaponframe < 120)
	{
		T_HealSelf(self, 1, FALSE);
	}
	if(self.weaponframe > 120)
	{
		self.reload = FALSE;
		self.blockSwitch = FALSE;
		self.think = PlayerThink;
		self.weaponSelect();
		self.weaponSwitch();
	}
};

void PlayerHeal()
{
	self.impulse = 0;
	if(!IsAllive(self)) return;
	if(self.health >= 100) return;
	if(self.medkits <= 0) return;
	if(self.think == player_heal) return;
	self.medkits = self.medkits - 1;
	
	self.weaponmodel = "models/weapons/v_med.md3";
	setmodel(self.viewmodel, self.weaponmodel);
	sound(self, CHAN_AUTO, "player/switch.wav", random(0.3, 0.8), SoundRadius(400));
	
	self.think = player_heal;
	self.nextthink = time + 0.03;
};