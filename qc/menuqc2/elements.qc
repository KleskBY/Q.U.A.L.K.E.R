void	localcmd(string command, ...) = #13;

void tab_input()
{
	deselect_tab(selected_element.container);
	selected_element.object_type = tab_selected;
	
}

void tab_draw()
{
	if(self.object_type==tab_selected)
		drawpic(ep,"gfx/ui/elements/button", es, '1 1 1', 0.5, 0);
	else
		drawpic(ep,"gfx/ui/elements/button", es, '1 1 1'*0.5, 0.5, 0);
	drawcenteredstring(ep, es, self.text, self.fontsize, '1 1 1', walpha);
}

entity tab_create(string txt, vector pos, vector sz, float fsize)
{
	entity e = spawn();
	e.size = sz;
	e.origin = pos;
	e.text = txt;
	e.fontsize = fsize;
	e.stack = STACK_INLINE;
	e.next = world;
	e.object_type = tab;
	e.input = tab_input;
	e.draw = tab_draw;
	return e;
}

void button_input()
{
	entity k = fadein(gettime(), 2.2, 0, 1, self);
	k.next_action = self.next_action;
}

void button_draw()
{
	drawpic(ep,"gfx/ui/elements/button", es, '1 1 1', 0.5, 0);
	drawcenteredstring(ep, es, self.text, self.fontsize, '1 1 1', walpha);
}

entity button(string txt, vector pos, vector sz, float fsize)
{
	entity e = spawn();
	e.size = sz;
	e.origin = pos;
	e.text = txt;
	e.fontsize = fsize;
	e.next = world;
	e.input = button_input;
	e.draw = button_draw;
	e.object_type = li;	
	e.handles_input = true;
	return e;
}
void slider_draw()
{
	//drawfill(ep, es, '1 0 0', 0.7, 0);
	if(selected_element == self)
		drawfill([self.container.content_origin_x, ep_y], [self.container.content_size_x, es_y], '1 0 0', 1, 0);
	vector edge_sz;
	edge_sz_y = es_y*self.fontsize;
	edge_sz_x = edge_sz_y;
	vector edge_l = ep;
	edge_l_x+=edge_sz_x*0.5;
	edge_l_y+=es_y*0.5;
	drawcenterpic(edge_l, "gfx/ui/elements/slider_side_l", edge_sz, self.color, self.alpha);
	vector edge_r = edge_l;
	edge_r_x+=es_x-edge_sz_x;
	drawcenterpic(edge_r, "gfx/ui/elements/slider_side_r", edge_sz, self.color, self.alpha);
	edge_sz_x = edge_r_x-edge_l_x;
	edge_l_x+=edge_sz_x*0.5;
	drawcenterpic(edge_l, "gfx/ui/elements/slider_back", edge_sz, self.color, self.alpha);
	edge_l_x = ep_x + edge_sz_y*1.5;
	edge_r_x = ep_x + es_x - edge_sz_y*1.5;
	edge_sz_x = edge_r_x - edge_l_x;
	if(self.is_active)
	{
		if(selected_element == self)
			self.scrollpercent = bound(0, (mousepos_x-edge_l_x)/edge_sz_x, 1);
		else
			self.is_active = false;
	}
	edge_l_x += self.scrollpercent*edge_sz_x;
	edge_sz_x = edge_sz_y;
	drawcenterpic(edge_l, "gfx/ui/elements/slider_front", edge_sz*2, self.color, self.alpha);
	
}

void slider_input()
{
	string txt;
	if(event == IE_KEYUP)
	{
		if(key == K_MOUSE1)
		{
			self.is_active=false;
			txt=strcat(self.text, " ", ftos(self.minvalue + self.scrollpercent*(self.maxvalue-self.minvalue)));
			localcmd(txt);
		}
	}
	else if(event == IE_KEYDOWN)
	{
		if(key == K_DPAD_LEFT)
		{
			self.scrollpercent=bound(0,self.scrollpercent-DPAD_SCROLL_LEVEL,1);
			txt=strcat(self.text, " ", ftos(self.minvalue + self.scrollpercent*(self.maxvalue-self.minvalue)));
			localcmd(txt);
		}
		else if(key == K_DPAD_RIGHT)
		{
			self.scrollpercent=bound(0,self.scrollpercent+DPAD_SCROLL_LEVEL,1);
			txt=strcat(self.text, " ", ftos(self.minvalue + self.scrollpercent*(self.maxvalue-self.minvalue)));
			localcmd(txt);
		}
	}
}

