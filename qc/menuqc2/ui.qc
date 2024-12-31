float headersize;
const float headersize_percent = 3;
const float scrollsize = 2;
const float edgesize = 1;
const float closesize = 0.6;

const float W_NONE = 0;
const float W_NOMOVE = 1;
const float W_NORESIZE = 2;
const float W_NOHEADER = 4;
const float W_RELATIVETOSCREEN = 8;
const float W_NOHEAD = 16;
const float W_NOSCROLLBAR = 32;
const float W_BLOCKINPUT = 64;
const float RESIZE_NONE = 0;
const float RESIZE_LEFT = 1;
const float RESIZE_RIGHT = 2;
const float RESIZE_BOTTOM = 4;
const float DPAD_SCROLL_LEVEL = 0.05;


entity current_animation;
const float ANIMATION_NONE = 0;
const float ANIMATION_FADEIN = 1;
const float ANIMATION_FADEOUT = 2;

const float STACK_BLOCK = 0;
const float STACK_INLINE = 1;
const float STACK_GHOST = 2;
const float STACK_ABSOLUTE = 3;

const float ALIGN_LEFT = 0;
const float ALIGN_CENTER = 0.5;
const float ALIGN_RIGHT = 1;

float scrolloffset;
const vector windows_color = '0.1 0.1 0.1';
const vector header_color = '0.1 0.1 0.1';
const vector scrollbar_color = '0.15 0.15 0.15';
const float scaleiconsize = 5;
vector screensize;
float virtual_ratio;
float physical_ratio;
float ratio;

float move_window;
float move_scrollbar;
float resize_window;

float wlasty;
float walpha;

float event;
float key;
float character;
float element_handled;
vector ep;
vector es;
entity selected_element;
entity hover_window;
vector mousepos;
vector mouse_offset;
entity windows_head;
string cursorimage;

void SetScreenValues(float vwidth, float vheight)
{
	vector raw_mouse = getmousepos();
 	mousepos += raw_mouse; // add some mouse acceleration
	vector vid = [ stof(cvar_string("vid_conwidth")), stof(cvar_string("vid_conheight")) ];
 	if (mousepos_x < 0) mousepos_x = 0;
 	if (mousepos_x > vid_x) mousepos_x = vid_x;
 	if (mousepos_y < 0) mousepos_y = 0;
 	if (mousepos_y > vid_y) mousepos_y = vid_y;
	
	screensize = vid;
	
	virtual_ratio = screensize_x / screensize_y;
	physical_ratio = vwidth / vheight;
	ratio = virtual_ratio / physical_ratio;
}

void(vector pos, string text, float sz, vector col, float alph) drawaspectstring
{
	drawstring(pos, text, [sz * ratio * screensize_y * 0.01, screensize_y * sz * 0.01], col, alph, 0);
}

void(vector pos, vector sz, string text, float fsz, vector col, float alph) drawcenteredstring
{
	//drawfill(pos, sz, '1 0 0', 1, 0);
	vector fsize = [fsz*ratio*screensize_y*0.01, fsz*screensize_y*0.01];
	vector txtsz;
	txtsz_x = stringwidth(text, false, fsize);
	txtsz_y = fsize_y;
	drawstring(pos+sz*0.5-txtsz*0.5, text, fsize, col, alph, 0);
}

void(vector pos, string txt, vector sz, vector col, float alph) drawcenterpic
{
	drawpic(pos-sz*0.5, txt, sz, col, alph, 0);
}

