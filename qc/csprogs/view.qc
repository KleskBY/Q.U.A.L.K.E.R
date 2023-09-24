
/////////////////////////////////////
////////////// SCOPE ////////////////
/////////////////////////////////////

float scoping;
float endScoping;
void enableScope()
{
	if(!IsSniper(getstati(STAT_ACTIVEWEAPON)) /*|| getstati(STAT_WEAPONFRAME) > 90 */|| getstati(STAT_HEALTH) < 1)  return;
	scoping = 1;
	endScoping = time + 1.1;
	cvar_set("r_drawviewmodel", "0");
}

void disableScope()
{
	scoping = 0;
	cvar_set("r_drawviewmodel", "1");
}

void DrawScope()
{
	if(scoping)
	{
		if(scoping == 1)
		{
			drawfill('0 0 0', [screensize_x, screensize_y, 0], '0 0 0', fabs(endScoping-time), 0);
			if(endScoping < time) scoping = 2;
		}
		if(!IsSniper(getstati(STAT_ACTIVEWEAPON)) /*|| (getstati(STAT_WEAPONFRAME) > 0 && getstati(STAT_WEAPONFRAME) < 91)*/ || getstati(STAT_HEALTH) < 1) disableScope();
		drawpic([0, 0], "gfx/scope.tga", [screensize_x, screensize_y], '1 1 1', 1, 0);
	}
}



/////////////////////////////////////
////////////// INPUT ////////////////
/////////////////////////////////////

string KeyMap(float keynum) 
{
   local string chrlist, key;

   if(keynum == 32) key = " ";
   else if(keynum >= 39 && keynum <= 61)
   {
      chrlist = "'  *+,-./0123456789 ; =";   
      key = substring(chrlist, keynum - 39, 1);
   }
   else if(keynum <= -39 && keynum >= -61)
   {
      chrlist = "\"    <_>?)!@#$%^&*( : +";
      key = substring(chrlist, (-keynum) - 39, 1);
   }
   else if(keynum >= 91 && keynum <= 93)
   {
      chrlist = "[\\]";
      key = substring(chrlist, keynum - 91, 1);
   }
   else if(keynum <= -91 && keynum >= -93)
   {
      chrlist = "{|}";
      key = substring(chrlist, (-keynum) - 91, 1);
   }   
   else if(keynum >= 97 && keynum <= 122)
   {
      chrlist = "abcdefghijklmnopqrstuvwxyz";
      key = substring(chrlist, keynum - 97, 1);
   }

   return key;
}

float CSQC_InputEvent(float flEventType, float flKey, float flCharacter) 
{
    local string key, keybind;

	key = KeyMap(flKey);
	keybind = getkeybind(flKey);

	clicked = false;
    if (!flEventType) // key pressed down
	{	
		if (flKey == K_MOUSE1) 
		{
			clicked = 1;
			if(showCursor) return TRUE;
		}
		if (flKey == K_MOUSE2) 
		{
			clicked = 2;
			if(showCursor) return TRUE;
		}
		if (keybind == "inventory") showInventory = !showInventory;
	}
	
	if (keybind == "+showscores")
	{
		if(!flEventType) showScores = TRUE;
		if(flEventType == 1) showScores = FALSE;
	}
	if (keybind == "+button4")
	{
		if(!flEventType) isRunning = TRUE;
		if(flEventType == 1) isRunning = FALSE;
	}
	if (keybind == "+button5")
	{
		if(!flEventType) enableScope();
		if(flEventType == 1) disableScope();
	}
	
	return FALSE;
}



