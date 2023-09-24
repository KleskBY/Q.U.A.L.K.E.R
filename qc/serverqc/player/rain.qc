

void() Rain =
{
	if(cvar("scratch1"))
	{
		if(cvar("scratch1") == 2)
		{
			local vector pos;
			pos_x = self.origin_x + random() * 512;
			pos_y = self.origin_y + random() * 512;
			pos_z = self.origin_z + random() * 256;
			pointparticles(particleeffectnum("player"), pos, '0 0 0', 1);
		}
		else 
		{
			local vector rain_min = self.origin - '600 600 200';
			local vector rain_max = self.origin + '600 600 200';
			// local float count = (rain_max_x - rain_min_x) * (rain_max_y - rain_min_y) / 16384;
			local float count = 20;
			te_particlerain(rain_min, rain_max, '0 50 -800', count, 6);
		}
	}
};