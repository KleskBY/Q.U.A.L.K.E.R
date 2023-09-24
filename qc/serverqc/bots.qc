string() RandomName 
{
	local float rand;
	local string name;
	rand = rint(random() * 45);	
	switch(rand)
	{
		case 1:
			name = "Klesk";
			break;
		case 2:
			name = "NiceL";
			break;
		case 3:
			name = "Snow";
			break;
		case 4:
			name = "Sown";
			break;
		case 5:
			name = "Volot";
			break;
		case 6:
			name = "Cringe";
			break;
		case 7:
			name = "CatHunter42";
			break;
		case 8:
			name = "DarkLord";
			break;
		case 9:
			name = "Killer228";
			break;
		case 10:
			name = "Sige";
			break;
		case 11:
			name = "007";
			break;
		case 12:
			name = "Over";
			break;
		case 13:
			name = "8=====D";
			break;
		case 14:
			name = "LordHavoc";
			break;
		case 15:
			name = "LadyHavoc";
			break;
		case 16:
			name = "Vinylka";
			break;
		case 17:
			name = "Nya";
			break;
		case 18:
			name = "Noir";
			break;
		case 19:
			name = "Oxxxy";
			break;
		case 20:
			name = "BadBoy";
			break;
		case 21:
			name = "Crystal";
			break;
		case 22:
			name = "Prince";
			break;
		case 23:
			name = "CobraBuster";
			break;
		case 24:
			name = "ArmyBoots";
			break;
		case 25:
			name = "GasGun";
			break;
		case 26:
			name = "Yank";
			break;
		case 27:
			name = "Xaero";
			break;
		case 28:
			name = "Ranger";
			break;
		case 29:
			name = "Crash";
			break;
		case 30:
			name = "Orb";
			break;
		case 31:
			name = "Splash";
			break;
		case 32:
			name = "dumptruck";
			break;
		case 33:
			name = "PigEater";
			break;
		case 34:
			name = "JaJa";
			break;	
		case 35:
			name = "doomguy";
			break;
		case 36:
			name = "Ideal";
			break;
		case 37:
			name = "Clash";
			break;
		case 38:
			name = "Imperor";
			break;
		case 39:
			name = "Kowalski";
			break;
		case 40:
			name = "PodBot";
			break;
		case 41:
			name = "IamNotABot";
			break;
		case 42:
			name = "PlsHelpMe";
			break;
		case 43:
			name = "MyToothHurt";
			break;
		case 44:
			name = "NotEvil";
			break;

		default:
			name = "Wall-E";
			break;
			
	}
	return name;
}

///////////////////////////////
///////// INIT ////////////////
///////////////////////////////

void() PickClass =
{
	local float rand;
	rand = rint(random() * 7);	
	if(rand == 1 || rand == 2) self.impulse = 20;
	else if(rand == 3) self.impulse = 21;
	else if(rand == 4) self.impulse = 22;
	else if(rand == 5) self.impulse = 25;
	else if(rand == 6) self.impulse = 26;
	else if(rand == 7) self.impulse = 27;
	self.lastTouch = time;
}

void() SpawnBot =
{	
	local entity oldself;
	oldself = self;
	self = spawnclient();
	if (!self)
	{
		bprint("Can not add bot, server is full.\n");
		self = oldself;
		return;
	}
	self.netname = RandomName();
	ClientConnect();
	PutClientInServer();
	PickClass();

	self = oldself;
}
void() KickBot =
{
	self.impulse = 0;
	if(!deathmatch) return;
	local entity head;
	head = find(world, classname, "player");
	while (head)
	{
		if (clienttype(head) == CLIENTTYPE_BOT) dropclient(head);
		head = find(head, classname, "player");
	}
	head = find(world, classname, "observer");
	while (head)
	{
		if (clienttype(head) == CLIENTTYPE_BOT) dropclient(head);
		head = find(head, classname, "observer");
	}
}

void() walkbot_think =
{
	if(vlen(self.owner.origin - self.origin) > 175)
	{
		setorigin(self, self.owner.origin);
	}
	else if(vlen(self.owner.origin - self.origin) < 50)
	{
		movetogoal(25); 
	}
	else 
	{
		movetogoal(20); 
	}
	self.nextthink = time + 0.1;
}


//////////////////////////////////
/////////// THINK ////////////////
//////////////////////////////////