float(string text, float len, float sz, float linespace) calculate_paragraph_height
{
	sz *= screensize_y * 0.01;
	float args = tokenizebyseparator(text, " ");
	float spacesz = stringwidth(" ", false, [sz*ratio, sz]);
	
	float lines = 0;
	float linewidth = 0;
	float wordwidth;
	linespace *= screensize_y * 0.01;
	for(float i = 0; i < args; i++)
	{
		wordwidth = stringwidth(argv(i), false, [sz*ratio, sz]) + spacesz;
		if(linewidth + wordwidth + spacesz < len + spacesz) linewidth += wordwidth + spacesz;
		else
		{
			lines++;
			linewidth = wordwidth;
		}
	}
	if(linewidth) lines++;
	return lines * (sz+linespace);
}
float(vector pos, float len, string text, float sz, float linespace, vector col, float alph) drawparagraph
{
	sz*=screensize_y*0.01;
	float letters = floor(len/(sz*ratio));
	linespace*=screensize_y*0.01;
	float left, textlength, wordwidth, linelength, linewidth;
	float y=pos_y;
	left = textlength = strlen(text);
	float spacesize = stringwidth(" ", false, [sz*ratio, sz]);
	float args = tokenizebyseparator(text, " ");
	for(float i =0; left > 0; i++)
	{
		wordwidth=stringwidth(argv(i), false, [sz*ratio, sz])+spacesize;
		if(linewidth+wordwidth<=len+spacesize){
			linewidth+=wordwidth;
			linelength+=strlen(argv(i))+1;
		}
		else
		{
			drawstring(pos, substring(text, textlength-left, linelength), [sz*ratio, sz], col, alph, 0);
			left-=linelength;
			linelength=strlen(argv(i))+1;
			linewidth=wordwidth;
			pos_y+=sz+linespace;
		}
	}
	return pos_y-y;
}


entity(vector pos, vector sz, float wflags, string wname) CreateWindow
{
	entity w = spawn();
	w.next = windows_head;
	w.previous = world;
	if(windows_head) windows_head.previous = w;
	windows_head = w;
	selected_element = world;
	w.flags = wflags;
	w.origin = pos;
	w.size = sz;
	w.name = wname;
	return w;
}

void(entity head, entity w) MakeHead
{
	if(windows_head == w) return;
	if(w.previous) w.previous.next = w.next;
	if(w.next) w.next.previous = w.previous;
	if(windows_head) windows_head.previous = w;
	w.next = windows_head;
	w.previous = world;
	windows_head=w;
}
vector relativesize(vector sz, float relative)
{
	if(relative) return [screensize_x * sz_x * 0.01, screensize_y * sz_y * 0.01];
	else return [screensize_y * sz_x * 0.01 * ratio, screensize_y * sz_y * 0.01];
}
vector relativepos(vector pos, vector sz)
{
	vector r = screensize-sz;
	r_x*=pos_x*0.01;
	r_y*=pos_y*0.01;
	return r;	
}



vector rendersize()
{
	float d = self.origin_z+1-self.container.view_ofs_z;
	float factor = 0.01/d;
	vector sz;
	sz_y=self.size_y*self.container.content_size_y*factor;
	sz_x=self.size_x*self.container.content_size_y*factor*ratio;
	return sz;
}