entity slider(vector pos, vector sz, float minv, float maxv, string cm)
{
	entity e = spawn();
	e.origin = pos;
	e.size = sz;
	e.fontsize = 0.2;
	e.color = '1 1 1';
	e.alpha = 1;
	e.draw = slider_draw;
	e.handles_input = true;
	e.input = slider_input;
	e.next = world;
	e.text = cm;
	e.object_type = li;
	e.minvalue = minv;
	e.maxvalue = maxv;
	e.scrollpercent = (cvar(e.text) - e.minvalue) / (e.maxvalue - e.minvalue);
	return e;
}

void drawpicture()
{
	drawpic(ep, self.text, es, self.color, self.alpha, self.flags);
}

entity picture(string pic, vector pos, vector sz, float alph)
{
	entity e = spawn();
	e.text = pic;
	e.origin = pos;
	e.size = sz;
	e.alpha = alph;
	e.draw = drawpicture;
	e.next = world;
	e.color = '1 1 1';
	return e;
}

void() render_farground
{
	
	vector pos;
	float d=1/1000;
	pos_x=self.container.content_origin_x;
	pos_y=self.container.content_origin_y-self.container.view_ofs_y*self.container.content_size_y*d*0.01+self.container.content_size_y*0.5;
	drawfill(pos, [self.container.content_size_x, self.container.content_size_y-pos_y+self.container.content_origin_y, 0], '0 0 0', 1, 0);
}
void() render_ground
{
	vector pos;
	vector sz;
	float d = 1.5-self.container.view_ofs_z;
	if(self.container.view_ofs_z>=1)
	{
		if(self.container.view_ofs_y<=0)
			drawfill(self.container.content_origin, self.container.content_size, '0 0 0', 1, 0);
		return;
	}
	float factor=0.01/d;
	sz_x=600*self.container.content_size_y*factor*ratio;
	sz_y=7*self.container.content_size_y*factor;
	pos_x = self.container.content_origin_x+(200-modm(self.container.view_ofs_x, 500))*factor*ratio*self.container.content_size_y-sz_x*0.5+0.5*self.container.content_size_x;
	//pos_x=self.container.content_size_x*modm(pos_x, self.container.content_size_x);
	pos_y = self.container.content_origin_y+(0.5+self.container.view_ofs_y*factor)*self.container.content_size_y-sz_y;
	
	while(pos_x>self.content_origin_x)
		pos_x-=sz_x;
	while(pos_x<self.container.content_origin_x+self.container.content_size_x)
	{
		drawpic(pos, "gfx/art/ground2.png", sz, '0.15 0.15 0.15', 1, 0);
		pos_x+=sz_x;
	}
	d=1-self.container.view_ofs_z;
	factor=0.01/d;
	sz_x=500*self.container.content_size_y*ratio*factor;
	sz_y=5*self.container.content_size_y*factor;
	pos_x = self.container.content_origin_x+(400-modm(self.container.view_ofs_x, 500))*factor*ratio*self.container.content_size_y-sz_x*0.5+0.5*self.container.content_size_x;
	//pos_x=self.container.content_size_x*modm(pos_x, self.container.content_size_x);
	pos_y = self.container.content_origin_y+(0.5+self.container.view_ofs_y*factor)*self.container.content_size_y-sz_y;
	while(pos_x>self.content_origin_x)
		pos_x-=sz_x;
	while(pos_x<self.container.content_origin_x+self.container.content_size_x)
	{
		drawpic(pos, "gfx/art/ground.png", sz, '0 0 0', 1, 0);
		pos_x+=sz_x;
	}
	pos_x=self.container.content_origin_x*ratio;
	pos_y=self.container.content_origin_y+self.container.view_ofs_y*self.container.content_size_y*0.01+self.container.content_size_y*0.5;
	drawfill(pos, [self.container.content_size_x, self.container.content_size_y-pos_y+self.container.content_origin_y, 0], '0 0 0', 1, 0);
	
}