void() BotPreThink =
{
	// self.effects = EF_NODEPTHTEST; //WALLHACK FOR DEBUG
	if (intermission_running) return;	
	if (self.classname == "observer" && self.lastTouch + 1 < time) PickClass();
	SelectClass(); //fix
	
	makevectors(self.v_angle);		// is this still used
	CheckRules();
	WaterMove();
	
	if(cvar("bot_stop")) return;
	
	if (self.waterlevel == 2) CheckWaterJump();
	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink();
		return;
	}
	if (self.deadflag == DEAD_DYING) return;
	if (self.flags & FL_ONGROUND) self.flags = self.flags - (self.flags & FL_LADDERJUMP);
	if (time < self.pausetime) self.velocity = '0 0 0';
	
	local entity e, nearest;
	for (e = findchain(classname, "player"); e; e = e.chain) 
	{
		if(cvar("teamplay") > 0 && e.team == self.team) continue;
		if(e != self && e.deadflag != DEAD_DEAD && e.deadflag != DEAD_DYING && e.deadflag != DEAD_RESPAWNABLE)
		{
			if (!nearest || !visible(nearest)) nearest = e;
			if(visible(e))
			{
				if (!nearest) nearest = e;
				else if(vlen(e.origin - self.origin) < vlen(nearest.origin - self.origin)) nearest = e;
			}
		}
	}	
	if(self.currentClip <= 0) self.impulse = 100;
	else if(!visible(nearest))
	{
		if(self.weapon == WP_PISTOL || self.weapon == WP_SHOT || self.weapon == WP_SNIPER)
		{
			if(self.currentClip < 4) self.impulse = 100;
		}
		else if(self.currentClip < 7) self.impulse = 100;
	}
	
//MOVEMENT
	local float gravity = self.velocity_z;
	if(nearest && visible(nearest))  //if seeing enemy or cant find waypoint
	{
		if(!self.currentClip && !self.currentammo) self.impulse = 2;
		if(!self.hook) self.attack_state = time + 2;
		self.hook = nearest; //remember enemy
		self.search_time = time + 5; //remember for 5 seconds;
		
	
		
		// local vector dir = normalize((nearest.origin + nearest.view_ofs * 0.5) - (self.origin + self.view_ofs * 0.5)); //nearest.origin - self.origin;
		// local vector newangle = vectoangles(dir);//vectoyaw(dir);
		// newangle_x = -newangle_x;
		// local vector change = newangle - self.v_angle;
		// change = ClampAngle(change);
		// local float diff = fabs(change_y);
		// if (change_y < -aim_smooth) change_y = -aim_smooth;
		// if (change_y > aim_smooth) change_y = aim_smooth;
		// if (change_x < -aim_smooth_y) change_x = -aim_smooth_y;
		// if (change_x > aim_smooth_y) change_x = aim_smooth_y;
		// self.v_angle_y  = self.v_angle_y + change_y;
		// self.v_angle_x  = newangle_x; //self.v_angle_x + change_x; //-newangle_x; 
		
		
		local vector dir2 = normalize((nearest.origin + nearest.view_ofs * 0.5) - (self.origin + self.view_ofs * 0.5)); //nearest.origin - self.origin;
		local vector newangle2 = vectoangles(dir2);//vectoyaw(dir);
		local vector dir = normalize((self.origin + self.view_ofs * 0.5) - (nearest.origin + nearest.view_ofs * 0.5));
		local vector newAngle = vectoangles(dir);
		newAngle_y = newangle2_y;//newAngle_y + 180;
		if(random() > 0.825) newAngle = newAngle - self.punchangle; //no recoil

		local vector change = newAngle - self.v_angle;
		change = NormalizeAngle(change);
		change = ClampAngle(change);
		local float diff = fabs(change_y);
	
		local float aim_smooth = 1.25;
		local float aim_smooth_y = 1;
		if (change_y < -aim_smooth) change_y = -aim_smooth;
		if (change_y > aim_smooth) change_y = aim_smooth;
		if (change_x < -aim_smooth_y) change_x = -aim_smooth_y;
		if (change_x > aim_smooth_y) change_x = aim_smooth_y;
		self.v_angle_y  = self.v_angle_y + change_y;
		self.v_angle_x  = self.v_angle_x + change_x; //self.v_angle_x + change_x; //-newangle_x; 
		
				
		if(self.weapon == WP_KNIFE)
		{
			makevectors(self.angles);
			self.velocity = self.velocity + v_forward * 13;
			if (time > self.attack_finished) W_Attack();
		}
		else if(self.currentClip > 0 && diff < 30 /*infront(nearest)*/ && visible(nearest)) 
		{
			if (random() <= 0.01) PlayerJump();
			if (random() <= 0.02 && self.velocity_z < 5) self.lefty = !self.lefty; //randomly change strafe direction
			makevectors(self.angles);

			if(self.attack_state > time) //going forward for a bit
			{
				self.velocity = self.velocity + v_forward * 12;
			}
			else
			{
				if(self.lefty) self.velocity = self.velocity + v_right * 12; //strafe right
				else self.velocity = self.velocity - v_right * 12;
			}
			
			if(self.weapon == WP_PISTOL || self.weapon == WP_SNIPER)
			{
				if (time > self.attack_finished + random(0.25, 1.25)) W_Attack();
			}
			else if (time > self.attack_finished) W_Attack();
		}
		else //Going enemy direction
		{
			if(self.currentClip < 7) self.impulse = 100;
			dir_z = 0;
			// self.velocity = self.velocity + v_forward * 12; 
			self.velocity = dir * 250;
		}		
	}
	else if(self.hook && self.search_time > time)
	{
		if(!allive(self.hook)) self.hook = world;
		self.angles_z = 0;
		self.goalentity = nearest;
		movetogoal(2);
		self.v_angle_y = self.ideal_yaw;
		self.angles_y = self.ideal_yaw;
		makevectors(self.angles);
		self.velocity = v_forward * 25;
	}
	else
	{
		self.hook = world;
		self.angles_z = 0;
		self.goalentity = nearest;
		movetogoal(2);
		self.v_angle_y = self.ideal_yaw;
		self.angles_y = self.ideal_yaw;
		makevectors(self.angles);
		self.velocity = v_forward * 25;
	}
	
	if(self.velocity_x > 250) self.velocity_x = 250;
	if(self.velocity_x < -250) self.velocity_x = -250;
	if(self.velocity_y > 250) self.velocity_y = 250;
	if(self.velocity_y < -250) self.velocity_y = -250;
	self.velocity_z = gravity;
}







