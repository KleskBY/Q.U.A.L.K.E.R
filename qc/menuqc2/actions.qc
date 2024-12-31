const float header = 1;
const float li = 2;
const float footer = 3;
const float tab = 4;
const float tab_selected = 5;


entity getFromType(entity w, float type, float index)
{
	entity e = w.elements;
	float foundindex=0;
	while(e)
	{
		if(e.object_type == type)
		{
			if(foundindex<index)
				foundindex++;
			else
				return e;
		}
		e=e.next;
	}
	return world;
}

entity getLastFromType(entity w, float type)
{
	entity e = w.elements;
	if(!e)
		return world;
	while(e.next)
		e=e.next;
	while(e)
	{
		if(e.object_type==type)
			return e;
		e=e.previous;
	}
	return world;
}

void select(entity e)
{
	selected_element = e;
}
void deselect_tab(entity w)
{
	entity e = w.elements;
	while(e)
	{
		if(e.object_type == tab_selected)
			e.object_type = tab;
		e=e.next;
	}
}

void change_tab()
{
	if(event!=IE_KEYDOWN)
		return;
	entity e = self.elements;
	while(e && e.object_type != tab_selected)
		e=e.next;
	if(!e)
	{
		e=self.elements;
		while(e && e.object_type!=tab)
			e=e.next;
		selected_element=e;
		e.input();
	}
	if(key==K_LBUMPER)
	{
		if(e.previous && e.previous.object_type==tab)
		{
			selected_element=e.previous;
			e.previous.input();
		}
	}
	else if(key==K_RBUMPER)
	{
		if(e.next && e.next.object_type==tab)
		{
			selected_element=e.next;
			e.next.input();
		}
	}
}

void circle()
{
	if(event!=IE_KEYDOWN)
		return;
	entity e = selected_element;
	if(key==K_UPARROW || key==K_DPAD_UP)
	{
		if(e==world)
		{
			e=getFromType(self, footer, self.index);
			if(!e)
				e=getFromType(self, li, self.index);
			if(!e)
				return;
			else
				select(e);
		}
		else if(e.object_type == header)
		{
			e=getFromType(self, footer, self.index);
			if(e)
				select(e);
		}
		else
		{
			e=e.previous;
			while(e)
			{
				if(e.object_type == li || e.object_type == header)
				{
					select(e);
					return;
				}
				e = e.previous;
			}
			e=getLastFromType(self, li);
			if(e)
				select(e);
		}
	}
	else if(key==K_DOWNARROW || key==K_DPAD_DOWN)
	{
		if(e==world)
		{
			e=getFromType(self, header, self.index);
			if(!e)
				e=getFromType(self, li, self.index);
			if(!e)
				return;
			else
				select(e);
		}
		else if(e.object_type==footer)
		{
			e=getFromType(self, header, self.index);
			if(e)
				select(e);
		}
		else
		{
			e=e.next;
			while(e)
			{
				if(e.object_type == li || e.object_type == footer)
				{
					select(e);
					return;
				}
				e = e.next;
			}
			e=getFromType(self, li, 0);
			if(e)
				select(e);
		}
	}
}

void accept()
{
	if(event!=IE_KEYDOWN)
		return;
	if(!selected_element)
		return;
	if(key==K_ENTER || key==K_A)
	{
		entity temp = self;
		self = selected_element;
		selected_element.input();
		self = temp;
		return;
	}
}

void close()
{
	if(event!=IE_KEYDOWN)
		return;
	if(key==K_B || key==K_ESCAPE)
	{
		if(!(self.flags & W_NOHEAD))
		{
			deleteWindow(self);
			selected_element = getFromType(windows_head, li, windows_head.index);
		}
	}
}