vector renderpos()
{
	float d = self.origin_z+1-self.container.view_ofs_z;
	float factor = 0.01/d;
	vector sz;
	sz_y=self.size_y*self.container.content_size_y*factor;
	sz_x=self.size_x*self.container.content_size_y*factor*ratio;
	vector pos, pos_pc;
	
	if(self.origin_x>0)
		pos_x = floor(self.origin_x);
	else
		pos_x = ceil(self.origin_x);
	pos_pc_x = self.origin_x-pos_x;
	if(self.origin_x<0)
		pos_pc_x*=-1;
	if(pos_pc_x==0.999)
		pos_pc_x=1;
	
	if(self.origin_y>0)
		pos_y = floor(self.origin_y);
	else
		pos_y = ceil(self.origin_y);
	pos_pc_y = self.origin_y-pos_y;
	if(self.origin_y<0)
		pos_pc_y*=-1;
	if(pos_pc_y==0.999)
		pos_pc_y=1;

	
	pos_x = self.container.content_origin_x+(self.origin_x-self.container.view_ofs_x)*factor*self.container.content_size_y*ratio+pos_pc_x*self.container.content_size_x;
	pos_y = self.container.content_origin_y+(self.origin_y+self.container.view_ofs_y)*factor*self.container.content_size_y+pos_pc_y*self.container.content_size_y-sz_y;
	pos_x -= sz_x*self.align;
	return pos;
}
vector epos()
{
	if(self.rendered) return renderpos();
	vector r = self.container.content_origin;
	vector pos, pos_pc;
	
	if(self.origin_x>0) pos_x = floor(self.origin_x);
	else pos_x = ceil(self.origin_x);
	pos_pc_x = self.origin_x - pos_x;
	if(self.origin_x < 0) pos_pc_x *= -1;
	if(pos_pc_x == 0.999) pos_pc_x = 1;

	pos_x = pos_x*0.01*screensize_y*ratio+pos_pc_x*self.container.content_size_x;
	
	
	if(self.origin_y>0)
		pos_y = floor(self.origin_y);
	else
		pos_y = ceil(self.origin_y);
	pos_pc_y = self.origin_y-pos_y;
	if(self.origin_y<0)
		pos_pc_y*=-1;
	if(pos_pc_y==0.999)
		pos_pc_y=1;
	pos_y = pos_y*0.01*screensize_y+pos_pc_y*self.container.content_size_y;
	
	r_y+=pos_y;
	r_x+=pos_x;
	if(self.stack != STACK_GHOST && self.stack!=STACK_ABSOLUTE)
		r_y+=wlasty;
	if(self.container.scrollpercent && self.stack != STACK_GHOST)
		r_y-=scrolloffset;
	return r;
}
vector esize()
{
	if(self.rendered) return rendersize();
	
	vector sz, sz_pc;
	
	if(self.size_x > 0) sz_x = floor(self.size_x);
	else sz_x = ceil(self.size_x);
	
	sz_pc_x = self.size_x-sz_x;
	if(self.size_x < 0) sz_pc_x*=-1;
	if(sz_pc_x == 0.999) sz_pc_x=1;
	
	sz_x = sz_x * 0.01 * screensize_y * ratio + sz_pc_x * self.container.content_size_x;
	
	if(self.size_y > 0) sz_y = floor(self.size_y);
	else sz_y = ceil(self.size_y);
	sz_pc_y = self.size_y-sz_y;
	if(self.size_y < 0) sz_pc_y *= -1;
	if(sz_pc_y == 0.999) sz_pc_y = 1;
	sz_y = sz_y * 0.01 * screensize_y + sz_pc_y * self.container.content_size_y;
	return sz;
}


void addElement(entity window, entity element)
{
	element.container = window;
	entity e = window.elements;
	if(e == world)
	{
		window.elements = element;
		element.previous = world;
		return;
	}
	while(e.next) e = e.next;
	element.previous = e;
	e.next = element;
}
void(entity e) deleteElement
{
	if(e.container.elements == e) e.container.elements = e.next;
	if(e.previous) e.previous.next = e.next;
	if(e.next) e.next.previous = e.previous;
	remove(e);
}

void clear_window(entity w)
{
	entity e=w.elements;
	entity nxt;
	while(e)
	{
		nxt = e.next;
		remove(e);
		e = nxt;
	}
}
void(entity w) deleteWindow
{
	if(windows_head == w) windows_head = w.next;
	if(w.next) w.next.previous = w.previous;
	if(w.previous) w.previous.next = w.next;
	if(selected_element.container == w) selected_element = world;
	clear_window(w);
	remove(w);
}
void() deleteAllWindows
{
	entity w = windows_head;
	entity nxt;
	while(w)
	{
		clear_window(w);
		nxt = w.next;
		remove(w);
		w = nxt;
	}
	windows_head = world;
}



void(entity w) drawBorder
{
	drawsetcliparea(w.content_origin_x, w.content_origin_y, w.content_size_x, headersize);
	vector closebutton;
	closebutton_y = headersize*closesize;
	closebutton_x = closebutton_y*ratio;
	drawfill(w.content_origin, [w.content_size_x, headersize], header_color, walpha, 0);
	drawpic(w.content_origin, "gfx/ui/win_header", [w.content_size_x, headersize], '1 1 1', walpha, 0);
	drawpic(w.content_origin+[w.content_size_x-headersize*0.5*ratio, headersize*0.5]-closebutton*0.5, "gfx/ui/win_close", closebutton, '1 1 1', walpha*0.7, 0);
	drawcenteredstring(w.content_origin, [w.content_size_x, headersize], w.text, headersize_percent*0.9, '1 1 1', walpha);
	w.content_origin_y+=headersize;
	w.content_size_y-=headersize;
	drawresetcliparea();
}

