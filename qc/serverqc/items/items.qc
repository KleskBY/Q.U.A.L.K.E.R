
//Respawn item
void() SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	sound (self, CHAN_VOICE, "misc/item_respawn.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin (self, self.origin);
};

//Prints a warning message when spawned
void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};

//Plants the object on the floor
void() PlaceItem =
{
	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
};

//Sets the clipping size and plants the object on the floor
void() StartItem =
{
	self.item = TRUE;
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};


