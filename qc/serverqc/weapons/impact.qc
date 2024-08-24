
float IMPACT_CHECK_SURFACE = 0;

void ImpactSoundPrecache()
{
	precache_sound("impacts/hit1.wav");
	precache_sound("impacts/hit2.wav");
	precache_sound("impacts/hit3.wav");
	precache_sound("impacts/hit4.wav");
	
	precache_sound("impacts/ric1.wav");
	precache_sound("impacts/ric2.wav");
	
	precache_sound("impacts/body1.wav");
	precache_sound("impacts/body2.wav");
	precache_sound("impacts/body3.wav");
	precache_sound("impacts/body4.wav");
	precache_sound("impacts/body5.wav");
	
	if(IMPACT_CHECK_SURFACE)
	{
		precache_sound("impacts/metal1.wav");
		precache_sound("impacts/metal2.wav");
		precache_sound("impacts/metal3.wav");
		precache_sound("impacts/metal4.wav");
		precache_sound("impacts/metal5.wav");
		
		precache_sound("impacts/wood1.wav");
		precache_sound("impacts/wood2.wav");
		precache_sound("impacts/wood3.wav");
		precache_sound("impacts/wood4.wav");
	}

};


void ImpactSoundSurface(vector org)
{
	local float rsnd;
	if(!IMPACT_CHECK_SURFACE)
	{
		if(random() > 0.2)
		{
			rsnd = rint(random() * 4) + 1;		
			if (rsnd == 1) pointsound(org, "impacts/hit1.wav", 1, SoundRadius(1900));
			else if (rsnd == 2) pointsound(org, "impacts/hit2.wav", 1, SoundRadius(1900));
			else if (rsnd == 3) pointsound(org, "impacts/hit3.wav", 1, SoundRadius(1900));
			else if (rsnd == 4) pointsound(org, "impacts/hit4.wav", 1, SoundRadius(1900));
		}
		else
		{
			if(random() >= 0.5) pointsound(org, "impacts/ric1.wav", 1, SoundRadius(2000));
			else pointsound(org, "impacts/ric2.wav", 1, SoundRadius(2000));
		}
		return;
	}
	else
	{
		local vector dir = normalize(self.origin - org);
		traceline(self.origin, org + dir, TRUE, world);
		local float surfnum = getsurfacenearpoint(self.groundentity, org + dir);
		if (surfnum >= 0)
		{
			local string s = getsurfacetexture(self.groundentity, surfnum);
			
			if(strstrofs(s, "meta", 0) >= 0)
			{
				if(random() < 0.15)
				{
					if(random() >= 0.5) pointsound(org, "impacts/ric1.wav", 1, SoundRadius(2000));
					else pointsound(org, "impacts/ric2.wav", 1, SoundRadius(2000));
					return;
				}
			
				rsnd = rint(random() * 5) + 1;		
				if (rsnd == 1) pointsound(org, "impacts/metal1.wav", 1, SoundRadius(2250));
				else if (rsnd == 2) pointsound(org, "impacts/metal2.wav", 1, SoundRadius(2250));
				else if (rsnd == 3) pointsound(org, "impacts/metal3.wav", 1, SoundRadius(2250));
				else if (rsnd == 4) pointsound(org, "impacts/metal4.wav", 1, SoundRadius(2250));
				else if (rsnd == 5) pointsound(org, "impacts/metal5.wav", 1, SoundRadius(2250));
				return;
			}
			else if(strstrofs(s, "wood", 0) >= 0 || strstrofs(s, "crate", 0) >= 0)
			{
				rsnd = rint(random() * 4) + 1;		
				if (rsnd == 1) pointsound(org, "impacts/wood1.wav", 1, SoundRadius(1250));
				else if (rsnd == 2) pointsound(org, "impacts/wood2.wav", 1, SoundRadius(1250));
				else if (rsnd == 3) pointsound(org, "impacts/wood3.wav", 1, SoundRadius(1250));
				else if (rsnd == 4) pointsound(org, "impacts/wood4.wav", 1, SoundRadius(1250));
				return;
			}
		}
		if(random() > 0.2)
		{
			rsnd = rint(random() * 4) + 1;		
			if (rsnd == 1) pointsound(org, "impacts/hit1.wav", 1, SoundRadius(1900));
			else if (rsnd == 2) pointsound(org, "impacts/hit2.wav", 1, SoundRadius(1900));
			else if (rsnd == 3) pointsound(org, "impacts/hit3.wav", 1, SoundRadius(1900));
			else if (rsnd == 4) pointsound(org, "impacts/hit4.wav", 1, SoundRadius(1900));
		}
		else
		{
			if(random() >= 0.5) pointsound(org, "impacts/ric1.wav", 1, SoundRadius(2000));
			else pointsound(org, "impacts/ric2.wav", 1, SoundRadius(2000));
		}
	}
}

void ImpactSoundBody(vector org)
{
	local float rsnd = RandomInt(1, 5);
	if (rsnd == 1) pointsound(org, "impacts/body1.wav", 1, SoundRadius(1250));
	else if (rsnd == 2) pointsound(org, "impacts/body2.wav", 1, SoundRadius(1250));
	else if (rsnd == 3) pointsound(org, "impacts/body3.wav", 1, SoundRadius(1250));
	else if (rsnd == 4) pointsound(org, "impacts/body4.wav", 1, SoundRadius(1250));
	else if (rsnd == 5) pointsound(org, "impacts/body5.wav", 1, SoundRadius(1250));
}