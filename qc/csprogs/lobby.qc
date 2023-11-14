

void StartLobby()
{
	setsensitivityscale(1);
	showCursor = false;
	localcmd(strcat("say /map ", exec));
};

void KickPlayer()
{
	localcmd(strcat("say /kick ", exec));

};

string oldgamemode;
string olddiff;
void DrawLobbyMenu()
{
	if(mapname != "maps/lobby.bsp") return;
	
	
	setsensitivityscale(0);
	showCursor = true;

	drawfill([font_size * 2, font_size * 3], [vid_x / 2, vid_y - font_size * 6], '0.1 0.1 0.1', 0.5, 0);
	drawfill([font_size * 2, font_size * 3], [vid_x / 2, font_size], '0.9 0.9 0.9', 0.45, 0);
	// text_center("LOBBY", [font_size * 2, font_size * 4]);
	text("LOBBY", [font_size * 12, font_size * 3]);

	text("Game mode:", [font_size * 2, font_size * 4]);
	string gamemode = combobox([vid_x / 2 - font_size * 8, font_size * 4], 8, "COOP|DeathMatch|Survival", "saved1", 3);
	if(oldgamemode != gamemode)
	{
		oldgamemode = gamemode;
		localcmd(strcat("say /gamemode ", cvar_string("saved1")));
	}

	text("Difficulty:", [font_size * 2, font_size * 6]);
	string diff = combobox([vid_x / 2 - font_size * 8, font_size * 6], 8, "Easy|Normal|Hard|Nightmare", "skill", 4);
	if(olddiff != diff)
	{
		olddiff = diff;
		localcmd(strcat("say /skill ", cvar_string("skill")));
	}
	
	text("Map:      ", [font_size * 2, font_size * 8]);
	// if(cvar("saved1") != cvar("temp1"))
	// {
		// cvar_set("temp1", ftos(cvar("saved1")));
		// cvar_set("saved2", "0");
	// }
	local string map;
	if(cvar("saved1") == MODE_COOP) map = combobox([vid_x / 2 - font_size * 8, font_size * 8], 8, "lost_village.obj|lab.obj|e1m1|e1m2|e1m3|e1m4|e1m5|e1m6|e1m7|e1m8", "saved2", 10);
	if(cvar("saved1") == MODE_DM) map = combobox([vid_x / 2 - font_size * 8, font_size * 8], 8, "stalker.obj|Cordon|Factory", "saved2", 3);
	if(cvar("saved1") == MODE_SURV) map = combobox([vid_x / 2 - font_size * 8, font_size * 8], 8, "wild.obj", "saved2", 1);
	
	drawpic([font_size * 4, font_size * 10], strcat("maps/", map), [vid_x / 2 - font_size * 4, vid_y / 2], '1 1 1', 1, 0);

	button("START", [font_size * 13, vid_y - font_size * 5], StartLobby, map);
	
	

	drawfill([vid_x / 2 + font_size * 3, font_size * 3], [vid_x / 2 - font_size * 5, vid_y - font_size * 6], '0.1 0.1 0.1', 0.5, 0);
	drawfill([vid_x / 2 + font_size * 3, font_size * 3], [vid_x / 2 - font_size * 5, font_size], '0.9 0.9 0.9', 0.45, 0);
	text("PLAYERS", [vid_x / 2 + font_size * 12, font_size * 3]);


	local float offset = 0;
	local float i;
	for(i = 0; i < 32; i++)
	{
		local string player_name = getplayerkeyvalue(i, "name");
		if(player_name != "" || player_name)
		{
			button("KICK", [vid_x - font_size * 6, font_size * 4 + offset], KickPlayer, player_name);
			if(player_localnum == i) player_name = strcat("> ", player_name);
			scoresboard_text([vid_x / 2 + font_size * 3, font_size * 4 + offset], player_name, " ");
			offset = offset + font_size;
		}
	}
};