void(entity w) drawScrollbar
{
	vector barsize;
	barsize_x = scrollsize*0.01*screensize_y;
	barsize_y = w.content_size_y*w.scrollpercent;
	barsize_z = 0;
	vector barpos;
	barpos_x = w.content_origin_x+w.content_size_x;
	barpos_y = w.content_origin_y+w.scroll*(w.content_size_y-barsize_y);
	barpos_z = 0;
	
	drawfill([w.content_origin_x+w.content_size_x, w.content_origin_y], [scrollsize*0.01*screensize_y, w.content_size_y], scrollbar_color, walpha, 0);
	drawpic(barpos, "gfx/ui/win_scroll", barsize, '1 1 1', walpha, 0);
}
float(entity w) getWindowResizeFlags
{
	if(windows_head.flags & W_BLOCKINPUT && w!=windows_head) return RESIZE_NONE;
	vector mpos = mousepos;
	vector sz = w.size * 0.01 * screensize_y;
	sz_x *= ratio;
	if(!w) return RESIZE_NONE;
	if(!isinbox(mpos, w.content_origin, w.content_origin+sz)) return RESIZE_NONE;
	if(w.flags & W_NORESIZE || w.flags & W_NOHEADER || w.flags & W_RELATIVETOSCREEN) return RESIZE_NONE;
	
	float rflags = RESIZE_NONE;
	mpos -= w.content_origin;
	if(mpos_y > w.content_size_y - screensize_y * edgesize * 0.01) rflags = RESIZE_BOTTOM;
	if(mpos_x < screensize_y * edgesize * 0.01 * ratio) rflags = rflags | RESIZE_LEFT;
	if(mpos_x > sz_x - edgesize * 0.01 * screensize_y * ratio) rflags = rflags | RESIZE_RIGHT;
	return rflags;
}
void drawscaleicons(entity w)
{
	vector sz = [scaleiconsize * 0.01 * screensize_y * ratio, scaleiconsize * 0.01 * screensize_y];
	vector pos = w.content_origin;
	pos_y += w.content_size_y-sz_y * 0.5;
	pos_x -= sz_x * 0.5;
	drawpic(pos, "gfx/ui/win_scale_l", sz, '1 1 1', 1, 0);
	pos_x += w.size_x * 0.01 * screensize_y * ratio;
	drawpic(pos - [16,16], "gfx/ui/win_scale_r", sz + [16,16], '1 1 1', 1, 0);
	// drawpic(pos, "gfx/ui/win_scale_r", [32, 32], '1 1 1', 1, 0);
}



