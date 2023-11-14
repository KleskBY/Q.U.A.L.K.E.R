

//////////////////////////////////
/////////// CROSSHAIR ////////////
//////////////////////////////////

void DrawCrosshair()
{
	if(cvar("crosshair") <= 0 || current_health <= 0 || current_weapon <= 0 || current_health > 666 || intermission) return;
	
	local float recoil = fabs(view_punchangle_x);
	local float gap_size = rint(vx_rel * 8) + rint(recoil * 2);
	local vector crosshair_size = fixed_vector('10 1 0');
	local vector crosshair_color = [cvar("crosshair_color_red"), cvar("crosshair_color_blue"), cvar("crosshair_color_green")];

	//outline
	drawfill([vid_x / 2 - crosshair_size_x - gap_size - 1, vid_y / 2 - crosshair_size_y / 2 - 1], [crosshair_size_x + 2, crosshair_size_y + 2], '.1 .1 .1', 0.3, 0); //left
	drawfill([vid_x / 2 + gap_size - 1, vid_y / 2 - crosshair_size_y / 2 - 1], [crosshair_size_x + 2, crosshair_size_y + 2], '.1 .1 .1', 0.3, 0);  //right
	drawfill([vid_x / 2 - crosshair_size_y / 2 - 1, vid_y / 2 - crosshair_size_x - gap_size  - 1], [crosshair_size_y + 2, crosshair_size_x + 2], '.1 .1 .1', 0.3, 0); //top
	drawfill([vid_x / 2 - crosshair_size_y / 2 - 1, vid_y / 2 + gap_size - 1], [crosshair_size_y + 2, crosshair_size_x + 2], '.1 .1 .1', 0.3, 0); //bottom

	//crosshair
	drawfill([vid_x / 2 - crosshair_size_x - gap_size, vid_y / 2 - crosshair_size_y / 2], [crosshair_size_x, crosshair_size_y], crosshair_color, 0.75, 0); //left
	drawfill([vid_x / 2 + gap_size, vid_y / 2 - crosshair_size_y / 2], [crosshair_size_x, crosshair_size_y], crosshair_color, 0.75, 0);  //right
	drawfill([vid_x / 2 - crosshair_size_y / 2, vid_y / 2 - crosshair_size_x - gap_size], [crosshair_size_y, crosshair_size_x], crosshair_color, 0.75, 0); //top
	drawfill([vid_x / 2 - crosshair_size_y / 2, vid_y / 2 + gap_size], [crosshair_size_y, crosshair_size_x], crosshair_color, 0.75, 0); //bottom
}






/////////////////////////////////////
/////////////// HUD /////////////////
/////////////////////////////////////

void DrawHUD()
{
	if(intermission || !cvar("cl_hud") || cvar("viewsize") > 100 || current_health < 0 || current_health >= 666) return;
	
	drawfont = FONT_SBAR;
	local vector hud_size = [font_size * 2, font_size * 2];
	local vector healthColor = [1, (current_health / 100), (current_health / 100)];
	local string healthStr = strcat("+", ftos(current_health));
	drawstring([hud_size_x, vid_y - hud_size_x * 1.5], healthStr, hud_size, healthColor, 0.75, 0);
	
	//medkits
	drawpic([hud_size_x, vid_y - hud_size_y * 2.5], "gfx/medkit", fixed_vector('24 24 0'), ' 1 1 1', 1, 0);
	drawstring([hud_size_x + hud_size_x * 0.75, vid_y - hud_size_y * 2.5 + font_size * 0.1], ftos(getstati(STAT_MEDKITS)), fixed_vector('24 24 0'), '1 1 1', 1, 0);
	
	//money
	// local string moneyStr = strcat(ftos(getstati(STAT_MONEY)), "$");
	// local float offset2 = stringwidth(moneyStr, true, hud_size);
	// drawstring([vid_x - offset2, vid_y - hud_size_y * 2.5 + font_size * 0.1], moneyStr, fixed_vector('24 24 0'), '1 1 1', 1, 0);
	
	if(current_weapon && current_weapon != WP_KNIFE) 
	{
		local float offset = stringwidth(ftos(current_ammo), true, hud_size) + hud_size_x;
		drawstring([vid_x - hud_size_x - offset, vid_y - hud_size_y * 1.5], ftos(current_ammo), hud_size, '1 1 1', 0.75, 0);
		local string ammo_icon = strcat("gfx/", ftos(current_weapon));
		if(current_weapon == WP_SPAS || current_weapon == WP_MOSS) ammo_icon = "gfx/sb_shells";
		else if(current_weapon == WP_AKSU || current_weapon == WP_AK74) ammo_icon = "gfx/sb_545x39";
		else if(current_weapon == WP_VAL || current_weapon == WP_VSS) ammo_icon = "gfx/sb_9x39";
		else if(current_weapon == WP_MP5) ammo_icon = "gfx/sb_9x19";
		else if(current_weapon == WP_PISTOL) ammo_icon = "gfx/sb_9x18";
		else if(current_weapon == WP_SVD) ammo_icon = "gfx/sb_762x54";
		else if(current_weapon == WP_GAUSS) ammo_icon = "gfx/sb_batts";
		else if(current_weapon == WP_GRENADE) ammo_icon = "gfx/sb_rocket";
		
		drawpic([vid_x - hud_size_x - font_size, vid_y - hud_size_y * 1.5], ammo_icon, hud_size, ' 1 1 1', 1, 0);
	}
	drawfont = FONT_DEFAULT;
	
	DrawCrosshair();
	Sbar_DrawCompass();
};





