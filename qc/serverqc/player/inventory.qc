
float INVENTORY_SIZE = 21;
.entity slot[30];
.string icon;
.float amount;
.float amountMax;
.float() useitem;
.float selected;

/////////////////////////////
////////// ITEMS ////////////
/////////////////////////////
void(entity slot, entity weap) SetSlot;
float() use_autostuck =
{
	self.impulse = self.impulse - 50;	
	for(float i = 5; i < INVENTORY_SIZE; i++)
	{
		if(i == self.impulse) continue;
		if(self.slot[i].netname == self.slot[self.impulse].netname)
		{
			if(self.slot[i].amount < self.slot[i].amountMax)
			{
				if(self.slot[self.impulse].amount + self.slot[i].amount > self.slot[i].amountMax)
				{
					self.slot[self.impulse].amount = self.slot[self.impulse].amount - (self.slot[i].amountMax - self.slot[i].amount);
					self.slot[i].amount = self.slot[i].amountMax;
					SetSlot(self.slot[i], self.slot[i]);
					SetSlot(self.slot[self.impulse], self.slot[self.impulse]);
				}
				else 	
				{
					self.slot[i].amount = self.slot[i].amount + self.slot[self.impulse].amount;
					self.slot[self.impulse].amount = 0;
					SetSlot(self.slot[i], self.slot[i]);
					return TRUE;
				}
			}
		}
	}
	return FALSE;
};

float() use_medkit =
{
	if (!T_Heal(self, 25, FALSE)) return FALSE;
	sprint(self, "You receive 25 health\n");
	sound(self, CHAN_ITEM, "player/heal.wav", 1, ATTN_NORM);
	stuffcmd(self, "bf 0.1 0.8 0.8\n");
	return TRUE;
};

void() item_med =
{
	self.icon = "sprites/medkit";
	self.netname = "Medkit AI-2";
	precache_model("models/items/medkit.md3");
	setmodel(self, "models/items/medkit.md3");
	self.useitem = use_medkit;
}

void(entity slot) SetFunction =
{
	if(slot.netname == "Medkit AI-2") slot.useitem = use_medkit;

}




/////////////////////////////
///////// INV FUNCS /////////
/////////////////////////////


void(entity client, entity slot) save_slot =
{
	// if(strlen(slot.netname) < 1) return;
	print("Saving ", slot.netname, " to ", strcat(client.netname, ftos(slot.frame)), " at ", ftos(slot.frame), "\n");
	float f = fopen(strcat(client.netname, ftos(slot.frame)), FILE_WRITE);
	if(f >= 0)
	{
		fputs(f, slot.netname);
		fputs(f, "\n");
		fputs(f, slot.icon);
		fputs(f, "\n");
		fputs(f, slot.model);
		fputs(f, "\n");
		fputs(f, ftos(slot.weapon));
		fputs(f, "\n");
		fputs(f, ftos(slot.state));
		fputs(f, "\n");
		fputs(f, ftos(slot.currentClip));
		fputs(f, "\n");
		fputs(f, ftos(slot.amount));
		fputs(f, "\n");
		fputs(f, ftos(slot.amountMax));
		fclose(f);
	}
};

void(entity slot, entity weap) SetSlot =
{
	slot.weapon = weap.weapon;
	slot.currentClip = weap.currentClip;
	slot.model = weap.model;
	slot.netname = weap.netname;
	slot.icon = weap.icon;
	slot.useitem = weap.useitem;
	slot.amount = weap.amount;
	slot.amountMax = weap.amountMax;
	stuffcmd(slot.owner, strcat("slot", ftos(slot.frame), " ", ftos(weap.weapon), "\n"));
	stuffcmd(slot.owner, strcat("sloticon", ftos(slot.frame), " \"", weap.icon, "\"\n"));
	stuffcmd(slot.owner, strcat("slotdesc", ftos(slot.frame), " \"", weap.netname, "\"\n"));
	stuffcmd(slot.owner, strcat("slotamount", ftos(slot.frame), " ", ftos(slot.amount), "\n"));
	save_slot(slot.owner, slot);
};

void(entity slot) ClearSlot =
{
	slot.weapon = 0;
	slot.currentClip = 0;
	slot.model = "";
	slot.netname = "";
	slot.icon = "";
	slot.amount = 0;
	slot.amountMax = 0;
	stuffcmd(slot.owner, strcat("slot", ftos(slot.frame), " \"\"\n"));
	stuffcmd(slot.owner, strcat("sloticon", ftos(slot.frame), " \"\"\n"));
	stuffcmd(slot.owner, strcat("slotdesc", ftos(slot.frame), " \"\"\n"));
	save_slot(slot.owner, slot);
};