void() DrawWindows
{
	if(!windows_head) return;
	//mousepos = getmousepos();
	headersize=headersize_percent*screensize_y*0.01;
	// drawfill('0 0 0', screensize, '1 1 1', 1, 0);
	float rflags=RESIZE_NONE;
	float yleft;
	vector relsz, relpos;
	entity a;
	if(move_window==TRUE)
	{
		relsz = relativesize(windows_head.size, false);
		windows_head.origin_x=bound(0, 100*(mousepos_x-mouse_offset_x)/(screensize_x-relsz_x), 100);
		windows_head.origin_y=bound(0, 100*(mousepos_y-mouse_offset_y-headersize)/(screensize_y-relsz_y), 100);
	}
	else if(move_scrollbar==TRUE)
	{
		relsz = relativesize(windows_head.size, false);
		mouse_offset_y=mousepos_y-windows_head.content_origin_y;
		windows_head.scroll = bound(0, (mouse_offset_y-windows_head.content_size_y*windows_head.scrollpercent*0.5)/(windows_head.content_size_y*(1-windows_head.scrollpercent)), 1);
	}
	else if(resize_window!=RESIZE_NONE)
	{
		relsz = relativesize(windows_head.size, false);
		relpos = relativepos(windows_head.origin, relsz);
		if(resize_window & RESIZE_RIGHT)
		{
			windows_head.size_x = 100*(mousepos_x-relpos_x)/(screensize_y*ratio);
			windows_head.origin_x = 100*relpos_x/(screensize_x-mousepos_x+relpos_x);
		}
		else if(resize_window & RESIZE_LEFT)
		{
			windows_head.size_x = 100*(relpos_x-mousepos_x+relsz_x)/(screensize_y*ratio);
			windows_head.origin_x = 100*mousepos_x/(screensize_x-relpos_x+mousepos_x-relsz_x);	
		}
		if(resize_window & RESIZE_BOTTOM)
		{
			windows_head.size_y = 100*(mousepos_y-relpos_y)/screensize_y;
			windows_head.origin_y = 100*relpos_y/(screensize_y-mousepos_y+relpos_y);
		}
	}
	
	hover_window=world;
	entity w = windows_head;
	entity e = w;
	if(windows_head!=world)
	{	
		while(w)
		{
			e=w;
			w.content_size = relativesize(w.size, w.flags & W_RELATIVETOSCREEN);
			w.content_origin = relativepos(w.origin, w.content_size);
			if(!hover_window && isinbox(mousepos, w.content_origin, w.content_origin+w.content_size))
				hover_window=w;
			w=w.next;
		}
		w=e;
		for(; w; w = w.previous)
		{
		
			self = w;
			wlasty = yleft = 0;
			if(w == windows_head)
			{
				walpha = 0.8;
				if(w.flags & W_BLOCKINPUT) drawfill('0 0 0', screensize, '0 0 0', 0.2, 0);
			}
			else walpha = 0.5;
			
			if(w.think)
			{
				if(gettime() == w.nextthink)
					w.think();
			}
			//w.text = ftos(etof(w));
			if(!(w.flags & W_NOHEADER))
				drawBorder(w);
			drawsetcliparea(w.content_origin_x, w.content_origin_y, w.content_size_x, w.content_size_y);
			drawfill(w.content_origin, w.content_size+'0 1 0', windows_color, walpha, 0);
			
			if(w.scrollpercent)
				w.content_size_x-=scrollsize*0.01*screensize_y;
			scrolloffset = w.scroll*(1/w.scrollpercent-1)*w.content_size_y;
			if(w.draw)
				w.draw();
			if(w.view_ofs_y<w.ideal_pos_y)
				w.view_ofs_y=min(w.ideal_pos_y, w.view_ofs_y+w.velocity_y * frametime);
			else if(w.view_ofs_y>w.ideal_pos_y)
				w.view_ofs_y=max(w.ideal_pos_y, w.view_ofs_y-w.velocity_y * frametime);
			if(w.view_ofs_x<w.ideal_pos_x)
				w.view_ofs_x=min(w.ideal_pos_x, w.view_ofs_x+w.velocity_x * frametime);
			else if(w.view_ofs_x>w.ideal_pos_x)
				w.view_ofs_x=min(w.ideal_pos_x, w.view_ofs_x-w.velocity_x * frametime);
			for(e=w.elements; e; e=e.next)
			{	
				if(e.draw){
					
					self=e;
					if(e.stack == STACK_BLOCK && e.rendered!=true)
					{
						wlasty=yleft;
						yleft=0;
					}
					es = esize();
					ep = epos();
					//e.text = ftos(es_x);
					e.draw();
					if(e.think)
					{
						if(gettime() >= e.nextthink && gettime() <= e.nextthink + frametime)
							e.think();
					}
					a = e.animations;
					while(a)
					{
						if(gettime() >= a.animation_start)
						{
							current_animation = a;
							a.animate();
						}
						a = a.next;
					}
					if(e.stack != STACK_GHOST && e.rendered!=true)
					{
						if(ep_y-w.content_origin_y+scrolloffset+es_y>yleft) yleft = ep_y-w.content_origin_y+scrolloffset+es_y;
					}
				}
			}
			wlasty = yleft;
			if(w.scrollpercent) drawScrollbar(w);
			
			if(!(w.flags & W_NOSCROLLBAR) && wlasty>w.content_size_y) w.scrollpercent=w.content_size_y / wlasty;
			else
			{
				w.scroll=0;
				w.scrollpercent=0;
			}
			if(!(w.flags & W_NORESIZE) && !(w.flags & W_NOHEADER) && !(w.flags & W_RELATIVETOSCREEN)) drawscaleicons(w);
			drawresetcliparea();
		}
	}
	
	if(move_window || move_scrollbar) rflags = RESIZE_NONE;
	else if(resize_window) rflags = resize_window;
	else rflags = getWindowResizeFlags(hover_window);
	
	
	if(rflags == RESIZE_NONE) cursorimage="gfx/ui/cursor";
	else if(rflags == RESIZE_LEFT || rflags == RESIZE_RIGHT) cursorimage="gfx/ui/cursor_scale_horizontal";
	else if(rflags == RESIZE_BOTTOM) cursorimage="gfx/ui/cursor_scale_vertical";
	else if(rflags == RESIZE_LEFT | RESIZE_BOTTOM) cursorimage="gfx/ui/cursor_scale_corner_l";
	else cursorimage="gfx/ui/cursor_scale_corner_r";
	drawpic(mousepos, cursorimage, '32 32 0', '1 1 1', 1, 0);
}


