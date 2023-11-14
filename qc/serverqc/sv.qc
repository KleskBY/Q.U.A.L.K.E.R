void(float pcolor) SV_ChangeTeam =
{
	if(deathmatch) T_Damage(self, world, world, self.health);
}

string CheckCommand(string s, string command)
{
	if(strstrofs(s, command, 0) >= 0)
	{
		string parm = substring(s, strstrofs(s, command, 0) + strlen(command) + 1, 50);
		return parm;
	}
	return "";
}

void(string s) SV_ParseClientCommand
{
	if(strlen(CheckCommand(s, "/buy")))
	{
		string purchase = CheckCommand(s, "/buy");
		ProcessBuy(self, purchase);
	}
	else if(strlen(CheckCommand(s, "/map")))
	{
		string map = CheckCommand(s, "/map");
		// entity serverAdmin = findflags(world, flags, FL_CLIENT);
		if(serverAdmin == self)
		{
			changelevel(map);
		}
	}
	else if(strlen(CheckCommand(s, "/kick")))
	{
		string parm = CheckCommand(s, "/kick");
		if(serverAdmin == self)
		{
			entity playerToKick = find(world, netname, parm);
			if(playerToKick) dropclient(playerToKick);
			else sprint(self, "Player not found!\n");
		}
	}
	else if(strlen(CheckCommand(s, "/skill")))
	{
		string diff = CheckCommand(s, "/skill");
		cvar_set ("skill", diff);
	}
	else clientcommand(self, s);
};