void() drawBackground
{
	drawfill(self.content_origin, self.content_size, '1 0.45 0.17', 1, 0);
	float d =- self.container.view_ofs_z+1;
	// /*
	// if(mousepos_x>self.content_origin_x+self.content_size_x*0.9)
		// self.container.view_ofs_x+=100*d*frametime;
	// else if(mousepos_x<self.content_origin_x+self.content_size_x*0.1)
		// self.container.view_ofs_x-=100*d*frametime;
	// */
	//self.view_ofs_y=bound(0, (5-time)*10, 100);
	//self.container.view_ofs_x=0;
	//self.container.view_ofs_x=time*20-200;
	//drawfill([0, self.container.view_ofs_y*self.content_size_y*0.01, 0], [self.content_size_x, self.content_size_y-self.container.view_ofs_y*self.content_size_y*0.01, 0], '0 1 1', 1, 0);
	//drawcenteredstring('0 0 0', self.content_size, vtos(self.container.view_ofs), 5, '1 1 1', 1);
}
entity(entity w, vector v, vector sz, string t, float a) addob
{
	entity e = picture(t, v, sz, a);
	float d=-w.view_ofs_z+1;
	vector col = '1 1 1'*bound(0, d*0.01, 0.3);
	e.color = col;
	e.origin+='0.5 0.5 0';
	e.rendered = true;
	e.align = ALIGN_CENTER;
	addElement(w, e);
	return e;
}

void textbox_draw()
{
	drawfont = FONT_DEFAULT;
	//drawfill(ep, es, '1 0 0', 1, 0);
	vector fsize = [self.fontsize*ratio*screensize_y*0.01, self.fontsize*screensize_y*0.01];
	vector txtsz;
	txtsz_x = stringwidth(self.text, false, fsize);
	txtsz_y = fsize_y;
	drawstring(ep+[(es_x-txtsz_x)*self.align, (es_y-txtsz_y)*0.5], self.text, fsize, self.color, self.alpha, 0);
}

entity textbox(string txt, vector pos, vector sz, float fsize)
{
	entity e = spawn();
	e.size = sz;
	e.origin = pos;
	e.text = txt;
	e.fontsize = fsize;
	e.next = world;
	e.draw = textbox_draw;
	e.alpha = 1;
	e.color = '1 1 1';
	e.align = ALIGN_LEFT;
	return e;
}

void menutext_draw()
{
	float temp = drawfont;
	if(self.font)
		drawfont = self.font;
	drawcenteredstring(ep, es, self.text, self.fontsize, self.color, self.alpha);
	drawfont=temp;
}

void menubutton_draw()
{
	//drawfill(ep, es, '1 0 0', 1, 0);
	float temp = drawfont;
	if(self.font)
		drawfont = self.font;
	vector tempcol = self.color;
	if(selected_element != self)
		self.color = '0.4 0.4 0.4';
	textbox_draw();
	self.color = tempcol;
	drawfont = temp;
}
void menubutton_input()
{
	selected_element = self;
	button_input();
}


entity menubutton (string txt, vector pos, vector sz, float fsize)
{
	entity e = spawn();
	e.size = sz;
	e.origin = pos;
	e.text = txt;
	e.fontsize = fsize;
	e.next = world;
	e.color = '1 1 1';
	//e.handles_input = true;
	e.rendered = true;
	e.draw = menubutton_draw;
	return e;
}

void buttonclick()
{
	localcmd("quit");
}

void paragraphdraw()
{
	vector temp = es;
	self.size_y = 100*drawparagraph (ep, temp_x, self.text, self.fontsize, 1, '1 1 1', 1)/screensize_y;
}

entity paragraph(string txt, vector pos, vector sz, float fsize)
{
	entity e = spawn();
	e.size = sz;
	e.origin = pos;
	e.text = txt;
	e.fontsize = fsize;
	e.next = world;
	e.draw = paragraphdraw;
	return e;
}

void boxdraw()
{
	drawfill(ep, es, self.color, self.alpha, 0);
}
entity box(vector pos, vector sz, vector col, float alph)
{
	entity e = spawn();
	e.size = sz;
	e.origin = pos;
	e.color = col;
	e.alpha = alph;
	e.next = world;
	e.draw = boxdraw;
	return e;
}