void(entity client, entity currentSlot) load_slot =
{
	float f = fopen(strcat(client.netname, ftos(currentSlot.frame)), FILE_READ);
	if(f >= 0)
	{
		currentSlot.netname = strzone(fgets(f));
		currentSlot.icon = strzone(fgets(f));
		currentSlot.model = strzone(fgets(f));
		currentSlot.weapon = (stof(fgets(f)));
		currentSlot.state = (stof(fgets(f)));
		currentSlot.currentClip = (stof(fgets(f)));
		currentSlot.amount = (stof(fgets(f)));
		currentSlot.amountMax = (stof(fgets(f)));
		
		SetFunction(currentSlot);
		if(strlen(currentSlot.netname))
		{
			print("ADDING ", currentSlot.netname , "\n");
		}
		fclose(f);
	}
};


void(string name) UpdateAmount =
{
	float ret = 0;
	for(float i = 5; i < INVENTORY_SIZE; i++)
	{
		if(strlen(self.slot[i].netname))
		{
			if(self.slot[i].netname == name)
			{
				SetSlot(self.slot[i], self.slot[i]);
			}
		}
	}

};








float(string name) CountAmmo =
{
	float ret = 0;
	for(float i = 5; i < INVENTORY_SIZE; i++)
	{
		if(strlen(self.slot[i].netname))
		{
			if(self.slot[i].netname == name)
			{
				ret = ret + self.slot[i].amount;
			}
		}
	}
	return ret;
};

float(string name, float amountToRemove) RemoveAmmo =
{
	float ret = 0;
	for(float i = 5; i < INVENTORY_SIZE; i++)
	{
		if(strlen(self.slot[i].netname))
		{
			if(self.slot[i].netname == name)
			{
				if(amountToRemove >= self.slot[i].amount)
				{
					amountToRemove = amountToRemove - self.slot[i].amount;
					ClearSlot(self.slot[i]);
				}
				else 
				{
					self.slot[i].amount = self.slot[i].amount - amountToRemove;
					amountToRemove = amountToRemove - self.slot[i].amount;
				}
			}
		}
		if(amountToRemove <= 0) break;
	}
	return ret;


};


void(entity client) CreateInventoryEntites =
{
	if(!client || client.classname != "player") return;	
	
	for(float i = 0; i < INVENTORY_SIZE; i++)
	{
		client.slot[i] = spawn();
		client.slot[i].owner = client;
		client.slot[i].frame = i;		
		load_slot(client, client.slot[i]);
		SetSlot(client.slot[i], client.slot[i]);
	}	
	
	client.slot[0].state = 1;
	client.slot[1].state = 2;
	client.slot[2].state = 3;
	client.slot[3].state = 3;
	
	client.slot[0].weapon = WP_KNIFE;
	client.slot[0].icon = "sprites/knife";
	client.slot[0].netname = "Knife";
	SetSlot(client.slot[0], client.slot[0]);
	
	client.slot[1].weapon = WP_PISTOL;
	client.slot[1].icon = "sprites/pm";
	client.slot[1].netname = "Makarov";
	SetSlot(client.slot[1], client.slot[1]);
	
	client.slot[2].weapon = WP_AK74;
	client.slot[2].icon = "sprites/ak74";
	client.slot[2].netname = "AK-74";
	SetSlot(client.slot[2], client.slot[2]);
	
	client.slot[3].weapon = WP_VAL;
	client.slot[3].icon = "sprites/val";
	client.slot[3].netname = "VAL";
	SetSlot(client.slot[3], client.slot[3]);

	client.slot[10].netname = "5.45x39 Ammo";
	client.slot[10].icon = "sprites/5.45x39";
	client.slot[10].amount = 60;
	client.slot[10].amountMax = 60;
	client.slot[10].model = "models/w_akammo.md3";
	SetSlot(client.slot[10], client.slot[10]);
	
	client.slot[11].netname = "9x39 Ammo";
	client.slot[11].icon = "sprites/ammo";
	client.slot[11].amount = 90;
	client.slot[11].amountMax = 60;
	client.slot[11].model = "models/w_akammo.md3";
	SetSlot(client.slot[11], client.slot[11]);
};



