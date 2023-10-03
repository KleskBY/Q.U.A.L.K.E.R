
float BuyPage;
string tooltip;

void() InventoryInit =
{
	registercommand("inventory");
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



void(float num, vector pos, vector size) DrawItem = 
{
	float weap = cvar(strcat("slot", ftos(num)));
	string icon = GetSlotIcon(weap);
	string itemname = GetSlotItemName(weap);
	if(strlen(icon) > 2)
	{
		drawpic(pos, icon, size, '1 1 1', 1, 0);
		if(check_mouse(pos, pos + size))
		{
			drawfill(pos, size, '0.6 0.53 0.4', 0.5, 0);
			if(strlen(itemname) > 1) tooltip = itemname;
		}
	}
};


void PageButton(string icon, float page, vector pos, vector size)
{
	if(page == BuyPage) icon = strcat(icon, "b");
	drawpic(pos, icon, size, '1 1 1', 1, 0);
	if(check_mouse(pos, pos + size))
	{
		drawfill(pos, size, '0.6 0.53 0.4', 0.5, 0);
		if(clicked)
		{
			BuyPage = page;
			clicked = FALSE;
		}
	}
}

void BuyButton(float weap, vector pos, vector size, string buy_cmd)
{
	string icon = GetSlotIcon(weap);
	string itemname = GetSlotItemName(weap);
	itemname = strcat(itemname, " (", ftos(GetPriceFromID(weap)), "$)");
	if(strlen(icon) < 2) return;
	
	drawpic(pos, icon, size, '1 1 1', 1, 0);
	if(check_mouse(pos, pos + size))
	{
		drawfill(pos, size, '0.6 0.53 0.4', 0.5, 0);
		if(strlen(itemname) > 1) tooltip = itemname;
		if(clicked)
		{
			localcmd(buy_cmd);
			clicked = FALSE;
		}
	}
};

void() DrawTooltip =
{
	local float offset = stringwidth(tooltip, true, [font_size, font_size]);
	drawfill(mouse_pos + [font_size, font_size], [ offset, font_size * 1], '0.1 0.1 0.1', 0.5, 0);
	txt(tooltip, mouse_pos + [font_size, font_size]);
};

void() Inventory =
{
	if(!showInventory) 
	{
		setsensitivityscale(1);
		if(cvar("r_viewscale") < 1) cvar_set("r_viewscale", "1");
		return;
	}
	cvar_set("r_viewscale", "0.1");
	setsensitivityscale(0);
	showCursor = true;

	
	drawpic([0, 0], "gfx/ui_buy_menu", [screensize_x, screensize_y], '1 1 1', 1, 0);
	
	//money
	local string moneyStr = strcat(ftos(getstati(STAT_MONEY)), " $");
	local float offset2 = stringwidth(moneyStr, true, fixed_vector('24 24 0'));
	drawstring([screensize_x * 0.97 - offset2, screensize_y * 0.045], moneyStr, fixed_vector('24 24 0'), '0.94 0.6 0.09', 1, 0);
	
	
	tooltip = "";
	DrawItem(1, [font_size * 20, font_size * 2], [font_size * 6, font_size * 4]);
	DrawItem(2, [font_size * 20, font_size * 8], [font_size * 6, font_size * 4]);
	DrawItem(3, [font_size * 27, font_size * 2], [font_size * 12, font_size * 4]);
	DrawItem(4, [font_size * 27, font_size * 8], [font_size * 12, font_size * 4]);
	
	
	//grid
	for(float x = 0; x < 15; x++) 
	{
		for(float y = 0; y < 20; y++)
		{
			drawpic([font_size * 2, font_size * 1] + [font_size * x, font_size * y], "gfx/ui_grid", [font_size, font_size], '1 1 1', 1, 0);
		}
	}

	//pages
	for(float i = 1; i < 6; i++)
	{
		PageButton(strcat("gfx/ui_buy_page", ftos(i)), i - 1, fixed_vector([0, -60 + 80 * i, 0]), fixed_vector('50 80 0'));
	}
	

	if(BuyPage == 0)
	{
		BuyButton(WP_PISTOL, [font_size * 3, font_size * 2], [font_size * 3, font_size * 2], "say /buy pm");
	}
	else if(BuyPage == 1)
	{
		BuyButton(WP_AKSU, [font_size * 3, font_size * 1], [font_size * 7, font_size * 3], "say /buy AKSU");
		BuyButton(WP_AK74, [font_size * 3, font_size * 4], [font_size * 7, font_size * 3], "say /buy AK74");
		BuyButton(WP_MP5, [font_size * 3, font_size * 7], [font_size * 7, font_size * 3], "say /buy MP5");
		BuyButton(WP_VAL, [font_size * 3, font_size * 10], [font_size * 7, font_size * 3], "say /buy VAL");
		BuyButton(WP_VSS, [font_size * 3, font_size * 13], [font_size * 7, font_size * 3], "say /buy VSS");
		BuyButton(WP_SVD, [font_size * 3, font_size * 16], [font_size * 7, font_size * 3], "say /buy SVD");
		BuyButton(WP_GAUSS, [font_size * 3, font_size * 19], [font_size * 8, font_size * 2], "say /buy GAUSS");
		
		BuyButton(WP_MOSS, [font_size * 10, font_size * 1], [font_size * 7, font_size * 2], "say /buy MOSS");
		BuyButton(WP_SPAS, [font_size * 10, font_size * 3], [font_size * 7, font_size * 2], "say /buy SPAS");
	}
	else if(BuyPage == 2)
	{
		BuyButton(ITEM_9X18, [font_size * 3, font_size * 2], [font_size * 2, font_size * 2], "say /buy 9X18");
		BuyButton(ITEM_9X19, [font_size * 6, font_size * 2], [font_size * 2, font_size * 2], "say /buy 9X19");	
		BuyButton(ITEM_9X39, [font_size * 9, font_size * 2], [font_size * 2, font_size * 2], "say /buy 9X39");
		
		BuyButton(ITEM_545X39, [font_size * 3, font_size * 4], [font_size * 2, font_size * 2], "say /buy 545X39");
		BuyButton(ITEM_762x54, [font_size * 6, font_size * 4], [font_size * 2, font_size * 2], "say /buy 762x54");	
		
		BuyButton(ITEM_SHELLS, [font_size * 3, font_size * 6], [font_size * 2, font_size * 2], "say /buy SHELLS");
		BuyButton(ITEM_BATTS, [font_size * 6, font_size * 6], [font_size * 2, font_size * 2], "say /buy BATTS");	
		
		BuyButton(ITEM_GRENADE, [font_size * 3, font_size * 8], [font_size * 2, font_size * 2], "say /buy GRENADE");
	}
	else if(BuyPage == 4)
	{
		BuyButton(ITEM_MEDKIT, [font_size * 3, font_size * 2], [font_size * 3, font_size * 2], "say /buy MEDKIT");			
	}

	if(strlen(tooltip)) DrawTooltip();
	
};