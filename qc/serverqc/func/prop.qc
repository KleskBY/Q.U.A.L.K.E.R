void() func_prop =
{
	if(world.model == "maps/e1m3.bsp")
	{
		// self.glow_color = 6;
		// self.glow_size = 250;
		// self.glow_trail = 0;
	}
	precache_model(self.weaponmodel);
	setmodel (self, self.weaponmodel);
};

void() prop_brush
{
	func_prop();
}