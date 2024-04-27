

float MENU_MAIN = 1;

float MENU_OPTIONS = 2;
float MENU_GRAPHICS = 3;
float MENU_RESOLUTION = 4;
float MENU_CONTROLS = 5;
float MENU_AUDIO = 6;

float MENU_SINGLEPLAYER= 7;
float MENU_LOAD = 8;
float MENU_SAVE = 9;

float MENU_MULTIPLAYER = 10;
float MENU_MULTIPLAYER_HOST = 11;

float SERVER_ONCE;
float SERVER_PAGE_SIZE = 9;
float SERVER_NAME_MAX = 18;
float SERVER_MAP_MAX = 8;
float SERVER_SKIP;
float SERVER_TOTAL;


/////////////////////////////////////////////////////////////////////
/////////////////////////	DRAW	/////////////////////////////////
/////////////////////////////////////////////////////////////////////


void(float a, float b) m_draw = 
{
	if(!menu) return;
	if (clientstate() != CS_CONNECTED) drawpic('0 0 0', "gfx/background", vid, '1 1 1', 1, 0);
	else drawfill('0 0 0', vid, '0 0 0', 0.45, 0);
	
	UpdateMouse();
	GetRelative();
	
	local float i;
	if(menu == MENU_MAIN)
	{
		SERVER_ONCE = 0;
		button("Singleplayer", [font_size * 2, vid_y - font_size * 10], page, ftos(MENU_SINGLEPLAYER));
		button("Multiplayer", [font_size * 2, vid_y - font_size * 8], page, ftos(MENU_MULTIPLAYER));
		button("Options", [font_size * 2, vid_y - font_size * 6], page, ftos(MENU_OPTIONS));
		if (clientstate() != CS_CONNECTED || isdemo()) button("Quit", [font_size * 2, vid_y - font_size * 4], command, "quit\n");
		else button("Quit", [font_size * 2, vid_y - font_size * 4], command, "disconnect\n");
		drawstring([vid_x - font_size / 2 * 20, vid_y - font_size], "discord.gg/edjjw8T", [font_size / 2, font_size / 2], '1 1 1', 1, 0);
	}
	else if(menu == MENU_OPTIONS)
	{
		button("Graphics", [font_size * 2, vid_y - font_size * 12], page, ftos(MENU_GRAPHICS));
		button("Resolution", [font_size * 2, vid_y - font_size * 10], page, ftos(MENU_RESOLUTION));
		button("Controls", [font_size * 2, vid_y - font_size * 8], page, ftos(MENU_CONTROLS));
		button("Audio", [font_size * 2, vid_y - font_size * 6], page, ftos(MENU_AUDIO));
		
		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_MAIN));
	}
	else if(menu == MENU_GRAPHICS)
	{
		text("GRAPHICS", [vid_x / 2 - font_size * 4, font_size * 2]);
		
		text("Lighting:", [font_size * 2, font_size * 4]);
		button("Low", [font_size * 2 + font_size * 10, font_size * 4], command, "r_coronas 1;gl_flashblend 1;r_shadow_gloss 0;r_shadow_realtime_dlight 0;r_shadow_realtime_dlight_shadows 0;r_shadow_realtime_world 0;r_shadow_realtime_world_lightmaps 0;r_shadow_realtime_world_shadows 1;r_bloom 0");
		button("Normal", [font_size * 2 + font_size * 20, font_size * 4], command, "r_coronas 1;gl_flashblend 0;r_shadow_gloss 1;r_shadow_realtime_dlight 1;r_shadow_realtime_dlight_shadows 0;r_shadow_realtime_world 0;r_shadow_realtime_world_lightmaps 0;r_shadow_realtime_world_shadows 1;");
		button("High", [font_size * 2 + font_size * 30, font_size * 4], command, "r_coronas 1;gl_flashblend 0;r_shadow_gloss 1;r_shadow_realtime_dlight 1;r_shadow_realtime_dlight_shadows 1;r_shadow_realtime_world 0;r_shadow_realtime_world_lightmaps 0;r_shadow_realtime_world_shadows 1;");
		button("Maximum", [font_size * 2 + font_size * 40, font_size * 4], command, "r_coronas 1;gl_flashblend 0;r_shadow_gloss 1;r_shadow_realtime_dlight 1;r_shadow_realtime_dlight_shadows 1;r_shadow_realtime_world 1;r_shadow_realtime_world_lightmaps 0;r_shadow_realtime_world_shadows 1;");
		
		text("Effects:", [font_size * 2, font_size * 6]);
		button("Low", [font_size * 2 + font_size * 10, font_size * 6], command, "cl_particles 1;cl_particles_quake 1;cl_particles_quality 1;cl_particles_explosions_shell 0;r_explosionclip 1;cl_stainmaps 0;cl_stainmaps_clearonload 1;cl_decals 0;cl_particles_bulletimpacts 1;cl_particles_smoke 1;cl_particles_sparks 1;cl_particles_bubbles 1;cl_particles_blood 1;cl_particles_blood_alpha 1;cl_particles_blood_bloodhack 0;cl_beams_polygons 0;cl_beams_instantaimhack 0;cl_beams_quakepositionhack 1;cl_beams_lightatend 0;r_lerpmodels 1;r_lerpsprites 1;r_lerplightstyles 0;gl_polyblend 1;r_skyscroll1 1;r_skyscroll2 2;r_waterwarp 1;r_wateralpha 1;r_waterscroll 1\n");
		button("Normal", [font_size * 2 + font_size * 20, font_size * 6], command, "cl_particles 1;cl_particles_quake 0;cl_particles_quality 1;cl_particles_explosions_shell 0;r_explosionclip 1;cl_stainmaps 0;cl_stainmaps_clearonload 1;cl_decals 1;cl_particles_bulletimpacts 1;cl_particles_smoke 1;cl_particles_sparks 1;cl_particles_bubbles 1;cl_particles_blood 1;cl_particles_blood_alpha 1;cl_particles_blood_bloodhack 1;cl_beams_polygons 1;cl_beams_instantaimhack 0;cl_beams_quakepositionhack 1;cl_beams_lightatend 0;r_lerpmodels 1;r_lerpsprites 1;r_lerplightstyles 0;gl_polyblend 1;r_skyscroll1 1;r_skyscroll2 2;r_waterwarp 1;r_wateralpha 1;r_waterscroll 1\n");
		button("High", [font_size * 2 + font_size * 30, font_size * 6], command, "cl_particles 1;cl_particles_quake 0;cl_particles_quality 2;cl_particles_explosions_shell 0;r_explosionclip 1;cl_stainmaps 1;cl_stainmaps_clearonload 1;cl_decals 1;cl_particles_bulletimpacts 1;cl_particles_smoke 1;cl_particles_sparks 1;cl_particles_bubbles 1;cl_particles_blood 1;cl_particles_blood_alpha 1;cl_particles_blood_bloodhack 1;cl_beams_polygons 1;cl_beams_instantaimhack 0;cl_beams_quakepositionhack 1;cl_beams_lightatend 0;r_lerpmodels 1;r_lerpsprites 1;r_lerplightstyles 0;gl_polyblend 1;r_skyscroll1 1;r_skyscroll2 2;r_waterwarp 1;r_wateralpha 1;r_waterscroll 1\n");
		
		text("Gamma:", [font_size * 2, font_size * 8]);
		slider([font_size * 2 + font_size * 14, font_size * 8], [vid_x /2, 2], "v_gamma", 0.1, 2, 0.1);
		
		text("Contrast:", [font_size * 2, font_size * 10]);
		slider([font_size * 2 + font_size * 14, font_size * 10], [vid_x /2, 2], "v_contrast", 0.1, 2, 0.1);
		
		checkbox("Bloom:", [font_size * 2, font_size * 12], "r_bloom");
		checkbox("V-Sync:", [font_size * 2, font_size * 14], "vid_vsync");
		checkbox("Show FPS:", [font_size * 2, font_size * 16], "showfps");
		checkbox("FXAA:", [font_size * 2, font_size * 18], "r_fxaa");
		checkbox("Realtime:", [font_size * 2, font_size * 20], "r_shadow_realtime_world");
		
		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_OPTIONS));
	}
	else if(menu == MENU_CONTROLS)
	{
		text("MOUSE", [vid_x / 2 - font_size * 2.5, font_size * 2]);
		
		text("Sensitivity:", [font_size * 2, font_size * 4]);
		slider([font_size * 2 + font_size * 14, font_size * 4], [vid_x /2, 2], "sensitivity", 0.1, 6, 0.1);
		checkbox("Smoothing:", [font_size * 2, font_size * 6], "m_filter");
		
		text("KEYS", [vid_x / 2 - font_size * 2, font_size * 8]);
		
		keybind("Attack:", [font_size * 2, font_size * 10], "+attack");
		keybind("Scope:", [font_size * 2, font_size * 12], "+button5");
		keybind("Next weapon:", [font_size * 2, font_size * 14], "impulse 10");
		keybind("Prev weapon:", [font_size * 2, font_size * 16], "impulse 12");
		keybind("Crouch:", [font_size * 2, font_size * 18], "+button3");
		keybind("Jump:", [font_size * 2, font_size * 20], "+jump");
		keybind("Use:", [font_size * 2, font_size * 22], "+use");
		
		keybind("Forward:", [vid_x - font_size * 20, font_size * 10], "+forward");
		keybind("Back:", [vid_x - font_size * 20, font_size * 12], "+back");
		keybind("Left:", [vid_x - font_size * 20, font_size * 14], "+moveleft");
		keybind("Right:", [vid_x - font_size * 20, font_size * 16], "+moveright");
		keybind("Reload:", [vid_x - font_size * 20, font_size * 18], "reload");
		keybind("Drop weapon:", [vid_x - font_size * 20, font_size * 20], "drop");
		keybind("Chat:", [vid_x - font_size * 20, font_size * 22], "messagemode");
		
		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_OPTIONS));
	}
	else if(menu == MENU_RESOLUTION)
	{
		text("4:3", [font_size * 2, font_size * 2]);
		button("640x480", [font_size * 2, font_size * 4], command, "vid_width 640; vid_height 480; \n");
		button("800x600", [font_size * 2, font_size * 6], command, "vid_width 800; vid_height 600; \n");
		button("1024x768", [font_size * 2, font_size * 8], command, "vid_width 1024; vid_height 768; \n");
		button("1400x1050", [font_size * 2, font_size * 10], command, "vid_width 1400; vid_height 1050; \n");
		button("1440x1080", [font_size * 2, font_size * 12], command, "vid_width 1440; vid_height 1080; \n");
		button("1600x1200", [font_size * 2, font_size * 14], command, "vid_width 1600; vid_height 1200; \n");
		button("1856x1392", [font_size * 2, font_size * 16], command, "vid_width 1856; vid_height 1392; \n");
		button("1920x1440", [font_size * 2, font_size * 18], command, "vid_width 1920; vid_height 1440; \n");
		
		text("16:9", [vid_x / 2 - font_size * 4, font_size * 2]);
		button("1024x576", [vid_x / 2 - font_size * 4, font_size * 4], command, "vid_width 1024; vid_height 576; \n");
		button("1152x600", [vid_x / 2 - font_size * 4, font_size * 6], command, "vid_width 1152; vid_height 648; \n");
		button("1280x720", [vid_x / 2 - font_size * 4, font_size * 8], command, "vid_width 1280; vid_height 720; \n");
		button("1366x768", [vid_x / 2 - font_size * 4, font_size * 10], command, "vid_width 1366; vid_height 768; \n");
		button("1600x900", [vid_x / 2 - font_size * 4, font_size * 12], command, "vid_width 1600; vid_height 900; \n");
		button("1920x1080", [vid_x / 2 - font_size * 4, font_size * 14], command, "vid_width 1920; vid_height 1080; \n");
		button("2560x1440", [vid_x / 2 - font_size * 4, font_size * 16], command, "vid_width 2560; vid_height 1440; \n");
		button("3840x2160", [vid_x / 2 - font_size * 4, font_size * 18], command, "vid_width 3840; vid_height 2160; \n");
		
		text("16:10", [vid_x / 2 + font_size * 12, font_size * 2]);
		button("1280x800", [vid_x / 2 + font_size * 12, font_size * 4], command, "vid_width 1280; vid_height 800; \n");
		button("1440x900", [vid_x / 2 + font_size * 12, font_size * 6], command, "vid_width 1440; vid_height 900; \n");
		button("1680x1050", [vid_x / 2 + font_size * 12, font_size * 8], command, "vid_width 1680; vid_height 1050; \n");
		button("1920x1200", [vid_x / 2 + font_size * 12, font_size * 10], command, "vid_width 1920; vid_height 1200; \n");
		button("2560x1600", [vid_x / 2 + font_size * 12, font_size * 12], command, "vid_width 2560; vid_height 1600; \n");

		checkbox("Fullscreen:", [font_size * 2, vid_y - font_size * 6], "vid_fullscreen");
		button("Apply", [vid_x / 2 + font_size * 12, vid_y - font_size * 6], command, "menu_restart; vid_restart; togglemenu; \n");

		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_OPTIONS));
	}
	else if(menu == MENU_AUDIO)
	{
		text("AUDIO", [vid_x / 2 - font_size * 2.5, font_size * 2]);
		
		text("Master volume:", [font_size * 2, font_size * 4]);
		slider([font_size * 2 + font_size * 16, font_size * 4], [vid_x /2, 2], "mastervolume", 0, 1, 0.1);
		
		text("Effects volume:", [font_size * 2, font_size * 6]);
		slider([font_size * 2 + font_size * 16, font_size * 6], [vid_x /2, 2], "volume", 0, 1, 0.1);
		
		text("Music volume:", [font_size * 2, font_size * 8]);
		slider([font_size * 2 + font_size * 16, font_size * 8], [vid_x /2, 2], "bgmvolume", 0, 1, 0.1);
		
		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_OPTIONS));
	}
	else if(menu == MENU_SINGLEPLAYER)
	{
		button("Story", [font_size * 2, vid_y - font_size * 12], command, "sv_cheats 1; deathmatch 0; coop 0; maxplayers 1; r_ambient 2; map lost_village.obj;\n");
		button("Survival", [font_size * 2, vid_y - font_size * 10], command, "sv_cheats 1; deathmatch 0; coop 0; maxplayers 1; r_ambient 2; map wild.obj;\n");
		button("Load", [font_size * 2, vid_y - font_size * 8], page, ftos(MENU_LOAD));
		if (clientstate() == CS_CONNECTED && !isdemo()) button("Save", [font_size * 2, vid_y - font_size * 6], page, ftos(MENU_SAVE));
		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_MAIN));
	}
	else if(menu == MENU_SAVE)
	{
		text("SAVE GAME", [vid_x / 2 - font_size * 5, font_size * 2]);
		for(i = 0; i < 10; ++i)
		{
			local string saveName = "EMPTY SLOT";
			local float hndl = fopen(strcat(ftos(i), ".sav"), FILE_READ);
			if(hndl >= 0)
			{
				saveName = fgets(hndl);
				saveName = fgets(hndl);
				saveName = strcat(ftos(i), ": ", saveName);
				saveName = strreplace("_", " ", saveName);
				fclose(hndl);
			}
			local float skip = strlen(saveName);
			button(saveName, [vid_x / 2 - font_size * skip / 2, font_size * 4 + font_size * 2 * i], command, strcat("save ", ftos(i), "; togglemenu;\n"));
		}
		
		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_SINGLEPLAYER));
	}
	else if(menu == MENU_LOAD)
	{
		text("LOAD GAME", [vid_x / 2 - font_size * 5, font_size * 2]);
		for(i = 0; i < 10; ++i)
		{
			local string saveName = "EMPTY SLOT";
			local float hndl = fopen(strcat(ftos(i), ".sav"), FILE_READ);
			if(hndl >= 0)
			{
				saveName = fgets(hndl);
				saveName = fgets(hndl);
				saveName = strcat(ftos(i), ": ", saveName);
				saveName = strreplace("_", " ", saveName);
				fclose(hndl);
				
				local float skip = strlen(saveName);
				button(saveName, [vid_x / 2 - font_size * skip / 2, font_size * 4 + font_size * 2 * i], command, strcat("sv_cheats 1; deathmatch 0; coop 0; maxplayers 1; r_ambient 3; load ", ftos(i), "\n"));
			}
			else text(saveName, [vid_x / 2 - font_size * 4, font_size * 4 + font_size * 2 * i]);
		}
		
		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_SINGLEPLAYER));
	}
	else if(menu == MENU_MULTIPLAYER)
	{
		if(!SERVER_ONCE)
		{
			SERVER_ONCE = 1;
			cmd("net_slist\n");
		}
		
		SERVER_TOTAL = gethostcachevalue(SLIST_HOSTCACHEVIEWCOUNT);
		
		text("NAME", [font_size * 2, font_size * 2]);
		text("MAP", [font_size * 2 + font_size * SERVER_NAME_MAX + font_size, font_size * 2]);
		text("SLOTS",  [font_size * 2 + font_size * SERVER_NAME_MAX + font_size * 10, font_size * 2]);
		text("PING",  [font_size * 2 + font_size * SERVER_NAME_MAX + font_size * 10 + font_size * 7, font_size * 2]);
		text(ftos(SERVER_TOTAL),  [vid_x - font_size * 2 - font_size * 5, font_size * 2]);
		
		if(SERVER_TOTAL > 0)
		{
			for(i = 0; i < SERVER_PAGE_SIZE; i++)
			{
				if(i < SERVER_TOTAL)
				{
					local float serverId = i + SERVER_SKIP;
					local float ping = gethostcachenumber(gethostcacheindexforkey("ping"), serverId);
					local string map = gethostcachestring(gethostcacheindexforkey("map"), serverId);
					local float slots = gethostcachenumber(gethostcacheindexforkey("maxplayers"), serverId);
					local float players = gethostcachenumber(gethostcacheindexforkey("numplayers"), serverId);
					local string ip = gethostcachestring(gethostcacheindexforkey("cname"), serverId);
					local string name = gethostcachestring(gethostcacheindexforkey("name"), serverId);
					local string mod = gethostcachestring(gethostcacheindexforkey("mod"), serverId);
					if(strlen(name) > SERVER_NAME_MAX) name = substring(name, 0, SERVER_NAME_MAX);
					if(strlen(map) > SERVER_MAP_MAX) map = substring(map, 0, SERVER_MAP_MAX);
					if(ping > -1 && slots > 1)
					{
						text(name, [font_size * 2, font_size * 4 + font_size * 2 * i]);
						text(map, [font_size * 2 + font_size * SERVER_NAME_MAX + font_size, font_size * 4 + font_size * 2 * i]);
						text(strcat(ftos(players), "/", ftos(slots)),  [font_size * 2 + font_size * SERVER_NAME_MAX + font_size * 10, font_size * 4 + font_size * 2 * i]);
						text(ftos(ping),  [font_size * 2 + font_size * SERVER_NAME_MAX + font_size * 10 + font_size * 7, font_size * 4 + font_size * 2 * i]);
						button("JOIN", [vid_x - font_size * 2 - font_size * 5, font_size * 4 + font_size * 2 * i], command, strcat("togglemenu; connect ", ip, "\n") );
					}
				}
			}
		}
		else 
		{
			local float f = rint(gettime() * 10) % 5;
			local string refresh = "REFRESHING";
			if(f == 1) refresh = "REFRESHING.";
			else if(f == 2) refresh = "REFRESHING..";
			else if(f == 3) refresh = "REFRESHING...";
			else if(f == 4) refresh = "REFRESHING....";
			else if(f == 5) refresh = "REFRESHING.....";
			text(refresh, [vid_x / 2 - strlen(refresh) / 2 * font_size, vid_y / 3]);
		}
		drawfill([font_size * 2, font_size * 3 + 2], [vid_x - font_size * 5, 2], '0.9 0.9 0.9', 0.45, 0);
		drawfill([font_size * 2, font_size * 21 + 2], [vid_x - font_size * 5, 2], '0.9 0.9 0.9', 0.45, 0);
		input_text("name", [font_size * 2, font_size * 22], MAX_NAME_LENGTH, "Player name:");
		button("REFRESH", [vid_x - font_size * 10, font_size * 22], command, "net_slist\n");
		
		button("HOST", [vid_x - font_size * 7, vid_y - font_size * 4], page, ftos(MENU_MULTIPLAYER_HOST));
		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_MAIN));
	}
	else if(menu == MENU_MULTIPLAYER_HOST)
	{	
		text("Game mode:", [font_size * 2, font_size * 4]);
		combobox([vid_x / 2 - font_size * 8, font_size * 4], 22, "COOP|DeathMatch|Survival", "saved1", 3);
		
		text("Map:      ", [font_size * 2, font_size * 6]);
		local string map;
		if(cvar("saved1") != cvar("temp1"))
		{
			cvar_set("temp1", ftos(cvar("saved1")));
			cvar_set("saved2", "0");
		}
		if(cvar("saved1") == MODE_COOP) map = combobox([vid_x / 2 - font_size * 8, font_size * 6], 22, "lost_village.obj|lab.obj|e1m1|e1m2|e1m3|e1m4|e1m5|e1m6|e1m7|e1m8", "saved2", 10);
		if(cvar("saved1") == MODE_DM) map = combobox([vid_x / 2 - font_size * 8, font_size * 6], 22, "stalker.obj|Cordon|Factory", "saved2", 3);
		if(cvar("saved1") == MODE_SURV) map = combobox([vid_x / 2 - font_size * 8, font_size * 6], 22, "wild.obj", "saved2", 1);
		

		text("Max players:", [font_size * 2, font_size * 8]);
		combobox([vid_x / 2 - font_size * 8, font_size * 8], 22, "2|4|6|8|10|20|100", "saved3", 9);
		text("Frag limit:", [font_size * 2, font_size * 10]);
		slider([vid_x / 2 - font_size * 8, font_size * 10], [22 * font_size, 2], "fraglimit", 0, 100, 1);
		text("Time limit:", [font_size * 2, font_size * 12]);
		slider([vid_x / 2 - font_size * 8, font_size * 12], [22 * font_size, 2], "timelimit", 0, 100, 1);
		text("Friendly fire:", [font_size * 2, font_size * 14]);
		combobox([vid_x / 2 - font_size * 8, font_size * 14], 22, "NO|YES", "teamplay", 2);
		if(cvar("saved1") == MODE_DM)
		{
			text("Bots:", [font_size * 2, font_size * 16]);
			slider([vid_x / 2 - font_size * 8, font_size * 16], [22 * font_size, 2], "saved4", 0, 20, 1);
		}
		else if(cvar("saved4") > 0) cvar_set("saved4", "0");
		text(strcat("You need to forward port ", ftos(cvar("port"))), [font_size * 2, font_size * 20]);
		
		input_text("hostname", [font_size * 2, font_size * 22], MAX_NAME_LENGTH, "Server name:");
			
		button("START", [vid_x - font_size * 7, vid_y - font_size * 4], start_server, map);
		button("Back", [font_size * 2, vid_y - font_size * 4], page, ftos(MENU_MULTIPLAYER));
	}
	
	drawpic(mouse_pos, "gfx/cursor", fixed_vector('24 24 0'), ' 1 1 1', 1, 0);
	clicked = 0;
};

