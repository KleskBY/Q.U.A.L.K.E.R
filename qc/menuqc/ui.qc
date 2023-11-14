
/////////////////////////////////////////////////////////////////////
//////////////////////////   GLOBALS  ///////////////////////////////
/////////////////////////////////////////////////////////////////////

vector vid_res;
vector vid;
float vy_rel;
float vx_rel;
float font_size;
float menu;

string lastHighlighted;
float clicked;
string exec;
float mouse1_held;
string bindingBind;
string selected_input_field;
float selected_input_max_length;

float MAX_NAME_LENGTH = 22;

vector COLOR_NOT_SELECTED = '0.1 0.1 0.1';
float COLOR_NOT_SELECTED_ALPHA = 0.75;

void() GetRelative =
{
	vid = [ stof(cvar_string("vid_conwidth")), stof(cvar_string("vid_conheight")) ];
	font_size = vid_x * 0.02;
	if (((vid_res_x == 2560) && (vid_res_y == 1440)) || ((vid_res_x == 2560) && (vid_res_y == 1080)) || ((vid_res_x == 3440) && (vid_res_y == 1440)) || ((vid_res_x == 5120) && (vid_res_y == 2160)))
	{	
		vx_rel = vid_x / 1134;
		vy_rel = vid_y / 540;
	}
	else if ((vid_res_x == 4096) && (vid_res_y == 2160))
	{	
		vx_rel = vid_x / 1134;
		vy_rel = vid_y / 540;
	}
	else if ((vid_res_x == 3840) && (vid_res_y == 1600))
	{	
		vx_rel = vid_x / 1134;
		vy_rel = vid_y / 540;
	}
	else
	{
		vx_rel = vid_x / 960;
		vy_rel = vid_y / 540;
	}
};


/////////////////////////////////////////////////////////////////////
/////////////////////////	MOUSE	/////////////////////////////////
/////////////////////////////////////////////////////////////////////

vector mouse_pos;
vector last_mouse_pos;
void() UpdateMouse = 
{
 	vector raw_mouse;
 	raw_mouse = getmousepos();
 	mouse_pos += raw_mouse; // add some mouse acceleration
 	if (mouse_pos_x < 0) mouse_pos_x = 0;
 	if (mouse_pos_x > vid_x) mouse_pos_x = vid_x;
 	if (mouse_pos_y < 0) mouse_pos_y = 0;
 	if (mouse_pos_y > vid_y) mouse_pos_y = vid_y;
	if (!mouse1_held) last_mouse_pos = mouse_pos;
 };

vector(vector vctr) fixed_vector = 
{
	return [rint(vctr_x * vx_rel), rint(vctr_y * vy_rel)];
};

float check_mouse(vector pos, vector pos2)
{
	pos -= fixed_vector('5 2 0');
 	pos2 += fixed_vector('5 12 0');
	// drawfill(pos, pos2 - pos, COLOR_NOT_SELECTED, COLOR_NOT_SELECTED_ALPHA, 0);
	if (mouse_pos_x >= pos_x && mouse_pos_x <= pos2_x)
	{
		if (mouse_pos_y >= pos_y && mouse_pos_y <= pos2_y)
			return 1;
	}
	return 0;
};

/////////////////////////////////////////////////////////////////////
////////////////////////   UI FUNCTION   ////////////////////////////
/////////////////////////////////////////////////////////////////////

void() command = 
{
	cmd(exec);
}
void() page = 
{
	menu = stof(exec);
}
void() bindKey =
{
	bindingBind = exec;
	local string oldKey = "unbind ";
	tokenize(findkeysforcommand(bindingBind, 0));
	if (argv(0) != "-1") string fw_key = keynumtostring(stof(argv(0)));
	else fw_key = " ";
	cmd(strcat(oldKey, fw_key));
};