void() loot_touch =
{
	if(other.classname == "useprefab") other = other.owner;
	if(other.classname != "player") return; 
	if(!other.slot[0]) CreateInventoryEntites(other);
	if(self.weapon && other.slot[1].weapon && other.slot[2].weapon && other.slot[3].weapon && other.slot[4].weapon) return;
	
	if(!self.state)
	{
		if(self.amountMax > 0)
		{
			for(float i = 5; i < INVENTORY_SIZE; i++)
			{
				if(other.slot[i].netname == self.netname)
				{
					if(other.slot[i].amount < other.slot[i].amountMax)
					{
						if(self.amount + other.slot[i].amount > other.slot[i].amountMax)
						{
							self.amount = self.amount - (other.slot[i].amountMax - other.slot[i].amount);
							other.slot[i].amount = other.slot[i].amountMax;
							SetSlot(other.slot[i], other.slot[i]);
						}
						else 	
						{
							other.slot[i].amount = other.slot[i].amount + self.amount;
							self.amount = 0;
							SetSlot(other.slot[i], other.slot[i]);
							sound(other, CHAN_ITEM, "player/pickup.wav", 1, ATTN_NORM);
							stuffcmd(other, "bf\n");
							remove(self);
							return;
						}
					}
					print("Finish slot: ", ftos(i), " ", other.slot[i].amount, "\n");
				}
			}
		}
		
		for(float i = 5; i < INVENTORY_SIZE; i++)
		{
			if(strlen(other.slot[i].netname) <= 0)
			{
				sound(other, CHAN_ITEM, "player/pickup.wav", 1, ATTN_NORM);
				stuffcmd(other, "bf\n");
				SetSlot(other.slot[i], self);
				remove(self);
				break;
			}
		}
		UpdateAmount(self.netname);
	}
	else
	{
		if(!other.slot[1].weapon && self.state == other.slot[1].state)
		{
			SetSlot(other.slot[1], self);
			other.impulse = 2;
		}
		else if(!other.slot[2].weapon && self.state == other.slot[2].state)
		{
			SetSlot(other.slot[2], self);
			other.impulse = 3;
		}
		else if(!other.slot[3].weapon && self.state == other.slot[3].state)
		{
			SetSlot(other.slot[3], self);
			other.impulse = 4;
		}
		sound(other, CHAN_ITEM, "player/pickup.wav", 1, ATTN_NORM);
		stuffcmd(other, "bf\n");
		remove(self);
	}
	// if(self.weapon == WP_SHOT || self.weapon == WP_ASHOT) other.ammoShells = other.ammoShells + self.currentammo;
	// else if(self.weapon == WP_MP5) other.ammo9x19 = other.ammo9x19 + self.currentammo;
	// else if(self.weapon == WP_AK74 || self.weapon == WP_AKSU) other.ammo545x39 = other.ammo545x39 + self.currentammo;
	// else if(self.weapon == WP_VAL || self.weapon == WP_VSS) other.ammo9x39 = other.ammo9x39 + self.currentammo;
	// else if(self.weapon == WP_SVD) other.ammo762x54 = other.ammo762x54 + self.currentammo;
	// else other.ammoRifle = other.ammoRifle + self.currentammo;
};



void(entity weap) SetWorldModel =
{
	if(weap.weapon == WP_AK74) 
	{
		setmodel(weap, AK74_WORLD_MODEL);
		weap.icon = "sprites/ak74";
		weap.netname = "AK-74";
		weap.state = 3;
	}
	else if(weap.weapon == WP_PISTOL) 
	{
		setmodel(weap, PM_WORLD_MODEL);
		weap.icon = "sprites/pm";
		weap.netname = "Makarov";
		weap.state = 2;
	}
	else if(weap.weapon == WP_SHOT) 
	{
		setmodel(weap, SHOTGUN_WORLD_MODEL);
		weap.icon = "sprites/ks23";
		weap.netname = "KS-23 Shotgun";
		weap.state = 3;
	}
	else if(weap.weapon == WP_VAL) 
	{
		setmodel(weap, VAL_WORLD_MODEL);
		weap.icon = "sprites/ak74";
		weap.netname = "AS Val";
		weap.state = 3;
	}
	return;	
};



void() info_loot =
{
	self.touch = loot_touch;
	self.solid = SOLID_TRIGGER;
	self.avelocity = '0 0 0';
	// StartItem();
	

	if(self.weapon)
	{
		SetWorldModel(self);
	}
	else if(!strlen(self.netname))
	{
		
		item_med();
	}
	setsize(self, '-8 -8 0', '8 8 8');
};


