void(float pcolor) SV_ChangeTeam =
{
	if(deathmatch) T_Damage(self, world, world, self.health);
}