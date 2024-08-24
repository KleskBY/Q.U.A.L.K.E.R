

void item_page_touch()
{
	if(other.classname == "useprefab") other = other.owner;
	if(other.classname != "player") return;
	other.pages = other.pages + 1;
	stuffcmd(other, "bf\n");
	
	string str = "Documents: ";
	str = strcat(str, ftos(other.pages));
	
	entity chnglvl = find(world, classname, "trigger_changelevel_pages");
	if(chnglvl)
	{
		str = strcat(str, "/");
		str = strcat(str, ftos(chnglvl.pages));
		str = strcat(str, "\n");
	}
	centerprint(other, str);
	
	sound(other, CHAN_ITEM, self.noise, 1, SoundRadius(400));

	remove(self);
};

void item_page()
{
	if(self.model)
	{
		precache_model(self.model);
		setmodel(self, self.model);
	}
	else
	{
		precache_model("models/items/docs.md3");
		setmodel(self, "models/items/docs.md3");
		self.scale = 0.85;
	}
	
	precache_sound("misc/key.wav");
	self.noise = "misc/key.wav";

	setsize(self, '-12 -12 0', '12 12 48');
	self.flags = FL_ITEM;
	self.solid = SOLID_TRIGGER;
	self.effects = EF_BLUE;
	self.touch = item_page_touch;
};