///////////////////////////
///////// TRASH ///////////
///////////////////////////


		//GOOD aim
		// local vector dir = normalize((nearest.origin + nearest.view_ofs * 0.5) - (self.origin + self.view_ofs * 0.5)); //nearest.origin - self.origin;
		// local vector newangle = vectoangles(dir);//vectoyaw(dir);
		// newangle_x = -newangle_x;
		// local vector change = newangle - self.v_angle;
		// change = ClampAngle(change);
		// local float diff = fabs(change_y);
		// if (change_y < -aim_smooth) change_y = -aim_smooth;
		// if (change_y > aim_smooth) change_y = aim_smooth;
		// if (change_x < -aim_smooth_y) change_x = -aim_smooth_y;
		// if (change_x > aim_smooth_y) change_x = aim_smooth_y;
		// self.v_angle_y  = self.v_angle_y + change_y;
		// self.v_angle_x  = newangle_x; //self.v_angle_x + change_x; //-newangle_x; 

		// // Trash aim
		// dir = normalize((self.origin + self.view_ofs * 0.5) - (nearest.origin + nearest.view_ofs * 0.5));
		// newAngle = vectoangles(dir);
		// newAngle_y = newAngle_y + 180;
		// newAngle = NormalizeAngle(newAngle);
		// newAngle = ClampAngle(newAngle);
		// local float diff = fabs(newAngle_y - self.v_angle_y);
		// newAngle = newAngle - self.v_angle;
		
		// self.v_angle_x =  self.v_angle_x + (newAngle_x / 14);
		// self.v_angle_y = self.v_angle_y + (newAngle_y / 14);
		// self.angles_y = vectoyaw(nearest.origin - self.origin);



		// // horizontal allighn
		// vector dir = nearest.origin - self.origin;
		// local vector newangle = vectoyaw(dir);
		// float change = newangle_y - self.v_angle_y;
		// while (change > 180) change = change - 360;
		// while (change < -180) change = change + 360;
		// if (change < -aim_smooth) change = -aim_smooth;
		// if (change > aim_smooth) change = aim_smooth;
		// newangle_y = self.v_angle_y + change;
		// self.v_angle = newangle;



	


