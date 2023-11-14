

entity serverAdmin;
void Lobby()
{
	if(!serverAdmin)
	{		
		serverAdmin = findflags(world, flags, FL_CLIENT);
		if(cvar("maxplayers") > 1)
		{
			bprint(serverAdmin.netname);
			bprint(" is now in control of the server\n");
		}
	}
	
	// if(world.model != "maps/lobby.bsp") return;
	
	float playerCount = 0;
	entity pos = FindIntermission();
	other = find(world, classname, "player");
	while (other != world)
	{
		playerCount = playerCount + 1;
		if(world.model == "maps/lobby.bsp")
		{
			if (other.viewmodel) setmodel(other.viewmodel, "");
			other.view_ofs = '0 0 0';
			other.angles = other.v_angle = pos.mangle;
			other.fixangle = TRUE; // turn this way immediately
			other.nextthink = time + 0.5;
			other.takedamage = DAMAGE_NO;
			other.solid = SOLID_NOT;
			other.movetype = MOVETYPE_NONE;
			other.modelindex = 0;
			other.health = 666;
			setorigin(other, pos.origin);
		}
		other = find(other, classname, "player");
	}
	
	if(playerCount == 0 && time > 10)
	{
		changelevel("maps/lobby.bsp");
	}
};
