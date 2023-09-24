


void() InventoryInit =
{
	for(float i = 0; i < 40; i++)
	{
		registercvar(strcat("slot", ftos(i)), "0");
		registercvar(strcat("sloticon", ftos(i)), "");
		registercvar(strcat("slotdesc", ftos(i)), "");
		registercvar(strcat("slotamount", ftos(i)), "");
		cvar_set(strcat("slot", ftos(i)), "");
		cvar_set(strcat("sloticon", ftos(i)), "");
		cvar_set(strcat("slotdesc", ftos(i)), "");
		cvar_set(strcat("slotamount", ftos(i)), "");
	}
};

string tooltip;
void(float num, vector pos, vector size) DrawItem = 
{
	if(strlen( cvar_string(strcat("sloticon", ftos(num))) ) > 2)
	{
		drawpic(pos, cvar_string(strcat("sloticon", ftos(num))), size, '1 1 1', 1, 0);
		local float item_amount = cvar(strcat("slotamount", ftos(num)));
		if(item_amount > 9) txt(ftos(item_amount), pos + [font_size * 2, font_size * 3]);
		else if(item_amount > 0) txt(ftos(item_amount), pos + [font_size * 2, font_size * 3]);
		txt(ftos(num), pos, [font_size, font_size]);
		if(check_mouse(pos, pos + size))
		{
			drawfill(pos, size, '0.6 0.53 0.4', 0.5, 0);
			local string itemname = cvar_string(strcat("slotdesc", ftos(num)));
			if(strlen(itemname) > 1)
			{
				tooltip = itemname;
			}
			if(clicked == 2) 
			{
				localcmd(strcat("impulse ", ftos(20 + num), "\n"));
				clicked = FALSE;
			}	
			if(clicked) 
			{
				localcmd(strcat("impulse ", ftos(50 + num), "\n"));
				clicked = FALSE;
			}
		}
	}
};

void() DrawTooltip =
{
	drawfill(mouse_pos + [font_size, font_size], [font_size * strlen(tooltip), font_size * 1], '0.1 0.1 0.1', 0.5, 0);
	txt(tooltip, mouse_pos + [font_size, font_size]);
};

void() Inventory =
{
	if(!showInventory) 
	{
		// cvar_set("r_viewscale", ftos(lerp(cvar("r_viewscale"), 1, 10 * deltaTime)));
		setsensitivityscale(1);
		if(cvar("r_viewscale") < 1) cvar_set("r_viewscale", "1");
		return;
	}
	cvar_set("r_viewscale", "0.1");
	setsensitivityscale(0);
	showCursor = true;

	// drawfill([font_size * 8, font_size * 6], [font_size * 16, font_size * 4], '0.1 0.1 0.1', 0.5, 0);
	// drawfill([font_size * 8, font_size * 12], [font_size * 16, font_size * 4], '0.1 0.1 0.1', 0.5, 0);
	// drawfill([font_size * 8, font_size * 18], [font_size * 4, font_size * 4], '0.1 0.1 0.1', 0.5, 0);
	// drawfill([font_size * 14, font_size * 18], [font_size * 4, font_size * 4], '0.1 0.1 0.1', 0.5, 0);
	// drawfill([font_size * 20, font_size * 18], [font_size * 4, font_size * 4], '0.1 0.1 0.1', 0.5, 0);
	
	
	drawpic([font_size * 8, font_size * 6], "sprites/cell", [font_size * 16, font_size * 4], '1 1 1', 1, 0);
	drawpic([font_size * 8, font_size * 12], "sprites/cell", [font_size * 16, font_size * 4], '1 1 1', 1, 0);
	drawpic([font_size * 8, font_size * 18], "sprites/cell", [font_size * 4, font_size * 4], '1 1 1', 1, 0);
	drawpic([font_size * 14, font_size * 18], "sprites/cell", [font_size * 4, font_size * 4], '1 1 1', 1, 0);
	drawpic([font_size * 20, font_size * 18], "sprites/cell", [font_size * 4, font_size * 4], '1 1 1', 1, 0);
	
	tooltip = "";
	DrawItem(3, [font_size * 10, font_size * 6],[font_size * 12, font_size * 4]);
	DrawItem(2, [font_size * 10, font_size * 12], [font_size * 12, font_size * 4]);
	DrawItem(0, [font_size * 8, font_size * 18], [font_size * 4, font_size * 4]);
	DrawItem(1, [font_size * 14, font_size * 18], [font_size * 4, font_size * 4]);
	DrawItem(4, [font_size * 20, font_size * 18], [font_size * 4, font_size * 4]);
	
	
	// drawfill([screensize_x - font_size * 24, font_size * 6], [font_size * 16, font_size * 16], '0.1 0.1 0.1', 0.5, 0);
	
	for(float w = 0; w < 4; w++)
	{
		for(float y = 0; y < 4; y++)
		{
			drawpic([screensize_x - font_size * 24 + (w * 4 * font_size), font_size * 6 + (y * 4 * font_size)], "sprites/cell", [font_size * 4, font_size * 4], '1 1 1', 1, 0);
			DrawItem(5 + y * 4 + w, [screensize_x - font_size * 24 + (w * 4 * font_size), font_size * 6 + (y * 4 * font_size)], [font_size * 4, font_size * 4]);
		}
	}
	if(strlen(tooltip)) DrawTooltip();
	
};