//////////////////////////////////
//////////// RANKINGS ////////////
//////////////////////////////////
float lastPing;
void DrawRankings()
{
	if(cvar("deathmatch") == 0 && cvar("coop") == 0) return;
	if(!showScores && !intermission) return;

	if(lastPing + 5 < time)
	{
		lastPing = time;
		localcmd("ping\n");
	}
	
	drawstring([screensize_x / 2 - stringwidth("RANKING", true, [font_size * 2, font_size * 2]) / 2, screensize_y * 0.16], "RANKING", [font_size * 2, font_size * 2], '1 1 1', 1, 0);

	drawfill([screensize_x / 2 - screensize_y / 2, screensize_y / 2 - screensize_y / 4], [screensize_y, screensize_y / 2], '0.1 0.1 0.1', 0.5, 0);
	drawfill([screensize_x / 2 - screensize_y / 2, screensize_y / 4 - font_size], [screensize_y, font_size], '0.9 0.9 0.9', 0.45, 0);
	scoresboard_text([screensize_x / 4, screensize_y / 4 - font_size], "NAME", "PING FRAGS");

	local float offset = 0;
	local float i;
	for(i = 0; i < 32; i++)
	{
		local string player_name = getplayerkeyvalue(i, "name");
		if(player_name != "" || player_name)
		{
			local string player_kills = getplayerkeyvalue(i, "frags");
			if(strlen(player_kills) == 1) player_kills = strcat("  ", player_kills);
			if(strlen(player_kills) == 2) player_kills = strcat(" ", player_kills);
			local string player_colors = getplayerkeyvalue(i, "colors");
			local string player_ping = getplayerkeyvalue(i, "ping");
			if(strlen(player_ping) == 1) player_ping = strcat(player_ping, "  ");
			if(strlen(player_ping) == 2) player_ping = strcat(player_ping, " ");

			scoresboard_text([screensize_x / 4, screensize_y / 4 + offset], player_name, strcat(player_ping, " ", player_kills));
			if(player_localnum == i) txt(">", [screensize_x / 2 - screensize_y / 2, screensize_y / 4 + offset]);
			offset = offset + font_size;
		}
	}
	
	txt(mapname, [screensize_x / 2 - screensize_y / 2,screensize_y -  screensize_y / 5]);
	txt(ftos(floor(time)), [screensize_x / 2 + screensize_y / 2 - font_size * strlen(ftos(floor(time))), screensize_y - screensize_y / 5]);
}

////////////////////////////
////////// SCORE ///////////
////////////////////////////

void DrawScore()
{
	if( (intermission && cvar("deathmatch") == 0) || (showScores && cvar("deathmatch") == 0 && cvar("coop") == 0) )
	{
		if(intermission)
		{
			if(!completedTime) completedTime = time;
			drawstring([screensize_x / 2 - stringwidth("COMPLETED", true, [font_size * 2, font_size * 2]) / 2 + font_size, screensize_y / 2 - font_size * 8], "COMPLETED", [font_size * 2, font_size * 2], '1 1 1', 1, 0);
			txt("TIME:", [screensize_x / 2 - font_size * 6, screensize_y / 2 - font_size * 6]); 
			txt(substring(ftos(completedTime), 0, strstrofs(ftos(completedTime), ".", 0) + 2), [screensize_x / 2 + font_size * 6, screensize_y / 2 - font_size * 6]);
		}
		else 
		{
			drawstring([screensize_x / 2 - stringwidth(cvar_string("scratch3"), true, [font_size, font_size]) / 2 + font_size, screensize_y / 2 - font_size * 8], cvar_string("scratch3"), [font_size, font_size ], '1 1 1', 1, 0);
			txt("TIME:", [screensize_x / 2 - font_size * 6, screensize_y / 2 - font_size * 6]); 
			txt(substring(ftos(time), 0, strstrofs(ftos(time), ".", 0) + 2), [screensize_x / 2 + font_size * 6, screensize_y / 2 - font_size * 6]);
		}
		
		txt("KILLS:", [screensize_x / 2 - font_size * 6, screensize_y / 2 - font_size * 4]); 
		txt(strcat(ftos(getstati(STAT_MONSTERS)), "/", ftos(getstati(STAT_TOTALMONSTERS))), [screensize_x / 2 + font_size * 6, screensize_y / 2 - font_size * 4]);
		txt("ITEMS:", [screensize_x / 2 - font_size * 6, screensize_y / 2 - font_size * 2]); 
		txt(strcat(ftos(getstati(STAT_PICKED_ITEMS)), "/", ftos(getstati(STAT_TOTALITEMS))), [screensize_x / 2 + font_size * 6, screensize_y / 2 - font_size * 2]);
		txt("HEALTH:", [screensize_x / 2 - font_size * 6, screensize_y / 2]); 
		txt(ftos(getstati(STAT_HEALTH)), [screensize_x / 2 + font_size * 6, screensize_y / 2]);
		txt("SECRETS:", [screensize_x / 2 - font_size * 6, screensize_y / 2 + font_size * 2]); 
		txt(strcat(ftos(getstati(STAT_SECRETS)), "/", ftos(getstati(STAT_TOTALSECRETS))), [screensize_x / 2 + font_size * 6, screensize_y / 2 + font_size * 2]);
		txt("MAPNAME:", [screensize_x / 2 - font_size * 6, screensize_y / 2 + font_size * 4]); 
		txt(substring(mapname, 5, strlen(mapname) - 9), [screensize_x / 2 + font_size * 6, screensize_y / 2 + font_size * 4]);
		txt("PLAYERS:", [screensize_x / 2 - font_size * 6, screensize_y / 2 + font_size * 6]); 
		txt(ftos(maxclients), [screensize_x / 2 + font_size * 6, screensize_y / 2 + font_size * 6]);
		if(getstati(STAT_SHOTS))
		{
			txt("ACCURACY:", [screensize_x / 2 - font_size * 6, screensize_y / 2 + font_size * 8]); 
			txt(strcat(ftos(getstati(STAT_HITS)), "/", ftos(getstati(STAT_SHOTS)), "(", ftos(floor(getstati(STAT_HITS) / getstati(STAT_SHOTS) * 100)), "%)")  , [screensize_x / 2 + font_size * 6, screensize_y / 2 + font_size * 8]);
		}
	}
}

