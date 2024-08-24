

void PlayerAmbientPrecache()
{
	precache_sound("ambient/org_moan_1.wav");
	precache_sound("ambient/org_moan_2.wav");
	precache_sound("ambient/org_moan_3.wav");
	precache_sound("ambient/org_moan_4.wav");
	precache_sound("ambient/org_moan_5.wav");
	precache_sound("ambient/org_moan_6.wav");
	precache_sound("ambient/rnd_ak47_1.wav");
	precache_sound("ambient/rnd_distantmortar3.wav");
	precache_sound("ambient/rnd_m-16_4.wav");
	precache_sound("ambient/rnd_m-249.wav");
	precache_sound("ambient/rnd_moan1.wav");
	precache_sound("ambient/rnd_moan2.wav");
	precache_sound("ambient/rnd_moan3.wav");
	precache_sound("ambient/rnd_moan4.wav");
	precache_sound("ambient/rnd_moan5.wav");
	precache_sound("ambient/rnd_moan6.wav");
	precache_sound("ambient/rnd_scr1.wav");
	precache_sound("ambient/rnd_scr2.wav");
	precache_sound("ambient/rnd_scr3.wav");
	precache_sound("ambient/rnd_scr4.wav");
	precache_sound("ambient/rnd_scr5.wav");
	precache_sound("ambient/rnd_scr6.wav");
	precache_sound("ambient/rnd_scr7.wav");
	precache_sound("ambient/rnd_scr8.wav");
	precache_sound("ambient/rnd_scr9.wav");
	precache_sound("ambient/rnd_scr10.wav");
	precache_sound("ambient/rnd_the_horror1.wav");
	precache_sound("ambient/rnd_the_horror2.wav");
	precache_sound("ambient/rnd_the_horror3.wav");
	precache_sound("ambient/rnd_the_horror4.wav");
	precache_sound("ambient/rt_swamp_thing1.wav");
};

void PlayerAmbient()
{
	if(time < 15) return;
	if(random() > 0.1) return;
	if(self.waitmin < time)
	{
		if(mapname != "lab")
		{
			local vector org = self.origin + randomvec() * random(2300, 2700);
			// DrawLine(self.origin, org);
			local float r = rint(random(0.9, 31.1));
			if(r == 1) pointsound(org, "ambient/org_moan_1.wav", 1, SoundRadius(3000));
			else if(r == 2) pointsound(org, "ambient/org_moan_2.wav", 1, SoundRadius(3000));
			else if(r == 3) pointsound(org, "ambient/org_moan_3.wav", 1, SoundRadius(3000));
			else if(r == 4) pointsound(org, "ambient/org_moan_4.wav", 1, SoundRadius(3000));
			else if(r == 5) pointsound(org, "ambient/org_moan_5.wav", 1, SoundRadius(3000));
			else if(r == 6) pointsound(org, "ambient/org_moan_6.wav", 1, SoundRadius(3000));
			else if(r == 7) pointsound(org, "ambient/rnd_ak47_1.wav", 1, SoundRadius(3000));
			else if(r == 8) pointsound(org, "ambient/rt_swamp_thing1.wav", 1, SoundRadius(3000));
			else if(r == 9) pointsound(org, "ambient/rnd_distantmortar3.wav", 1, SoundRadius(3000));
			else if(r == 10) pointsound(org, "ambient/rnd_the_horror4.wav", 1, SoundRadius(3000));
			else if(r == 11) pointsound(org, "ambient/rnd_m-16_4.wav", 1, SoundRadius(3000));
			else if(r == 12) pointsound(org, "ambient/rnd_m-249.wav", 1, SoundRadius(3000));
			else if(r == 13) pointsound(org, "ambient/rnd_moan1.wav", 1, SoundRadius(3000));
			else if(r == 14) pointsound(org, "ambient/rnd_moan2.wav", 1, SoundRadius(3000));
			else if(r == 15) pointsound(org, "ambient/rnd_moan3.wav", 1, SoundRadius(3000));
			else if(r == 16) pointsound(org, "ambient/rnd_moan4.wav", 1, SoundRadius(3000));
			else if(r == 17) pointsound(org, "ambient/rnd_moan5.wav", 1, SoundRadius(3000));
			else if(r == 18) pointsound(org, "ambient/rnd_moan6.wav", 1, SoundRadius(3000));
			else if(r == 19) pointsound(org, "ambient/rnd_scr1.wav", 1, SoundRadius(3000));
			else if(r == 20) pointsound(org, "ambient/rnd_scr2.wav", 1, SoundRadius(3000));
			else if(r == 21) pointsound(org, "ambient/rnd_scr3.wav", 1, SoundRadius(3000));
			else if(r == 22) pointsound(org, "ambient/rnd_scr4.wav", 1, SoundRadius(3000));
			else if(r == 23) pointsound(org, "ambient/rnd_scr5.wav", 1, SoundRadius(3000));
			else if(r == 24) pointsound(org, "ambient/rnd_scr6.wav", 1, SoundRadius(3000));
			else if(r == 25) pointsound(org, "ambient/rnd_scr7.wav", 1, SoundRadius(3000));
			else if(r == 26) pointsound(org, "ambient/rnd_scr8.wav", 1, SoundRadius(3000));
			else if(r == 27) pointsound(org, "ambient/rnd_scr9.wav", 1, SoundRadius(3000));
			else if(r == 28) pointsound(org, "ambient/rnd_scr10.wav", 1, SoundRadius(3000));
			else if(r == 29) pointsound(org, "ambient/rnd_the_horror1.wav", 1, SoundRadius(3000));
			else if(r == 30) pointsound(org, "ambient/rnd_the_horror2.wav", 1, SoundRadius(3000));
			else if(r == 31) pointsound(org, "ambient/rnd_the_horror3.wav", 1, SoundRadius(3000));
			self.waitmin = time + 25 + random(0, 25);
		}
	}
}