

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
	
	parm4 = self.slot2;
	parm5 = self.slot3;
	parm6 = self.slot4;
	parm7 = self.slot5;
	parm8 = self.slot6;
	
	parm9 = self.ammo9x18;
	parm10 = self.ammo9x19;
	parm11 = self.ammo9x39;
	parm12 = self.ammo545x39;
	parm13 = self.ammo745x54;
	parm14 = self.ammoShells;
	parm15 = self.ammoGrenades;
	parm16 = self.ammoBat;
};

void() SetNewParms =
{
	parm1 = 100;
	parm2 = WP_AK74;
	parm3 = 1;
	
	parm4 = WP_PISTOL;
	parm5 = WP_AK74;
	parm6 = 0;
	parm7 = WP_GRENADE;
	parm8 = 0;
	
	parm9 = 40;
	parm10 = 0;
	parm11 = 0;
	parm12 = 60;
	parm13 = 0;
	parm14 = 0;
	parm15 = 2;
	parm16 = 0;
};

void() SetNewParmsObserver =
{
	parm1 = 666;
	parm2 = 0;
	parm3 = 0;
	parm4 = 0;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
    parm8 = 0;
	parm9 = 0;
	parm10 = 0;
	parm11 = 0;
	parm12 = 0;
	parm13 = 0;
	parm14 = 0;
	parm15 = 0;
	parm16 = 0;
};

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
	
	self.slot1 = WP_KNIFE;
	self.slot2 = parm4;
	self.slot3 = parm5;
	self.slot4 = parm6;
	self.slot5 = parm7;
	self.slot6 = parm8;
	self.weapons = 0;
	
	self.ammo9x18 = parm9;
	self.ammo9x19 = parm10;
	self.ammo9x39 = parm11;
	self.ammo545x39 = parm12;
	self.ammo745x54 = parm13;
	self.ammoShells = parm14;
	self.ammoGrenades = parm15;
	self.ammoBat = parm16;
};












	// float f = fopen(self.netname, FILE_WRITE);
	// if(f >= 0) 
	// {
		// for(float i = 0; i < numentityfields(); i++)
		// {
			// local string tmp = strcat(getentityfieldstring(i, self), " \r\n");
			// fputs(f, tmp);
		// }
		// fclose(f);
	// }
	
	// float f = fopen(self.netname, FILE_WRITE);
	// if(f >= 0) 
	// {
		// writetofile(f, self);
		// fclose(f);
	// }
	
	
	
	
		// local string entitydata = "";
	// float f = fopen(self.netname, FILE_READ);
	// if(f >= 0) 
	// {
		// local string temp = fgets(f);
		// entitydata = temp;
		// while(strlen(temp))
		// {
			// print(temp, "\n");
			// temp = fgets(f);
			// entitydata = strcat(entitydata, temp);
		// }
		// parseentitydata(self, entitydata);
		// fclose(f);
	// }
	
	