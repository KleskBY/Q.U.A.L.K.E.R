
//////////////////////////////////
/////////// CROSSHAIR ////////////
//////////////////////////////////


vector last_input_angles;
float angles_gap;
void DrawCrosshair()
{
	if(cvar("crosshair") <= 0 || current_health <= 0 || current_weapon <= 0 || current_health > 666 || intermission) return;
	
	float tmp = vlen(input_angles - last_input_angles);
	angles_gap = LerpAngle(angles_gap, tmp, 15 * frametime);
	last_input_angles = input_angles;
	
	float incross = getstati(STAT_INCROSS);
	float recoil = fabs(view_punchangle_x);
	vector crosshair_color = [cvar("crosshair_color_red"), cvar("crosshair_color_blue"), cvar("crosshair_color_green")];
	if(incross == 1) crosshair_color = [ 1, .01, .01 ]; //.54 .01 .01
	if(incross == 2) crosshair_color = [ 1, .1, .5 ];
	
	vector crosshair_size = [10, 1, 0] * cvar("crosshair_size");
	crosshair_size_x = rint(crosshair_size_x);
	crosshair_size_y = rint(crosshair_size_y);
	float gap_size = gap_size = 9 + (recoil * 9 * vx_rel) + (angles_gap * 4 * vx_rel) ;
	float cx = rint(vid_x / 2);
	float cy = rint(vid_y / 2);
	
	drawline(1, [cx - crosshair_size_x - gap_size, cy], [cx - gap_size, cy], crosshair_color, 1, 0); //left
	drawline(1, [cx + gap_size, cy], [cx + crosshair_size_x + gap_size, cy], crosshair_color, 1, 0); //right
	
	drawline(1, [cx, cy + crosshair_size_x + gap_size], [cx, cy + gap_size], crosshair_color, 1, 0); //bottom
	drawline(1, [cx, cy - gap_size], [cx, cy - crosshair_size_x - gap_size], crosshair_color, 1, 0); //top
}


void DrawCrosshair2()
{
	float crosshair_type = cvar("crosshair");
	if(crosshair_type <= 0 || current_health <= 0 || current_weapon <= 0 || current_health > 666 || intermission) return;
	
	float recoil = fabs(view_punchangle_x);
	float gap_size = rint(vx_rel * 8) + rint(recoil * 2);
	vector crosshair_color = [cvar("crosshair_color_red"), cvar("crosshair_color_blue"), cvar("crosshair_color_green")];
	vector crosshair_size = fixed_vector([10, cvar("crosshair_size"), 0]);
	
	if(crosshair_type == 5)
	{
		crosshair_size = ([12, 1, 0]);
		crosshair_size_x = rint(crosshair_size_x);
		crosshair_size_y = rint(crosshair_size_y);
		gap_size = 8 + rint(recoil * 10 * vx_rel); // 
		
		drawline(1, [vid_x / 2 - crosshair_size_x - gap_size, vid_y / 2 - crosshair_size_y / 2], [vid_x / 2 - gap_size, vid_y / 2 - crosshair_size_y / 2], crosshair_color, 1, 0);
		drawline(1, [vid_x / 2 + gap_size, vid_y / 2 - crosshair_size_y / 2], [vid_x / 2 + crosshair_size_x + gap_size, vid_y / 2 - crosshair_size_y / 2], crosshair_color, 1, 0);
		
		drawline(1, [vid_x / 2, vid_y / 2 + crosshair_size_x + gap_size], [vid_x / 2, vid_y / 2 + gap_size], crosshair_color, 1, 0);
		drawline(1, [vid_x / 2, vid_y / 2 - gap_size], [vid_x / 2, vid_y / 2 - crosshair_size_x - gap_size], crosshair_color, 1, 0);

		
		// drawfill([vid_x / 2, vid_y / 2 ], [.75, .75], crosshair_color, 1, 0);
		// drawline(1, [vid_x / 2 - 1, vid_y / 2], [vid_x / 2, vid_y / 2], crosshair_color, 1, 0);
		// drawline(1, [vid_x / 2, vid_y / 2 + 1], [vid_x / 2, vid_y / 2], crosshair_color, 1, 0);
	}
		
	if(crosshair_type <= 4)
	{
		if(crosshair_type == 2 || crosshair_type == 4) crosshair_size = fixed_vector([5, cvar("crosshair_size"), 0]);

		//outline
		drawfill([vid_x / 2 - crosshair_size_x - gap_size - 1, vid_y / 2 - crosshair_size_y / 2 - 1], [crosshair_size_x + 2, crosshair_size_y + 2], '.1 .1 .1', 0.3, 0); //left
		drawfill([vid_x / 2 + gap_size - 1, vid_y / 2 - crosshair_size_y / 2 - 1], [crosshair_size_x + 2, crosshair_size_y + 2], '.1 .1 .1', 0.3, 0);  //right
		if(crosshair_type != 3 && crosshair_type != 4) drawfill([vid_x / 2 - crosshair_size_y / 2 - 1, vid_y / 2 - crosshair_size_x - gap_size  - 1], [crosshair_size_y + 2, crosshair_size_x + 2], '.1 .1 .1', 0.3, 0); //top
		drawfill([vid_x / 2 - crosshair_size_y / 2 - 1, vid_y / 2 + gap_size - 1], [crosshair_size_y + 2, crosshair_size_x + 2], '.1 .1 .1', 0.3, 0); //bottom

		//crosshair
		drawfill([vid_x / 2 - crosshair_size_x - gap_size, vid_y / 2 - crosshair_size_y / 2], [crosshair_size_x, crosshair_size_y], crosshair_color, 0.75, 0); //left
		drawfill([vid_x / 2 + gap_size, vid_y / 2 - crosshair_size_y / 2], [crosshair_size_x, crosshair_size_y], crosshair_color, 0.75, 0);  //right
		if(crosshair_type != 3 && crosshair_type != 4) drawfill([vid_x / 2 - crosshair_size_y / 2, vid_y / 2 - crosshair_size_x - gap_size], [crosshair_size_y, crosshair_size_x], crosshair_color, 0.75, 0); //top
		drawfill([vid_x / 2 - crosshair_size_y / 2, vid_y / 2 + gap_size], [crosshair_size_y, crosshair_size_x], crosshair_color, 0.75, 0); //bottom
	}
}

