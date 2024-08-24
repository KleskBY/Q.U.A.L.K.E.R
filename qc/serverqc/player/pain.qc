		
void() PainSound =
{
	if (self.health < 0) return;
	if (self.pain_finished > time)
	{
		self.axhitme = 0;
		return;
	}
	self.pain_finished = time + 0.1; // don't make multiple pain sounds right after each other
	
	local float rsnd = RandomInt(1, 23);
	if (rsnd == 1) sound (self, CHAN_VOICE, "player/pain01.wav", 1, SoundRadius(800)); 
	else if (rsnd == 2) sound (self, CHAN_VOICE, "player/pain02.wav", 1, SoundRadius(800)); 
	else if (rsnd == 3) sound (self, CHAN_VOICE, "player/pain03.wav", 1, SoundRadius(800)); 
	else if (rsnd == 4) sound (self, CHAN_VOICE, "player/pain04.wav", 1, SoundRadius(800));
	else if (rsnd == 5) sound (self, CHAN_VOICE, "player/pain05.wav", 1, SoundRadius(800)); 
	else if (rsnd == 6) sound (self, CHAN_VOICE, "player/pain06.wav", 1, SoundRadius(800)); 
	else if (rsnd == 7) sound (self, CHAN_VOICE, "player/pain07.wav", 1, SoundRadius(800)); 
	else if (rsnd == 8) sound (self, CHAN_VOICE, "player/pain08.wav", 1, SoundRadius(800)); 
	else if (rsnd == 9) sound (self, CHAN_VOICE, "player/pain09.wav", 1, SoundRadius(800)); 
	else if (rsnd == 10) sound (self, CHAN_VOICE, "player/pain10.wav", 1, SoundRadius(800)); 
	else if (rsnd == 11) sound (self, CHAN_VOICE, "player/pain11.wav", 1, SoundRadius(800)); 
	else if (rsnd == 12) sound (self, CHAN_VOICE, "player/pain12.wav", 1, SoundRadius(800)); 
	else if (rsnd == 13) sound (self, CHAN_VOICE, "player/pain13.wav", 1, SoundRadius(800)); 
	else if (rsnd == 14) sound (self, CHAN_VOICE, "player/pain14.wav", 1, SoundRadius(800)); 
	else if (rsnd == 15) sound (self, CHAN_VOICE, "player/pain15.wav", 1, SoundRadius(800)); 
	else if (rsnd == 16) sound (self, CHAN_VOICE, "player/pain16.wav", 1, SoundRadius(800)); 
	else if (rsnd == 17) sound (self, CHAN_VOICE, "player/pain17.wav", 1, SoundRadius(800)); 
	else if (rsnd == 18) sound (self, CHAN_VOICE, "player/pain18.wav", 1, SoundRadius(800)); 
	else if (rsnd == 19) sound (self, CHAN_VOICE, "player/pain19.wav", 1, SoundRadius(800)); 
	else if (rsnd == 20) sound (self, CHAN_VOICE, "player/pain20.wav", 1, SoundRadius(800)); 
	else if (rsnd == 21) sound (self, CHAN_VOICE, "player/pain21.wav", 1, SoundRadius(800)); 
	else if (rsnd == 22) sound (self, CHAN_VOICE, "player/pain22.wav", 1, SoundRadius(800)); 
	else if (rsnd == 23) sound (self, CHAN_VOICE, "player/pain23.wav", 1, SoundRadius(800)); 
};

void(entity attacker, float damage) PlayerPain =
{
	PainSound();
};
	