/*
	// else
	// {
		// if(!self.walkbot)
		// {
			// entity oldself = self;
			
			// self = spawn();
			// bprint("spawning shit\n");
			// self.solid = SOLID_NOT;
			// self.movetype = MOVETYPE_STEP;
			// self.effects = EF_NODEPTHTEST; //WALLHACK FOR DEBUG
			// setmodel(self, "models/players/runner.md3");
			// setsize (self, '-9 -9 -24', '9 9 34');
			// setorigin(self, oldself.origin + '5 0 0');
			// walkmonster_start ();
			// self.goalentity = oldself;
			// self.owner = oldself;
			// self.think = walkbot_think;
			// self.nextthink = time + 0.1;
		
			// oldself.walkbot = self;
			// self = oldself;
		// }
		// self.walkbot.goalentity = nearest;
		// self.ideal_yaw = vectoyaw(self.walkbot.origin - self.origin);
		// self.v_angle_y = self.ideal_yaw;
		// ChangeYaw();
		// self.velocity = self.velocity + v_forward * 13;
	// }
else
{
	local entity Waypoint;
	if(self.hook)
	{
		if(self.hook.deadflag != DEAD_NO) self.timer = 0;
		else if(self.timer > time) Waypoint = self.hook;//going for invisible target in memory
	}
	if(!Waypoint)	//no target, parsing waypoints
	{
		for (e = findchain(classname, "waypoint"); e; e = e.chain) 
		{
			if(e != Waypoint && e.origin != self.pos1 && e.origin != self.pos2 && e.origin != self.pos3 && e.origin != self.pos4 && e.origin != self.pos5 && visible(e))
			{
				if(vlen(e.origin - self.origin) < vlen(Waypoint.origin - self.origin)) 
				{
					Waypoint = e;
				}
			}
		}
	}
	if(!Waypoint) Waypoint = nearest;//Waypoint = find(world, classname, "player"); //no waypoints, going for random player
	if(Waypoint)
	{
		EdgeDetect();
		self.enemy = Waypoint;
		self.goalentity = Waypoint;
		movetogoal(2);
		if(vlen(Waypoint.origin - self.origin) < 30)
		{
			self.pos5 = self.pos4;
			self.pos4 = self.pos3;
			self.pos3 = self.pos2;
			self.pos2 = self.pos1;
			self.pos1 = Waypoint.origin;
		}
		RotateTowards(Waypoint.origin, 13);
		self.velocity = (v_forward * 50);
	}
} 
	
void() EdgeDetect =
{
	local vector spot;
	if (random() < 0.80) return;
	if (!(self.flags & FL_ONGROUND)) return;

	makevectors (self.angles);
	spot = self.origin + (v_forward * 60);
	spot = spot - '0 0 35';
	if (pointcontents(spot) == CONTENT_EMPTY)
	{
		PlayerJump();
		self.velocity = self.velocity + v_forward * 100;
	}
};

void() StuckDetect =
{
	if(self.lastTouch + 3 < time)
	{
		if(vlen(self.lastAngles - self.origin) < 7)
		{
			self.timer = time + 2.5;
			bprint("STUCK DETECTED\n");
		}
		self.lastAngles = self.origin;
		self.lastTouch = time;
	}
};


float (vector dst, float smooth) RotateTowards = 
{
	local float		ideal, move, current_yaw, ret;
	
	self.ideal_yaw = vectoyaw(dst - self.origin);
	self.yaw_speed = smooth;
//current_yaw = self.ideal_yaw;
// mod down the current angle
	current_yaw = anglemod(self.v_angle_y);                    //changed self.angles  to  self.v_angle_y
	ideal = self.ideal_yaw;
	
	if (current_yaw == ideal) return 0;
	
	self.yaw_speed = (frametime / 0.1) * self.yaw_speed;    //Borrowed this from Orion's bot. (I'll give it back when done!)
	
	move = ideal - current_yaw;
	ret = move;
	if (ideal > current_yaw) 
	{
		if (move > 180) move = move - 360;
	}
	else 
	{
		if (move < -180) move = move + 360;
	}

	if (move > 0) 
	{
		if (move > self.yaw_speed) move = self.yaw_speed;
	}
	else 
	{
		if (move < 0-self.yaw_speed ) move = 0-self.yaw_speed;
	}

	current_yaw = anglemod (current_yaw + move);

	self.v_angle_y = current_yaw;                                     //changed self.angles  to  self.v_angle_y
	return ret;
};
void() waypoint =
{
};


*/