void() m_display = 
{
	setkeydest(KEY_MENU);
	setmousetarget(MT_MENU);
};

void() m_hide = 
{
	setkeydest(KEY_GAME);
	setmousetarget(MT_CLIENT);
};

void(float n) m_toggle = 
{
	menu = !menu;
	if (menu) 
	{
		m_display(); 
		menu = MENU_MAIN;
	}
	else m_hide();
 };

void(float key, float ascii) m_keydown = 
{
	if (key == K_ESCAPE) m_toggle(1);
	if (key == K_MOUSE1) { clicked = 1; mouse1_held = 1; }
	if(strlen(bindingBind) != 0)
	{
		local string selectedKey = "bind ";
		cmd(strcat(selectedKey, keynumtostring(key), " \"", bindingBind, "\""));
		bindingBind = "";
	}
	if(strlen(selected_input_field) != 0)
	{
		local string selected_input_cvar = str_cvar(selected_input_field);
		if(key == K_BACKSPACE) cvar_set(selected_input_field, substring(selected_input_cvar, 0, strlen(selected_input_cvar) - 1) );
		if(strlen(selected_input_cvar) < selected_input_max_length && key >= K_SPACE && key < K_BACKSPACE) cvar_set(selected_input_field, strcat(selected_input_cvar, chr2str(ascii)));
	}
	if (menu == MENU_MULTIPLAYER)
	{
		if(key == K_MWHEELUP)
		{
			if(SERVER_SKIP > 0) SERVER_SKIP = SERVER_SKIP - 1;
		}
		if(key == K_MWHEELDOWN)
		{
			if(SERVER_SKIP < SERVER_TOTAL) SERVER_SKIP = SERVER_SKIP + 1;
		}
	}
};

