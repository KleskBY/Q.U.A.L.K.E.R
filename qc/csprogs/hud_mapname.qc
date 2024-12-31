

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
{	
	g_strMapDisplayName = substring(mapname, 5, 100); // Acquire Filename + .bsp
	// Cull .bsp
	float nLength = strlen(g_strMapDisplayName);
	string strNameWithoutBSP = substring(g_strMapDisplayName, 0, nLength - 4);
	
	g_strMapDisplayName = strcat(world.message, " (", strNameWithoutBSP, ")"); // Append Name
	g_strMapDisplayName = strzone(g_strMapDisplayName); // Zone String
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

	if(random() < 0.03) // Jiggle It Around
	{ 
		vector vLocation = g_vMapNameDisplayLocation;
		vLocation_x += random() * 4;
		vLocation_y += random() * 4;
		drawstring(vLocation, world.message, g_vMapNameDisplaySize, '1 0 0', g_fMapNameDisplayAlpha, 0);
	}
	else drawstring(g_vMapNameDisplayLocation, world.message, g_vMapNameDisplaySize, '1 0 0', g_fMapNameDisplayAlpha, 0);
}


void HUD_BeginMapNameDisplay()
{
	vid = [ stof(cvar_string("vid_conwidth")), stof(cvar_string("vid_conheight")) ];
	if(g_fMapNameDisplayState == HUDEFFECT_STATE_NONE)
	{
		// Calculate Location (do it here, instead of in the update)
		// Calculate Pixel Width of Display
		float nWidth =  stringwidth(world.message, true, [20]); //strlen(world.message) * 20;
		if(nWidth > vid_x) // Too Large; Shrink it Big Time
		{ 
			g_vMapNameDisplaySize_x = 13;
			nWidth = strlen(world.message) * 13;
		}
		else g_vMapNameDisplaySize_x = 20;
			
		g_vMapNameDisplaySize_y = g_vMapNameDisplaySize_x;
		g_vMapNameDisplayLocation_x = (vid_x - nWidth) / 2; // Determine Center Point
		g_vMapNameDisplayLocation_y = vid_y / 4.5; // Assign Relative Coords
		g_fMapNameDisplayState = HUDEFFECT_STATE_STARTING; // Assign State
		g_fMapNameDisplayAlpha = 0; // Assign Alpha
	}
}


void UpdateFluidContents(float bForceUpdate)
{
	string strCDTrack;
	
	vector vOrigin = pmove_org;
	vOrigin_z += getstati(STAT_VIEWHEIGHT);
	float nContents = pointcontents(vOrigin); // Acquire Current Contents
		
	if(nContents != g_bPreviousFrameFluidContents || bForceUpdate)
	{
		string strCommand = "fog ";
		
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