void() DropWeapon =
{
	if(self.weapon == WP_KNIFE || self.weapon == WP_GRENADE) return;
	
	local entity missile;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_TRIGGER;
	missile.classname = "weapon";
	makevectors (self.v_angle);
	missile.velocity = v_forward * random(100, 150);
	missile.avelocity = [0, random(100, 300), 0];
	missile.currentammo = 0;
	missile.currentClip = self.currentClip;
	missile.weapon = self.weapon;
	missile.nextthink = time + 0.5;
	missile.think = info_loot;
	setorigin(missile, self.origin + v_up * 20);
	SetWorldModel(missile);
	setsize(missile, '-1 -1 -1', '1 1 1');
	
	CycleWeaponReverseCommand();
	if(self.slot[1].weapon == missile.weapon) ClearSlot(self.slot[1]);
	else if(self.slot[2].weapon == missile.weapon) ClearSlot(self.slot[2]);
	else if(self.slot[3].weapon == missile.weapon) ClearSlot(self.slot[3]);
	self.impulse = 0;
};

void(float num) DropItem =
{
	num = num - 20;
	if(num <= 0) return;
	if(!self.slot[num] || !strlen(self.slot[num].netname)) 
	{
		print("No item ", self.slot[num].netname, " " , self.slot[num].icon, "\n");
		for(float i = 0; i < INVENTORY_SIZE; i++)
		{
			print(self.slot[i].netname, " " , self.slot[i].icon, "\n");
		}	
		return;
	}

	local entity missile;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_TRIGGER;
	missile.classname = "item";
	makevectors (self.v_angle);
	missile.velocity = v_forward * 120;

	missile.avelocity = [0, random(100, 300), 0];
	setmodel(missile, self.slot[num].model);
	setorigin(missile, self.origin + v_up * 20);
	setsize(missile, '-1 -1 -1', '1 1 1');
	
	missile.netname = self.slot[num].netname;
	missile.icon = self.slot[num].icon;
	missile.state = self.slot[num].state;
	missile.useitem = self.slot[num].useitem;
	missile.amount = self.slot[num].amount;
	missile.amountMax = self.slot[num].amountMax;
	
	missile.nextthink = time + 0.5;
	missile.think = info_loot;
	if(self.slot[num].weapon)
	{
		missile.currentClip = self.slot[num].currentClip;
		missile.currentammo = 0;
		missile.weapon = self.slot[num].weapon; 
		self.weapon = self.slot[num].weapon;
		CycleWeaponReverseCommand();
	}
	
	ClearSlot(self.slot[num]);
};

void(float num) UseItem =
{
	num = num - 50;
	if(num <= 0) return;
	if(num >= 1 && num <= 4 && self.slot[num].weapon) 
	{
		self.weapon = self.slot[num].weapon;
		DropItem(num);
		return;
	}
	if(self.slot[num].useitem)
	{
		if(self.slot[num].useitem())
		{
			ClearSlot(self.slot[num]);
		}
	}
	else 
	{
		if(use_autostuck()) ClearSlot(self.slot[num]);
	}	
};


void() InventoryImpulseCommands =
{
	if (self.impulse == 13) DropWeapon();
	if(self.impulse >= 20 && self.impulse < 50)
	{
		DropItem(self.impulse);
		self.impulse = 0;
	}
	if(self.impulse >= 50 && self.impulse < 80)
	{
		UseItem(self.impulse);
		self.impulse = 0;
	}

};

