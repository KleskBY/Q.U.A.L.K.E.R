

// Called when a client first connects to a server.
void() SetNewParms =
{
	parm1 = 100;
	parm2 = WP_PISTOL;
	parm3 = 1;
	
	parm4 = WP_PISTOL;
	parm5 = 0;
	parm6 = 0;
	parm7 = WP_GRENADE;
	parm8 = 0;
	
	parm9 = 40;
	parm10 = 0;
	parm11 = 0;
	parm12 = 60;
	parm13 = 0;
	parm14 = 0;
	parm15 = 3;
	parm16 = 0;
};



// Call to set parms for self so they can be saved for a level transition
void() SetChangeParms = 
{
	if (self.health <= 0)
	{
		SetNewParms();
		return;
	}
	
	if (self.health > 100) self.health = 100;
	if (self.health < 50) self.health = 50;
	
	parm1 = self.health;
	parm2 = self.weapon;
	parm3 = self.medkits;
	
	parm4 = self.slot[2];
	parm5 = self.slot[3];
	parm6 = self.slot[4];
	parm7 = self.slot[5];
	parm8 = self.slot[6];
	
	parm9 = self.ammo9x18;
	parm10 = self.ammo9x19;
	parm11 = self.ammo9x39;
	parm12 = self.ammo545x39;
	parm13 = self.ammo762x54;
	parm14 = self.ammoShells;
	parm15 = self.ammoGrenades;
	parm16 = self.ammoBat;
};


//Call when spawning a client in PutClientInServer
void() DecodeLevelParms =
{
	if (serverflags)
	{
		if (world.model == "maps/start.bsp" || world.model == "maps/e1m1.bsp") SetNewParms();		// take away all stuff on starting new episode
	}
	if(!parm1 || parm1 > 600) SetNewParms();	//coop fix
	
	self.health = parm1;
	self.weapon = parm2;
	self.medkits = parm3;
	
	self.slot[1] = WP_KNIFE;
	self.slot[2] = parm4;
	self.slot[3] = parm5;
	self.slot[4] = parm6;
	self.slot[5] = parm7;
	self.slot[6] = parm8;
	self.weapons = 0;
	
	self.ammo9x18 = parm9;
	self.ammo9x19 = parm10;
	self.ammo9x39 = parm11;
	self.ammo545x39 = parm12;
	self.ammo762x54 = parm13;
	self.ammoShells = parm14;
	self.ammoGrenades = parm15;
	self.ammoBat = parm16;
};