////////////////////////////
/////////// VIEW ///////////
////////////////////////////



float lastPing;
float lastHealth;
void CSQC_UpdateView(float flWidth, float flHeight) 
{
    clearscene(); 						// CSQC builtin to clear the scene of all entities / reset our view properties
	setproperty(VF_DRAWWORLD, 1); 		// we want to draw world!
	setproperty(VF_DRAWCROSSHAIR, 0);	// we want to draw our crosshair!
	setproperty(VF_DRAWENGINESBAR, 0);
	addentities(MASK_NORMAL | MASK_ENGINE | MASK_ENGINEVIEWMODELS); 		// add entities with these rendermask field var's to our view
	LocalPlayer();
	renderscene();

	screensize = [cvar("vid_conwidth"), cvar("vid_conheight")];
	
	current_health = getstati(STAT_HEALTH);
	current_ammo = getstati(STAT_AMMO);
	current_weapon = getstati(STAT_ACTIVEWEAPON);
	
	GetRelative();
	UpdateMouse();
	
	DrawScope();
	if(!scoping) DrawHUD();
	DrawScore();
	DrawRankings();
	// Inventory();
	
	if(getstati(STAT_HEALTH) < 0)
	{
		drawstring([screensize_x / 2 - stringwidth("Lost to the Zone", true, [font_size, font_size]) / 2, screensize_y * 0.5], "Lost to the Zone", [font_size, font_size], '1 0 0', 1, 0);
	}
	
	if(lastHealth != getstati(STAT_HEALTH))
	{
		lastHealth = getstati(STAT_HEALTH);
		float saturation = 0.1 + (40 + lastHealth) / 100;
		if(saturation < 0.1) saturation = 0.1;
		if(saturation > 1.1) saturation = 1.1;
		cvar_set("r_glsl_saturation", ftos(saturation));
	}
	
	if (g_fMapNameDisplayState && !intermission && !showScores)	HUD_UpdateMapNameDisplay();
	if (showCursor) drawpic(mouse_pos, "gfx/cursor", fixed_vector('24 24 0'), ' 1 1 1', 1, 0);
	
	if(cvar("r_shadow_realtime_world") == 0)
	{
		if(mapname == "maps/lab.obj") cvar_set("r_ambient", "-55");
		else if(mapname == "maps/lost_village.obj") cvar_set("r_ambient", "0");
	}
}




////////////////////////////
/////////// CSQC ///////////
////////////////////////////



float CSQC_ConsoleCommand(string strCommand) 
{
    return FALSE;
}
void CSQC_Parse_StuffCmd (string msg)
{
	if(isdemo()) return;
	localcmd(msg);
}

void CSQC_Ent_Remove ()
{
	remove(self);
}
void CSQC_Init(void) 
{
	precache_pic("gfx/scope.tga");
	precache_cubemap("cubemaps/237nx.tga");
	registercvar("cl_hud", "1");
	registercvar("bot_stop", "0");
	completedTime = 0;
	// InventoryInit();
	
	HUD_PrepareMapDisplayName();
	HUD_BeginMapNameDisplay();
}

void CSQC_Shutdown(void) 
{
}
void CSQC_Ent_Update (float isnew)
{	
}