void() start_server = 
{
	local float maxplayers = (cvar("saved3") + 1) * 2;
	if(maxplayers == 12) cmd("maxplayers 20\n");
	else cmd(strcat("maxplayers ", ftos(maxplayers), "\n"));

	local string startcmd;
	if(cvar("saved1") == MODE_COOP) startcmd = "disconnect; sv_public 1; coop 1; deathmatch 0; teamplay 1; ";
	if(cvar("saved1") == MODE_DM) startcmd = "disconnect; sv_public 1; coop 0; deathmatch 1; teamplay 0; ";
	if(cvar("saved1") == MODE_SURV) startcmd = "disconnect; sv_public 1; coop 1; deathmatch 0; teamplay 1; fraglimit 0; timelimit 0; ";
	
	// if(cvar("saved1") == MODE_COOP) startcmd = strcat(startcmd, "map e1m", ftos(cvar("saved2") + 1));
	// else 
	startcmd = strcat(startcmd, "map ", strtolower(exec));

	startcmd = strcat(startcmd, "\n");
	print("//////////////////////////////////////\n");
	print(startcmd);
	print("//////////////////////////////////////\n");
	cmd(startcmd);
}


/////////////////////////////////////////////////////////////////////
////////////////////////   UI ELEMENTS   ////////////////////////////
/////////////////////////////////////////////////////////////////////

void(string txt, vector pos) text =
{
	drawstring(pos, txt, [font_size, font_size], '1 1 1', 0.9, 0);
};

void(string txt, vector pos) text_center =
{
	drawstring([ (vid_x / 2) - (stringwidth(txt, true, [font_size, font_size]) / 2), pos_y - font_size ], txt, [font_size, font_size], '1 1 1', 1, 0);
};

void(string txt, vector pos, void() func, string ex) button =
{
	local float txt_len = stringwidth(txt, true, [font_size, font_size]);
	local vector pos2 = pos + [font_size, font_size];
 	pos2_x = pos_x + txt_len;
	
	if(check_mouse(pos, pos2)) 
	{
		drawstring(pos, txt, [font_size, font_size], '0.7 0.7 0.7', 0.7, 0);
		if(clicked)
		{
			localsound("sound/misc/menu2.wav");
			exec = ex;
			func();
			clicked = 0;
		}
		else if (lastHighlighted != txt)
		{
			lastHighlighted = txt;
			localsound("sound/misc/menu1.wav");
		}
	}
	else drawstring(pos, txt, [font_size, font_size], '1 1 1', 0.9, 0);
};
void(string txt, vector pos, string variable) checkbox =
{
	string mark;
	float checked = cvar(variable);
	if (checked == 1) mark = "ON";
	else mark = "OFF";
	variable = strcat(variable, " ");
	variable = strcat(variable, ftos(!checked));
	button(txt, pos, command, variable);
	button(mark, pos + [font_size * 12, 0], command, variable);
};

void slider (vector pos, vector size, string variable, float min, float max, float step)
{ 
	pos = pos + [font_size];
	size = size - [font_size];
	local float val = cvar(variable);
	local float coef = size_x / (max);
	
	local string minus = strcat(variable, " ");
	minus = strcat(minus, ftos(val - step));
	button("<", pos - [font_size], command, minus);
	
	if(check_mouse(pos, pos + size))
	{
		drawfill(pos + [0, font_size * 0.5 - 1], size, '30 30 30', 0.5, 0);
		if(mouse1_held)
		{
			mouse_pos_y = last_mouse_pos_y;
			local float newVal = (mouse_pos_x - pos_x + font_size * 0.5 - font_size * 0.5) / coef;
			local string newValStr = ftos(newVal);
			if(strstrofs(newValStr, ".", 1) != -1) 
			{
				if(step == 1) newValStr = ftos(rint(stof(newValStr)));//substring(newValStr, 0, strstrofs(newValStr, ".", 0) + 1);
				else newValStr = substring(newValStr, 0, strstrofs(newValStr, ".", 1) + 2);
			}
			cmd(strcat(variable, " ", newValStr));
		}
	}
	else drawfill(pos + [0, font_size * 0.5 - 1], size, COLOR_NOT_SELECTED, COLOR_NOT_SELECTED_ALPHA, 0);
	
	local string plus = strcat(variable, " ");
	plus = strcat(plus, ftos(val + step));
	button(">", pos + [size_x - font_size, 0] + [font_size, 0], command, plus);
	
	if(val < min) cmd(strcat(variable, " ", ftos(min), "\n"));
	if(val > max) cmd(strcat(variable, " ", ftos(max), "\n"));
	
	
	local float cord = coef * val;
	
	drawfill(pos + [cord, 0], [4, font_size], '10 10 10', 0.8, 0);
	local string printedVal = ftos(val);
	if(strstrofs(printedVal, ".", 1) != -1) printedVal = substring(printedVal, 0, strstrofs(printedVal, ".", 0) + 2);
	local float txt_len = stringwidth(printedVal, true, [font_size, font_size]);
	text(printedVal, pos + [cord - txt_len / 2, font_size]); 
}; 