/*

void() CycleWeaponCommand =
{
	self.impulse = 0;
	float currentImpulse = 0;
	if(self.weapon == self.slot[0].weapon) currentImpulse = 1;
	if(self.weapon == self.slot[1].weapon) currentImpulse = 2;
	if(self.weapon == self.slot[2].weapon) currentImpulse = 3;
	if(self.weapon == self.slot[3].weapon) currentImpulse = 4;
	if(self.weapon == self.slot[4].weapon) currentImpulse = 5;
	
	if(currentImpulse)
	{
		for(float i = 0; i < 5; i++)
		{
			currentImpulse = currentImpulse - 1;
			if(currentImpulse < 1) currentImpulse = 5;
			
			if(currentImpulse == 1 && self.slot[0].weapon) { self.weapon = self.slot[0].weapon; break;}
			if(currentImpulse == 2 && self.slot[1].weapon) { self.weapon = self.slot[1].weapon; break;}
			if(currentImpulse == 3 && self.slot[2].weapon) { self.weapon = self.slot[2].weapon; break;}
			if(currentImpulse == 4 && self.slot[3].weapon) { self.weapon = self.slot[3].weapon; break;}
			if(currentImpulse == 5 && self.slot[4].weapon) { self.weapon = self.slot[4].weapon; break;}
			
		}
		sound(self, CHAN_AUTO, "player/switch.wav", random(0.3, 0.8), SoundRadius(400));
		self.selected = currentImpulse - 1;
		W_SetCurrentAmmo();
		if(self.weaponSwitch) self.weaponSwitch();
	}
};


void() CycleWeaponReverseCommand =
{
	self.impulse = 0;
	float currentImpulse = 0;
	if(self.weapon == self.slot[0].weapon) currentImpulse = 1;
	if(self.weapon == self.slot[1].weapon) currentImpulse = 2;
	if(self.weapon == self.slot[2].weapon) currentImpulse = 3;
	if(self.weapon == self.slot[3].weapon) currentImpulse = 4;
	if(self.weapon == self.slot[4].weapon) currentImpulse = 5;
	
	if(currentImpulse)
	{
		for(float i = 0; i < 5; i++)
		{
			currentImpulse = currentImpulse + 1;
			if(currentImpulse > 5) currentImpulse = 1;
			if(currentImpulse == 1 && self.slot[0].weapon) { self.weapon = self.slot[0].weapon; break;}
			if(currentImpulse == 2 && self.slot[1].weapon) { self.weapon = self.slot[1].weapon; break;}
			if(currentImpulse == 3 && self.slot[2].weapon) { self.weapon = self.slot[2].weapon; break;}
			if(currentImpulse == 4 && self.slot[3].weapon) { self.weapon = self.slot[3].weapon; break;}
			if(currentImpulse == 5 && self.slot[4].weapon) { self.weapon = self.slot[4].weapon; break;}
			
		}
		sound(self, CHAN_AUTO, "player/switch.wav", random(0.3, 0.8), SoundRadius(400));
		self.selected = currentImpulse - 1;
		W_SetCurrentAmmo();
		if(self.weaponSwitch) self.weaponSwitch();
	}
};
void() W_ChangeWeapon =
{
	if(self.impulse == self.selected + 1) return;
	if(self.impulse == 1 && self.slot[0].weapon) self.weapon = self.slot[0].weapon;
	else if(self.impulse == 2 && self.slot[1].weapon) self.weapon = self.slot[1].weapon;
	else if(self.impulse == 3 && self.slot[2].weapon) self.weapon = self.slot[2].weapon;
	else if(self.impulse == 4 && self.slot[3].weapon) self.weapon = self.slot[3].weapon;
	else if(self.impulse == 5 && self.slot[4].weapon) self.weapon = self.slot[4].weapon;
	else return;
	
	self.selected = self.impulse - 1;
	W_SetCurrentAmmo();
	sound(self, CHAN_AUTO, "player/switch.wav", random(0.3, 0.8), SoundRadius(400));
	if(self.weaponSwitch) self.weaponSwitch();
	self.impulse = 0;
}



// float(string type) CountAmmo;
// float(string type, float amount) RemoveAmmo;
// void(string type) UpdateAmount;
// void(string ammoType, float clipSize) FinishReload =
// {
	// self.weaponframe = 0;
	// if(CountAmmo(ammoType) >= clipSize)
	// {
		// RemoveAmmo(ammoType, (clipSize - self.slot[self.selected].currentClip));
		// if(self.slot[self.selected].currentClip > 0) self.slot[self.selected].currentClip = 1;
		// else self.slot[self.selected].currentClip = 0;
		// self.slot[self.selected].currentClip = self.slot[self.selected].currentClip + clipSize;
		// self.currentClip = self.slot[self.selected].currentClip;
	// }
	// else
	// {
		// if(self.slot[self.selected].currentClip > 0) self.slot[self.selected].currentClip = 1;
		// else self.slot[self.selected].currentClip = 0;
		// self.slot[self.selected].currentClip = CountAmmo(ammoType);
		// self.currentClip = self.slot[self.selected].currentClip;
		// RemoveAmmo(ammoType, 999);
	// }
	// UpdateAmount(ammoType);
	// W_SetCurrentAmmo();
	// self.think = player_run;

// };



*/