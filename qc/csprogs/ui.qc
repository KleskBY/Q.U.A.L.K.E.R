
/////////////////////////////////////////
////////////// UI ELEMENTS //////////////
/////////////////////////////////////////

vector screensize;
vector mouse_pos;
vector last_mouse_pos;
vector vid_res;
float vy_rel;
float vx_rel;
float font_size;
float clicked;
float showCursor;

void(string txt, vector pos) txt =
{
	drawstring(pos, txt, [font_size, font_size], '1 1 1', 1, 0);
};

void() UpdateMouse = 
{
 	vector raw_mouse;
 	raw_mouse = getmousepos();
 	mouse_pos += raw_mouse;
 	if (mouse_pos_x < 0) mouse_pos_x = 0;
 	if (mouse_pos_x > screensize_x) mouse_pos_x = screensize_x;
 	if (mouse_pos_y < 0) mouse_pos_y = 0;
 	if (mouse_pos_y > screensize_y) mouse_pos_y = screensize_y;
	showCursor = false;
};

void() GetRelative =
{
	font_size = screensize_x * 0.02;
	if (((vid_res_x == 2560) && (vid_res_y == 1440)) || ((vid_res_x == 2560) && (vid_res_y == 1080)) || ((vid_res_x == 3440) && (vid_res_y == 1440)) || ((vid_res_x == 5120) && (vid_res_y == 2160)))
	{	
		vx_rel = ((screensize_x / 1134));
		vy_rel = ((screensize_y / 540));
	}
	else if ((vid_res_x == 4096) && (vid_res_y == 2160))
	{	
		vx_rel = ((screensize_x / 1134));
		vy_rel = ((screensize_y / 540));
	}
	else if ((vid_res_x == 3840) && (vid_res_y == 1600))
	{	
		vx_rel = ((screensize_x / 1134));
		vy_rel = ((screensize_y / 540));
	}
	else
	{
		vx_rel = ((screensize_x / 960));
		vy_rel = ((screensize_y / 540));
	}
};

vector(vector vctr) fixed_vector = 
{
	return [rint(vctr_x * vx_rel), rint(vctr_y * vy_rel)];
};


float check_mouse(vector pos, vector pos2)
{
	pos -= fixed_vector('5 0 0');
 	pos2 += fixed_vector('5 0 0');
	if (mouse_pos_x > pos_x && mouse_pos_x < pos2_x)
	{
		if (mouse_pos_y > pos_y && mouse_pos_y < pos2_y)
			return 1;
	}
	return 0;
};

float(vector pos, vector buttonSize, string name) button =
{
	if(check_mouse(pos, pos + buttonSize))
	{
		drawfill(pos, buttonSize, '0.6 0.53 0.4', 0.5, 0);
		if(clicked) 
		{
			clicked = FALSE;
			return TRUE;
		}
	}
	else drawfill(pos, buttonSize, '0.1 0.1 0.1', 0.5, 0);
	drawstring([screensize_x / 2 - (strlen(name) / 2) * font_size, pos_y + font_size * 0.4], name, [font_size, font_size], '1 1 1', 0.9, 0);
	return FALSE;
};

void(vector pos, string title, string text) intermission_text =
{
	local string dots = ".........................";
	dots = strcat(substring(dots, 0, strlen(dots) - strlen(text)), text);
	dots = strcat(title, substring(dots, strlen(title), strlen(dots)));
	drawstring(pos, dots, [font_size, font_size], '1 1 1', 1, 0);
};

void(vector pos, string title, string text) scoresboard_text =
{
	local string dots = "                         ";
	dots = strcat(substring(dots, 0, strlen(dots) - strlen(text)), text);
	dots = strcat(title, substring(dots, strlen(title), strlen(dots)));
	drawstring(pos, dots, [font_size, font_size], '1 1 1', 1, 0);
};