void(string name, vector pos, string bindname) keybind = 
{
	text(name, pos);
	// local float txt_len = stringwidth(name, true, [font_size, font_size]);
	
	tokenize(findkeysforcommand(bindname, 0));
	if (argv(0) != "-1") string fw_key = keynumtostring(stof(argv(0)));
	else fw_key = "NONE";
	if(strlen(bindingBind) == 0 || bindingBind != bindname)
		button(fw_key, [pos_x + font_size * 12, pos_y], bindKey, bindname);
	else 
		button("...", [pos_x + font_size * 12, pos_y], command, "");
};


void(string cvar_name, vector pos, float max_length, string name) input_text = 
{
	local float offset = font_size * strlen(name);
	local float txt_len = font_size * strlen(name) + font_size * max_length; //stringwidth(txt, true, [font_size, font_size]);
	local vector pos2 = pos + [font_size, font_size];
 	pos2_x = pos_x + txt_len;
	
	if(check_mouse(pos, pos2)) 
	{
		drawstring(pos, name, [font_size, font_size], '2 2 2', 1, 0);
		drawfill([pos_x + offset, pos_y], [font_size * max_length, font_size], '0.1 0.1 0.1', 0.8, 0);
		selected_input_field = cvar_name;
		selected_input_max_length = max_length;
		text(cvar_string(cvar_name), [pos_x + offset, pos_y]);
		local float f = rint(gettime() * 10) % 5;
		if(f < 3) text("_", [pos_x + offset + stringwidth(str_cvar(cvar_name), true, [font_size, font_size]), pos_y]);
	}
	else
	{
		drawstring(pos, name, [font_size, font_size], '1 1 1', 1, 0);
		drawfill([pos_x + offset, pos_y], [font_size * max_length, font_size], '0.1 0.1 0.1', 0.5, 0);
		selected_input_field = "";
		text(str_cvar(cvar_name), [pos_x + offset, pos_y]);
	}
}

string(vector pos, float size, string items, string val, float max_val) combobox =
{
	string list = items;
	local float ofs;
	local float i;
	for(i = 0; i < cvar(val); i++)
	{
		ofs = strstrofs(list, "|", 0) + 1;
		list = substring(list, ofs, strlen(list) - ofs);
	}
	string draw = substring(list, 0, strstrofs(list, "|", 0));
	button("<", pos, command, strcat(val, " ", ftos(cvar(val) - 1), "\n")); //strcat(val, " ", val - 1, "\n")
	button(">", [pos_x + font_size * size, pos_y], command, strcat(val, " ", ftos(cvar(val) + 1), "\n")); //strcat(val, " ", val - 1, "\n")
	// button(draw, [pos_x + font_size * (size / 2 - (strlen(draw) / 2)), pos_y], command, strcat(val, " ", ftos(cvar(val) + 1), "\n"));
	button(draw, [pos_x + ((size / 2) * font_size) - (stringwidth(draw, 1, [font_size, font_size]) / 2), pos_y], command, strcat(val, " ", ftos(cvar(val) + 1), "\n"));
	if(cvar(val) < 0) cmd(strcat(val, " ", ftos(max_val - 1), "\n"));
	if(cvar(val) > (max_val - 1)) cmd(strcat(val, " 0\n"));
	return draw;
}






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