

float menu;
float mouse1_held;
float clicked;
float once;
entity w;

float lastTime;
void(float a, float b) m_draw = 
{
	frametime = gettime() - lastTime;
	lastTime = gettime();
	SetScreenValues(cvar("vid_width"), cvar("vid_height"));
	if(!once)
	{
		//MakeHead(
		w = CreateWindow([0, 0, 0], [ cvar("vid_width") / 10, cvar("vid_height") / 10, 0], 0, "menu");
		// addElement(w, menubutton("New game", [1, 1, 1], [1, 1, 1], 12));
		// addElement(w, textbox("fasfs", [1, 1], [1, 1, 1], 12));
		addElement(w, slider([8, 8], [32, 4], 0, 1, "volume"));
		// addElement(w, textbox("test", [w.size_x / 4, -2], [1, 1], 4));
		entity but2 = button("button123", [32, 5], [32, 16], 4);
		// but2.next_action = buttonclick;
		// but2.handles_input = true;
		// but2.input = button_input;
		addElement(w, but2);
		// addElement(w, button("button", [64, 64], [1, 1], 6));
		once = true;
	}
	
	if(!menu) return;
	DrawWindows();
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
		menu = 1;
	}
	else m_hide();
 };

void(float key, float ascii) m_keydown = 
{
	if (key == K_ESCAPE) m_toggle(1);
	if (key == K_MOUSE1) { clicked = 1; mouse1_held = 1; }
	HandleWindowInput(0, key, ascii);
};

void(float key, float ascii) m_keyup = 
{
 	if (key == K_MOUSE1) mouse1_held = 0;
	HandleWindowInput(1, key, ascii);
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

	cmd("vid_desktopfullscreen 0\n");
	cmd("sv_sound_land player/land1.wav\n");
	m_toggle(1);
	if (clientstate() != CS_CONNECTED) m_toggle(1); //reenable menu if no demo1.dem
};
void() m_shutdown = {};