entity getWindowByName(string n)
{
	entity e = windows_head;
	while(e)
	{
		if(e.text == n) return e;
		e = e.next;
	}
	return world;
}




float(float evtype, float scanx, float chary) HandleWindowInput
{	
	entity w=windows_head;
	entity e;
	vector pos, sz;
	event = evtype;
	key = scanx;
	character = chary;
	float rflags, yleft;
	if(scanx == K_MOUSE1)
	{
		if(evtype == IE_KEYUP)
		{
			move_window = false;
			move_scrollbar = false;
			resize_window = RESIZE_NONE;
		}
		else
		{
			selected_element = world;
			while(w)
			{
				sz = relativesize(w.size, w.flags & W_RELATIVETOSCREEN);
				pos = relativepos(w.origin, sz);
				if(isinbox(mousepos, pos, pos + sz))
				{
					mouse_offset = mousepos - w.content_origin;
					if(!(w.flags & W_NOHEAD))
					{
						MakeHead(windows_head, w);
						if(mouse_offset_y < 0)
						{
							if(mouse_offset_x > sz_x-headersize)
							{
								deleteWindow(w);
								return true;
							}
							move_window = true;
							return true;
						}
						rflags = getWindowResizeFlags(w);
						if(rflags)
						{
							resize_window = rflags;
							return true;
						}
					}
					if(mouse_offset_x > w.content_size_x)
					{
						move_scrollbar = true;
						return true;
					}
					scrolloffset = w.scroll * (1 / w.scrollpercent - 1) * w.content_size_y;
					e = w.elements;
					wlasty = 0;
					yleft = 0;
					while(e)
					{
						if(e.stack != STACK_GHOST)
						{
							self = e;
							if(e.stack == STACK_BLOCK && e.rendered != true)
							{
								wlasty = yleft;
								yleft = 0;
							}
							es = esize();
							ep = epos();
							if(isinbox(mousepos, ep, ep+es))
							{
								if(e.input)
								{
									if(e.handles_input)
									{
										e.is_active = true;
										selected_element = e;
									}
									else e.input();
								}
								return true;
							}
							if(e.stack != STACK_GHOST && e.rendered != true)
							{
								if(ep_y - w.content_origin_y + scrolloffset+es_y > yleft)
									yleft = ep_y - w.content_origin_y + scrolloffset + es_y;
							}
						}
						
						e = e.next;
					}
					break;
				}
				if(w == windows_head && w.flags & W_BLOCKINPUT)
					break;
				w = w.next;
			}
		}
	}
	else if((scanx == K_MWHEELUP || scanx == K_MWHEELDOWN) && evtype == IE_KEYDOWN)
	{
		if(!hover_window) return false;
		if(!hover_window.scrollpercent) return false;
		if(scanx == K_MWHEELUP) hover_window.scroll = bound(0, hover_window.scroll -0.1 * hover_window.scrollpercent, 1);
		else hover_window.scroll=bound(0, hover_window.scroll + 0.1 * hover_window.scrollpercent, 1);
	}

	element_handled = false;
	if(selected_element)
	{
		if(selected_element.input && selected_element.handles_input)
		{
			element_handled = false;
			self = selected_element;
			selected_element.input();
			if(element_handled) return true;
		}
	}
	w = windows_head;
	while(w)
	{
		if(w.input)
		{
			self = w;
			w.input();
			return element_handled;
		}
		w = w.next;
	}
	return false;
}


