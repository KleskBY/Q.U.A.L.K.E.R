float BOLT_DAMAGE = 1;
float BOLT_RATE = 0.85;
float BOLT_SEMI = 1;
float BOLT_DISTANCE = 1024;


float BOLT_RELOAD_START_FRAME = 68;
float BOLT_RELOAD_END_FRAME = 68;
float BOLT_DRAW_START_FRAME = 1;
float BOLT_DRAW_END_FRAME = 30;
float BOLT_ATTACK_START_FRAME = 31;
float BOLT_ATTACK_END_FRAME = 40;
float BOLT_FRAMERATE = 0.03;

string BOLT_VIEW_MODEL = "models/weapons/v_bolt.md3";
string BOLT_WORLD_MODEL = "models/weapons/w_bolt.md3";
string BOLT_PLAYER_MODEL = "models/player.md3";
string BOLT_FIRE_SOUND = "weapons/grenade/explosion.wav";
string BOLT_PIN_SOUND = "weapons/grenade/pinpull.wav";
string BOLT_HIT_SOUND = "weapons/grenade/hit.wav";


//////////////////////////// FIRE ///////////////////////////////

void() BOLT_Touch =
{
	if (other == self.owner) return;		// don't explode on owner
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, BOLT_DAMAGE);
	}
	sound (self, CHAN_WEAPON, BOLT_HIT_SOUND, 1, ATTN_NORM);
	if (self.velocity == '0 0 0') self.avelocity = '0 0 0';
};

void() BOLT_Fire = 
{
	self.punchangle_x = -2;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.bouncefactor = 0.5;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "bolt";
	makevectors (self.v_angle);
	if (self.v_angle_x) newmis.velocity = v_forward * (25 * self.grenadetime) + v_up * 100 + (2*(random() - 0.5)) * v_right*10 + (2*(random() - 0.5)) *v_up*30;
	else
	{
		newmis.velocity = aim(self, 10000);
        newmis.velocity = newmis.velocity * 20 * self.grenadetime;
		newmis.velocity_z = 30;
	}
	newmis.avelocity = '300 300 300';
	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = BOLT_Touch;
	newmis.search_time = time + 3.0;
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 25;
    setmodel (newmis, BOLT_WORLD_MODEL);
	setsize (newmis, '0 0 0', '1 1 1');
	setorigin (newmis, self.origin - (v_right * -6) + (v_up * 11));
	newmis.scale = 1.5;
	self.grenadetime = 0;
};


////////////////////////// ATTACK //////////////////////////////

void() BOLT_Attack4
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + BOLT_FRAMERATE;
	if (self.weaponframe == 44) BOLT_Fire();
	if (self.weaponframe >= BOLT_RELOAD_END_FRAME) self.weaponframe = BOLT_DRAW_START_FRAME; //self.think = PlayerThink;
	if (self.weaponframe >= BOLT_DRAW_END_FRAME && self.weaponframe <= BOLT_ATTACK_END_FRAME) self.think = PlayerThink;
}

void() BOLT_Attack3 //charge (hold)
{
	self.nextthink = time + BOLT_FRAMERATE;
	self.attack_finished = time + BOLT_FRAMERATE;
	if (self.button0)
	{
		if (self.grenadetime <= 40)
		{
			self.grenadetime = self.grenadetime + BOLT_FRAMERATE * 15; 
			local string temp;
			local float power;
			power = ((self.grenadetime-10) / 30) *100;
			temp = ftos(power);
			temp = substring(temp,0,strstrofs(temp, ".", 0));
			temp = strcat(temp, "%");
			centerprint (self, temp);
		}
	}
	else self.think = BOLT_Attack4;
}

void() BOLT_Attack2 //pin pull
{
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + BOLT_FRAMERATE;
	if (self.weaponframe >= BOLT_ATTACK_END_FRAME) self.think = BOLT_Attack3;
}

void() BOLT_Attack
{
	if(BOLT_SEMI && self.ShootsFired != 0) return;
	self.grenadetime = 10;
	self.attack_finished = time + BOLT_RATE;
	self.weaponframe = BOLT_ATTACK_START_FRAME;
	self.nextthink = time + BOLT_FRAMERATE;
	self.think = BOLT_Attack2;
	self.ShootsFired = self.ShootsFired + 1;
}

///////////////// WEAPON CHANGE ///////////////////

void() BOLT_Switch2
{	
	self.weaponframe = self.weaponframe + 1;
	self.nextthink = time + BOLT_FRAMERATE;
	if(self.weaponframe >= BOLT_DRAW_END_FRAME)
	{
		self.think = PlayerThink;
		self.reload = 0;
	}
};

void() BOLT_Switch
{
	self.weaponframe = BOLT_DRAW_START_FRAME;
	self.nextthink = time + BOLT_FRAMERATE;
	self.think = BOLT_Switch2;
	self.reload = 1;
};

/////////////////////// SELECT //////////////////////

void() BOLT_Select =
{
	self.weaponframe = 0;
	self.weaponmodel = BOLT_VIEW_MODEL;
	setmodel(self, BOLT_PLAYER_MODEL);
	self.weaponSwitch = BOLT_Switch;
	self.weaponAttack = BOLT_Attack;
	self.weaponReload = SUB_Null;
	self.weaponSelect = BOLT_Select;
	SetGun(BOLT_WORLD_MODEL);
}

//////////////// PRECACHE //////////////////////////

void() BOLT_Precache =
{
	precache_model(BOLT_VIEW_MODEL);
	precache_model(BOLT_PLAYER_MODEL);
	precache_model(BOLT_WORLD_MODEL);
	precache_sound(BOLT_FIRE_SOUND);
	precache_sound(BOLT_PIN_SOUND);
	precache_sound(BOLT_HIT_SOUND);
};


