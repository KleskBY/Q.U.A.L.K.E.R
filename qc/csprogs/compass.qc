


float CONV_SAME         = 0;
float CONV_CASE_LOWER   = 1;
float CONV_CASE_UPPER   = 2;
float CONV_WHITE        = 1;
float CONV_RED          = 2;
float CONV_REDSPECIAL   = 3;
float CONV_WHITESPECIAL = 4;
float CONV_ALTERNATE_RW = 5;
float CONV_ALTERNATE_WR = 6;

float compass_max_offset;
void() Sbar_DrawCompass =
{
	local string compass_string, s;
	local float ang, yaw, ofs, i, strofs;
	
	compass_string = "N...ne...E...se...S...sw...W...nw...";
	// compass_string = strconv(CONV_SAME, CONV_RED, CONV_RED, compass_string);
	

	ang = 365 - (input_angles_y);
	while (ang < 0)	{ ang = ang + 360; }
	while (ang >= 360) { ang = ang - 360; }
	
	ang = ang * 0.1;
	yaw = ceil(ang);
	ofs = (ceil(ang) - ang) * 8;
	yaw = yaw - 5;
	
	local float offset = 0;
	for (i = 0; i < 9; i = i + 1)
	{
		strofs = yaw + i;
		if (strofs > 35) strofs = strofs - 36;
		if (strofs < 0) strofs = strofs + 36;
		// a hack to centre '.' characters a bit more
		// theres no centred red dot in conchars
		s = substring(compass_string, strofs, 1);
		if (s == ".") drawstring([-40 + ofs + i*8 + 2 + (vid_x / 2), 8 - 1], s, '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		else drawstring([-40 + ofs + i*8 + (vid_x / 2), 8], s, '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		offset = offset + stringwidth(s, true, '8 8 0');
	}
	
	//TASK
	if(strlen(cvar_string("scratch3")) > 2)
	{
		string task_string = strzone("X                                   ");
		vector dest = stov(cvar_string("scratch4"));
		local vector dir = normalize(dest - pmove_org);
		local float needyaw = vectoyaw(dir);
		
		ang = 365 - (input_angles_y - needyaw);
		while (ang < 0)	{ ang = ang + 360; }
		while (ang >= 360) { ang = ang - 360; }
		ang = ang * 0.1;
		yaw = ceil(ang);
		ofs = (ceil(ang) - ang) * 8;
		yaw = yaw - 5;
		
		for (i = 0; i < 9; i = i + 1)
		{
			strofs = yaw + i;
			if (strofs > 35) strofs = strofs - 36;
			if (strofs < 0) strofs = strofs + 36;
			s = substring(task_string, strofs, 1);
			drawstring([-40 + ofs + i*8 + (vid_x / 2), 8], s, '8 8 0', '1 0 0', 1, DRAWFLAG_NORMAL);
		}
	}
	
	if(compass_max_offset < offset) compass_max_offset = offset;
	drawstring([(vid_x / 2) - compass_max_offset - 16, 8], "[", '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
	drawstring([(vid_x / 2) + compass_max_offset + 8 , 8], "]", '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
};
