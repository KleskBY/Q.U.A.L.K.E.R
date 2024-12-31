float KNIFE_DAMAGE = 16;
float KNIFE_RATE = 0.55;
float KNIFE_SEMI = 0;
float KNIFE_DISTANCE = 75;

float KNIFE_DRAW_START_FRAME = 1;
float KNIFE_DRAW_END_FRAME = 14;
float KNIFE_ATTACK_START_FRAME = 15;
float KNIFE_ATTACK_END_FRAME = 29;
float KNIFE_FRAMERATE = 0.03;

string KNIFE_VIEW_MODEL = "models/weapons/v_knife.md3";
string KNIFE_PLAYER_MODEL = "models/player.md3";
string KNIFE_WORLD_MODEL = "models/weapons/w_knife.md3";

string KNIFE_FIRE_SOUND = "weapons/knife/hit.wav";
string KNIFE_WHOOSH1_SOUND = "weapons/knife/whoosh1.wav";
string KNIFE_WHOOSH2_SOUND = "weapons/knife/whoosh2.wav";
string KNIFE_MISS_SOUND = "weapons/knife/miss.wav";

//////////////////////////// FIRE ///////////////////////////////

void() KNIFE_Fire = 
{
	local entity head;
	local vector org;
	local float damage = KNIFE_DAMAGE;
	
	local vector meatdir;
	makevectors (self.v_angle);
	meatdir_x = (random() * 300);
	meatdir_y = (random() * 300);
	meatdir_z = (random() * 300);

	if(deathmatch)
	{
		head = findradius(self.origin, KNIFE_DISTANCE);
		while (head)
		{
			if (head != self && head.takedamage)
			{
				if (CanDamage (head, self) && IsVisible(head) && InFront(head.origin))
				{	
					if (head.flags & FL_MONSTER || head.classname == "player" || head.classname == "bot")
					{
						T_Damage (head, self, self, damage);
						Shoot_Blood (org,meatdir);
						Shoot_Blood (org,meatdir * 2);
						damage = 1;
						break;
					}
				}
			}
			head = head.chain;
		}
	}
	fireBullet('0.2 0.0 0', KNIFE_DISTANCE, damage);
};



////////////////////////// ATTACK //////////////////////////////

void() KNIFE_Attack2
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + KNIFE_FRAMERATE;
	if(self.weaponframe >= 20 && self.weaponframe < 25)
	{
	   if(self.weaponframe == 20) 
	   {
		   self.frame = 3;
		   if(random()) sound(self, CHAN_WEAPON, KNIFE_WHOOSH1_SOUND, 0.5, SoundRadius(400));
		   else sound(self, CHAN_WEAPON, KNIFE_WHOOSH2_SOUND, 0.5, SoundRadius(400));
	   }
	   KNIFE_Fire();
	}
	if(self.weaponframe >= KNIFE_ATTACK_END_FRAME) self.think = PlayerThink;
}

void() KNIFE_Attack
{
	self.attack_finished = time + KNIFE_RATE;
	self.nextthink = time + KNIFE_FRAMERATE;
	
	self.weaponframe = KNIFE_ATTACK_START_FRAME;
	self.think = KNIFE_Attack2;
}

///////////////// WEAPON CHANGE ///////////////////

void() KNIFE_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + KNIFE_FRAMERATE;
	if(self.weaponframe >= KNIFE_DRAW_END_FRAME)
	{
		self.think = PlayerThink;
		self.reload = 0;
	}
};

void() KNIFE_Switch
{
	self.weaponframe = KNIFE_DRAW_START_FRAME;
	self.nextthink = time + KNIFE_FRAMERATE;
	self.think = KNIFE_Switch2;
	self.reload = 1;
};

/////////////////////// SELECT //////////////////////

void() KNIFE_Select =
{
	self.weaponframe = 0;
	self.weaponmodel = KNIFE_VIEW_MODEL;
	setmodel(self, KNIFE_PLAYER_MODEL);
	self.weaponSwitch = KNIFE_Switch;
	self.weaponAttack = KNIFE_Attack;
	self.weaponReload = SUB_Null;
	self.weaponSelect = KNIFE_Select;
	SetGun(KNIFE_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() KNIFE_Precache =
{
	precache_model(KNIFE_VIEW_MODEL);
	precache_model(KNIFE_PLAYER_MODEL);
	precache_model(KNIFE_WORLD_MODEL);
	precache_sound(KNIFE_FIRE_SOUND);
	precache_sound(KNIFE_WHOOSH1_SOUND);
	precache_sound(KNIFE_WHOOSH2_SOUND);
	precache_sound(KNIFE_MISS_SOUND);
};


