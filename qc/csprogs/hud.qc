


void DrawHint(vector pos, string txt)
{
	if(pos_x == 0) return;
	float dist = vlen(pmove_org - pos);
	float showDist = 300;
	float alpha = 0;
	if (dist >= showDist) alpha = 0; 
	else alpha = .95 - (dist / showDist);
	
	vector w2s = cs_project(pos);
	if(w2s_z <= 0) return;
	vector vec = fixed_vector('16 16 0');
	drawstring([w2s_x, w2s_y] - vec, txt, vec, '1 1 1', alpha, 0);
	drawline(vec_x / 4, [w2s_x, w2s_y + vec_y] - vec, [w2s_x + stringwidth(txt, true, vec), w2s_y + vec_y] - vec, [1, 1, 1], alpha, 0);
	drawline(vec_x / 4 + 1, [w2s_x + vec_x, w2s_y + vec_y + vec_y] - vec, [w2s_x, w2s_y + vec_y] - vec, [1, 1, 1], alpha, 0);
}



/////////////////////////////////////
/////////////// HUD /////////////////
/////////////////////////////////////

void DrawHUD()
{
	if(intermission || !cvar("cl_hud") || cvar("viewsize") > 100 || current_health < 0 || current_health >= 666) return;
	
	drawfont = FONT_SBAR;
	vector hud_size = [font_size * 2, font_size * 2];
	vector healthColor = [1, (current_health / 100), (current_health / 100)];
	string healthStr = strcat("+", ftos(current_health));
	drawstring([hud_size_x, vid_y - hud_size_x * 1.5], healthStr, hud_size, healthColor, 0.75, 0);
	
	//medkits
	drawpic([hud_size_x, vid_y - hud_size_y * 2.5], "gfx/medkit", fixed_vector('24 24 0'), ' 1 1 1', 1, 0);
	drawstring([hud_size_x + hud_size_x * 0.75, vid_y - hud_size_y * 2.5 + font_size * 0.1], ftos(getstati(STAT_MEDKITS)), fixed_vector('24 24 0'), '1 1 1', 1, 0);
	
	DrawHint([getstati(STAT_VEC1), getstati(STAT_VEC2), getstati(STAT_VEC3)], strcat("Press [", strtoupper(bind2string("+use")), "] to interact"));


	//money
	//string moneyStr = strcat(ftos(getstati(STAT_MONEY)), "$");
	//float offset2 = stringwidth(moneyStr, true, hud_size);
	//drawstring([vid_x - offset2, vid_y - hud_size_y * 2.5 + font_size * 0.1], moneyStr, fixed_vector('24 24 0'), '1 1 1', 1, 0);
	
	if(current_weapon && current_weapon != WP_KNIFE && current_weapon != WP_BOLT) 
	{
		float offset = stringwidth(ftos(current_ammo), true, hud_size) + hud_size_x;
		drawstring([vid_x - hud_size_x - offset, vid_y - hud_size_y * 1.5], ftos(current_ammo), hud_size, '1 1 1', 0.75, 0);
		string ammo_icon = strcat("gfx/", ftos(current_weapon));
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