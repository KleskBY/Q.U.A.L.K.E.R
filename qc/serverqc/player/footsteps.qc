float FOOTSTEP_CHECK_SURFACE = 0;
float FOOTSTEP_RATE_WALK = 0.7;
float FOOTSTEP_RATE_RUN = 0.4;
float FOOTSTEP_VOLUME = 0.8;
.float footstep_finished;
float trace_dphitq3surfaceflags;

//surfaceparm slick // 2
//surfaceparm dust //262144
//surfaceparm metalsteps //4096
//surfaceparm noimpact //16
//surfaceparm nomarks //32
//surfaceparm alphashadow //65536
//surfaceparm hint //256
//surfaceparm lightfilter //32768

float SURFACE_METAL = 4096;
float SURFACE_GRAVEL = 262144;
float SURFACE_DIRT = 32;



void PlayerFootstepsPrecache()
{
	precache_sound("footsteps/footstep1.wav");
	precache_sound("footsteps/footstep2.wav");
	precache_sound("footsteps/footstep3.wav");
	precache_sound("footsteps/footstep4.wav");
	
	if(FOOTSTEP_CHECK_SURFACE)
	{
		precache_sound("footsteps/metal1.wav");
		precache_sound("footsteps/metal2.wav");
		precache_sound("footsteps/metal3.wav");
		precache_sound("footsteps/metal4.wav");	
		
		precache_sound("footsteps/dirt1.wav");
		precache_sound("footsteps/dirt2.wav");
		precache_sound("footsteps/dirt3.wav");
		precache_sound("footsteps/dirt4.wav");	

		precache_sound("footsteps/gravel1.wav");
		precache_sound("footsteps/gravel2.wav");
		precache_sound("footsteps/gravel3.wav");
		precache_sound("footsteps/gravel4.wav");		
	}
};


void PlayerFootsteps()
{
	if(vlen(self.velocity) < 60) return;

	float r = random();
	if(!FOOTSTEP_CHECK_SURFACE)
	{
		if(self.flags & FL_ONGROUND && !self.crouching && !self.button3 && self.movetype != MOVETYPE_NOCLIP)
		{
			if(time + random(0,0.1) > self.footstep_finished || self.footstep_finished == 0) 
			{
				if (r <=0.25) sound(self, CHAN_BODY, "footsteps/footstep1.wav", FOOTSTEP_VOLUME, ATTN_IDLE );
				else if (r <=0.5 && r>0.25) sound(self, CHAN_BODY, "footsteps/footstep2.wav", FOOTSTEP_VOLUME, ATTN_IDLE );
				else if (r <=0.75 && r>0.5) sound(self, CHAN_BODY, "footsteps/footstep3.wav", FOOTSTEP_VOLUME, ATTN_IDLE );
				else sound(self, CHAN_BODY, "footsteps/footstep4.wav", FOOTSTEP_VOLUME, ATTN_IDLE );
				self.footstep_finished = time + FOOTSTEP_RATE_RUN;
				if(!self.button4) self.footstep_finished = time + FOOTSTEP_RATE_WALK;
			}
		}
		return;
	}
	else
	{
		if(self.flags & FL_ONGROUND && !self.crouching && self.movetype != MOVETYPE_NOCLIP)
		{
			if(time + random(0, 0.1) > self.footstep_finished || self.footstep_finished == 0) 
			{
				tracebox(self.origin, STAND_SIZE_MIN, STAND_SIZE_MAX, self.origin - '0 0 30', FALSE, self);				
				if(trace_dphitq3surfaceflags == SURFACE_METAL)
				{
					if (r <=0.25) sound(self, CHAN_BODY, "footsteps/metal1.wav", 0.5, SoundRadius(450));
					else if (r <=0.5 && r>0.25) sound(self, CHAN_BODY, "footsteps/metal2.wav", 0.5, SoundRadius(450));
					else if (r <=0.75 && r>0.5) sound(self, CHAN_BODY, "footsteps/metal3.wav", 0.5, SoundRadius(450));
					else sound(self, CHAN_BODY, "footsteps/metal4.wav", 0.5, SoundRadius(450));
				}
				else if(trace_dphitq3surfaceflags == SURFACE_DIRT)
				{
					if (r <=0.25) sound(self, CHAN_BODY, "footsteps/dirt1.wav", FOOTSTEP_VOLUME, SoundRadius(450));
					else if (r <=0.5 && r>0.25) sound(self, CHAN_BODY, "footsteps/dirt2.wav", FOOTSTEP_VOLUME, SoundRadius(450));
					else if (r <=0.75 && r>0.5) sound(self, CHAN_BODY, "footsteps/dirt3.wav", FOOTSTEP_VOLUME, SoundRadius(450));
					else sound(self, CHAN_BODY, "footsteps/dirt4.wav", FOOTSTEP_VOLUME, SoundRadius(450));
				}
				else if(trace_dphitq3surfaceflags == SURFACE_GRAVEL)
				{
					if (r <=0.25) sound(self, CHAN_BODY, "footsteps/gravel1.wav", FOOTSTEP_VOLUME, SoundRadius(450));
					else if (r <=0.5 && r>0.25) sound(self, CHAN_BODY, "footsteps/gravel2.wav", FOOTSTEP_VOLUME, SoundRadius(450));
					else if (r <=0.75 && r>0.5) sound(self, CHAN_BODY, "footsteps/gravel3.wav", FOOTSTEP_VOLUME, SoundRadius(450));
					else sound(self, CHAN_BODY, "footsteps/gravel4.wav", FOOTSTEP_VOLUME, SoundRadius(450));
				}
				else if (self.flags & FL_INWATER && self.waterlevel > 0)
				{
					sound(self, CHAN_BODY, "misc/h2ohit1.wav", 1, SoundRadius(550));
				}
				else
				{
					if (r <= 0.25) sound(self, CHAN_BODY, "footsteps/footstep1.wav", FOOTSTEP_VOLUME, SoundRadius(450) );
					else if (r <= 0.5 && r > 0.25) sound(self, CHAN_BODY, "footsteps/footstep2.wav", FOOTSTEP_VOLUME, SoundRadius(450) );
					else if (r <= 0.75 && r > 0.5) sound(self, CHAN_BODY, "footsteps/footstep3.wav", FOOTSTEP_VOLUME, SoundRadius(450) );
					else sound(self, CHAN_BODY, "footsteps/footstep4.wav", FOOTSTEP_VOLUME, SoundRadius(450) );
				}
				
				
				if(self.running) self.footstep_finished = time + FOOTSTEP_RATE_RUN;
				else self.footstep_finished = time + FOOTSTEP_RATE_WALK;
			}
		}
	}
}
