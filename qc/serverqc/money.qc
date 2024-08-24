
.float can_buy;

void AddMoney(entity targ, float amount)
{
	amount = rint(amount);
	targ.money = targ.money + amount;
	sprint(targ, strcat("You received ", ftos(amount), " bucks.\n"));
};

void RemoveMoney(entity targ, float amount)
{
	amount = rint(amount);
	targ.money = targ.money - amount;
	sprint(targ, strcat("You lost ", ftos(amount), " bucks.\n"));
};

void() buy_zone_touch =
{
	other.can_buy = time + 2;
};

void() buy_zone =
{
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	InitTrigger();
	// setsize (self, self.pos1, self.pos2);
	self.touch = buy_zone_touch;

};




void W_SetCurrentAmmo();
void ProcessBuy(entity targ, string purchase)
{
	float id = GetItemID(purchase);
	float price = GetPriceFromID(id);
	if(targ.can_buy < time)
	{
		sprint(targ, "You are not in a buy zone!\n");
		return;
	}
	if(id == 0)
	{
		sprint(targ, "No such item!\n");
		return;
	}
	if(id == self.weapon || id == self.slot[3] || id == self.slot[4] || id == self.slot[2])
	{
		sprint(targ, "You already own this weapon!\n");
		return;
	}
	// targ.money = 99999;
	if(targ.money >= price)
	{
		if(id > 0) //weapon
		{
			if(!targ.slot[3] || !targ.slot[4])
			{
				RemoveMoney(targ, price);
				if(!targ.slot[3]) 
				{
					targ.slot[3] = id;
					targ.impulse = 3;
					return;
				}
				if(!targ.slot[4]) 
				{
					targ.slot[4] = id;
					targ.impulse = 4;
					return;
				}
			}
			else sprint(targ, "No empty slot! Sell something first\n");
		}
		else
		{
			RemoveMoney(targ, price);
			if(id == ITEM_MEDKIT) targ.medkits = targ.medkits + 1;
			if(id == ITEM_9X18) targ.ammo9x18 += 40; 
			if(id == ITEM_9X19) targ.ammo9x19 += 60; 
			if(id == ITEM_9X39) targ.ammo9x39 += 60; 
			if(id == ITEM_545X39) targ.ammo545x39 += 60; 
			if(id == ITEM_762x54) targ.ammo762x54 += 20;
			if(id == ITEM_SHELLS) targ.ammoShells += 20;
			if(id == ITEM_BATTS) targ.ammoBat += 20;
			if(id == ITEM_GRENADE) targ.ammoGrenades += 1;
			W_SetCurrentAmmo();
		}
	}
	else sprint(targ, "Not enough money!\n");


};






void ProcessKillMoney(entity targ, entity attacker)
{
	if(attacker.classname == "player")
	{
		if(targ.classname == "player") AddMoney(attacker, targ.money * 0.25);
		else if(targ.classname == "monster_dog") AddMoney(attacker, random(100, 125));
		else if(targ.classname == "monster_zombie") AddMoney(attacker, random(80, 120));
		else if(targ.classname == "monster_snork") AddMoney(attacker, random(150, 220));
		else if(targ.classname == "monster_bloodsucker") AddMoney(attacker, random(200, 320));
		else if(targ.classname == "monster_controller") AddMoney(attacker, random(350, 550));
		else if(targ.classname == "monster_psevdogigant") AddMoney(attacker, random(700, 1100));
		else AddMoney(attacker, 300);
	}
};