float g_nVideoWidth;
float g_nVideoHeight;

#define HUDEFFECT_STATE_NONE							0
#define HUDEFFECT_STATE_STARTING						1
#define HUDEFFECT_STATE_ENDING							2

.string		message;

float			g_bPreviousFrameFluidContents;
// Map Name Display
float			g_fMapNameDisplayState;
vector			g_vMapNameDisplaySize;
float			g_fMapNameDisplayAlpha;
string			g_strMapDisplayName;

vector			g_vMapNameDisplayLocation;



#define HUD_MAPINFO_POS_X								25
#define HUD_MAPINFO_POS_Y								75



void HUD_PrepareMapDisplayName()
{ // HUD - Prepare Map Display Name
	local float nLength;
	local string strNameWithoutBSP;
	// Acquire Filename + .bsp
	g_strMapDisplayName = substring(mapname, 5, 100);
	// Cull .bsp
	nLength = strlen(g_strMapDisplayName);
	strNameWithoutBSP = substring(g_strMapDisplayName, 0, nLength - 4);
	// Append Name
	g_strMapDisplayName = strcat(world.message, " (", strNameWithoutBSP, ")");
	
	// Zone String
	g_strMapDisplayName = strzone(g_strMapDisplayName);
}


void HUD_UpdateMapNameDisplay()// Update Map Name Display
{ 
	if(g_fMapNameDisplayState == HUDEFFECT_STATE_STARTING)
	{
		g_fMapNameDisplayAlpha += (frametime * 0.25);
		
		if(g_fMapNameDisplayAlpha > 1)
		{
			g_fMapNameDisplayState = HUDEFFECT_STATE_ENDING;
			g_fMapNameDisplayAlpha = 1;
		}
	}
	else
	{
		g_fMapNameDisplayAlpha -= (frametime * 0.38);
		
		if(g_fMapNameDisplayAlpha < 0)
		{
			g_fMapNameDisplayState = HUDEFFECT_STATE_NONE;
			g_fMapNameDisplayAlpha = 0;
		}
	}
	
	if( random() < 0.03) // Jiggle It Around
	{ 
		local vector vLocation;
		vLocation = g_vMapNameDisplayLocation;
		vLocation_x += random() * 4;
		vLocation_y += random() * 4;
		drawstring(vLocation, world.message, g_vMapNameDisplaySize, '1 0 0', g_fMapNameDisplayAlpha, 0);
	}
	else drawstring(g_vMapNameDisplayLocation, world.message, g_vMapNameDisplaySize, '1 0 0', g_fMapNameDisplayAlpha, 0);
}


void HUD_BeginMapNameDisplay()
{
	g_nVideoWidth = cvar("screensize_conwidth");
	g_nVideoHeight = cvar("screensize_conheight");
	if(g_fMapNameDisplayState == HUDEFFECT_STATE_NONE)
	{
		// Calculate Location (do it here, instead of in the update)
		// Calculate Pixel Width of Display
		local float nWidth;
		nWidth =  stringwidth(world.message, true, [20]);//strlen(world.message) * 20;
		if(nWidth > g_nVideoWidth)
		{ // Too Large; Shrink it Big Time
			g_vMapNameDisplaySize_x = 13;
			nWidth = strlen(world.message) * 13;
		}
		else g_vMapNameDisplaySize_x = 20;
			
		g_vMapNameDisplaySize_y = g_vMapNameDisplaySize_x;
		g_vMapNameDisplaySize_z = 0;
			
		// Determine Center Point
		g_vMapNameDisplayLocation_x = (g_nVideoWidth - nWidth) / 2;
		
		// Assign Relative Coords
		g_vMapNameDisplayLocation_y = g_nVideoHeight / 4.5;
		g_vMapNameDisplayLocation_z = 0;
		// Assign State
		g_fMapNameDisplayState = HUDEFFECT_STATE_STARTING;
		// Assign Alpha
		g_fMapNameDisplayAlpha = 0;
	}
}


void UpdateFluidContents(float bForceUpdate)
{ // Update Fluid Contents
	local string strCommand;
	local string strCDTrack;
	// Determine Origin Location
	vector vOrigin;
	vOrigin = pmove_org;
	vOrigin_z += getstati(STAT_VIEWHEIGHT);
	// Acquire Current Contents
	local float nContents;
	nContents = pointcontents(vOrigin);
		
	if(nContents != g_bPreviousFrameFluidContents || bForceUpdate)
	{ // New Contents
		strCommand = "fog ";
		
		switch(nContents)
		{
			case CONTENT_WATER:
				strCommand = strcat(strCommand, "2.3 0.12 0.12 0.11 0.97\n");
				strCDTrack = "Underwater";
				break;
			case CONTENT_SLIME:
				strCommand = strcat(strCommand, "1.9 0.1 0.24 0.1 0.8\n");
				strCDTrack = "Underwater";
				break;
			case CONTENT_LAVA:
				strCommand = strcat(strCommand, "0.8 0.35 0.1 0.0 1\n");
				strCDTrack = "Underwater";
				break;
			default:
				// No Fluid
				strCommand = strcat(strCommand, "0\n");
				strCDTrack = "";
				break;
		}
		localcmd(strCommand);
	}
	
	g_bPreviousFrameFluidContents = nContents;
}