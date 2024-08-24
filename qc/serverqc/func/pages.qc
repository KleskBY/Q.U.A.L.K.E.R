
void trigger_changelevel_pages_touch()
{
	if(other.classname != "player") return;
	if(self.pages > other.pages) 
	{
		local string str;
		float pages_left = self.pages - other.pages;
		if(pages_left == 1)
		{
			centerprint(other, "I need to collect just one more.\n");
		}
		else if(other.pages == 0)
		{
			str = "I need to collect ";
			str = strcat(str, ftos(pages_left));
			str = strcat(str, " documents before I can leave.\n");
			centerprint(other, str);
		}
		else
		{
			str = "I need to collect ";
			str = strcat(str, ftos(pages_left));
			str = strcat(str, " more.\n");
			centerprint(other, str);
		}
		return;
	}
	
	changelevel_touch();
};

void() trigger_changelevel_pages =
{
	if (!self.map) objerror("chagnelevel trigger doesn't have map");
	InitTrigger();
	self.touch = trigger_changelevel_pages_touch;
};
