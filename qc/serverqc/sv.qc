void(float pcolor) SV_ChangeTeam =
{
	if(deathmatch) T_Damage(self, world, world, self.health);
}

void(string s) SV_ParseClientCommand
{
	if(strstrofs(s, "/buy", 0) >= 0)
	{
		string purchase = substring(s, strstrofs(s, "/buy", 0) + 5, 25);
		ProcessBuy(self, purchase);
	}
	else clientcommand(self, s);
};