void(float key, float ascii) m_keyup = 
{
 	if (key == K_MOUSE1) mouse1_held = 0;
};

void() m_init = 
{
	if(strstrofs(cvar_string("cmdline"), ".exe", 0) != -1)	//Freetype may crash on linux idk why
	{
		cmd("r_font_disable_freetype 0\n");					//Enable freetype support
		cmd("utf8_enable 1\n");								//Enable support for non-latin characters
		cmd("r_font_postprocess_outline 1\n");				//Some outline
		cmd("r_font_postprocess_blur 1\n");					//Some blur
		cmd("loadfont default gfx/font 16 scale 1.2\n");	//Loading font for default text
		cmd("loadfont console gfx/font 24 scale 1.2\n");	//Loading font for console text
		cmd("loadfont infobar gfx/font 24 scale 1.2\n");	//Loading font for infobar (text at the bottom of the screen. Execute cmd: "infobar 1 string")
		cmd("loadfont notify gfx/font 16 scale 1.2\n");		//Loading font for text in left upper corner 
		cmd("loadfont chat gfx/font 16 scale 1.2\n");		//Loading font for chat input
		cmd("loadfont menu gfx/font 16 scale 1.2\n");		//Font for menuqc
		cmd("loadfont sbar gfx/font 64 scale 1.2\n");		//Font for sbar (health, armor, ammo, etc.)
		cmd("loadfont centerprint gfx/font 32 scale 1.6\n");//Font for centerprint (cmd: "cprint string")
		drawfont = FONT_MENU;
	}

	menu = 0;
	vid_res_x = cvar("vid_width");
 	vid_res_y = cvar("vid_height");
 	string consize_w, consize_h;
 	consize_w = ftos(vid_res_x / 2);
 	consize_h = ftos(vid_res_y / 2);
 	cmd(strcat("vid_conheight ", consize_h, "\n"));
 	cmd(strcat("vid_conwidth ", consize_w, "\n"));
	cmd("vid_desktopfullscreen 0\n");
	cmd("sv_sound_land player/land1.wav\n");
	mouse_pos = [vid_res_x / 4, vid_res_y / 4];
 	if (clientstate() != CS_CONNECTED) cmd("stopsound; play2 sound/menu\n");
	m_toggle(1);
	if (clientstate() != CS_CONNECTED) m_toggle(1); //reenable menu if no demo1.dem
};
void() m_shutdown = {};