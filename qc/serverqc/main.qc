
//Main server function
void main()
{

};

//Called at the start of each frame.
void() StartFrame =
{
	teamplay = cvar("teamplay");
	skill = cvar("skill");
	framecount = framecount + 1;
};


/*
==============================================================================

BODY QUE

==============================================================================
*/

entity bodyque_head;

void() bodyque = { };
float BODYQUE_SIZE = 6; 

void() InitBodyQue 
{
	local entity e = spawn();
	e.classname = "bodyque";
	bodyque_head = e;

	for(float i = 0; i < (BODYQUE_SIZE - 1); i++)
	{
		e.owner = spawn ();
		e.classname = "bodyque";
		e = e.owner;
		i = i + 1;
	}
	e.owner = bodyque_head;
} 

// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQue =
{
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin(bodyque_head, ent.origin);
	setsize(bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};





entity lastspawn;
void() worldspawn =
{
	lastspawn = world;
	InitBodyQue();
	
	//custom cvars
	registercvar("gamemode", "0");
	
	//Custom stats
	addstat(STAT_TOTALITEMS, 2, item);
	addstat(STAT_PICKED_ITEMS, 2, picked_items);
	addstat(STAT_SHOTS, 2, total_shots);
	addstat(STAT_HITS, 2, total_hits);
	addstat(STAT_MEDKITS, 2, medkits);
	addstat(STAT_MONEY, 2, money);
	
	Precache();

	// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
	lightstyle(0, "m"); 													// 0 normal
	lightstyle(1, "mmnmmommommnonmmonqnmmo"); 								// 1 FLICKER (first variety)
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba"); 	// 2 SLOW STRONG PULSE
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg"); 					// 3 CANDLE (first variety)
	lightstyle(4, "mamamamamama"); 											// 4 FAST STROBE
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj"); 						// 5 GENTLE PULSE 1
	lightstyle(6, "nmonqnmomnmomomno"); 									// 6 FLICKER (second variety)
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm"); 							// 7 CANDLE (second variety)
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa"); 			// 8 CANDLE (third variety)
	lightstyle(9, "aaaaaaaazzzzzzzz"); 										// 9 SLOW STROBE (fourth variety)
	lightstyle(10, "mmamammmmammamamaaamammma"); 							// 10 FLUORESCENT FLICKER
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");					// 11 SLOW PULSE NOT FADE TO BLACK
	lightstyle(63, "a");// 63 testing
};



///////////////////////////////////////////
///////////// BASE ENT DEFS ///////////////
///////////////////////////////////////////



void() info_player_start =
{
};

void() info_player_start2 =
{
};

void() info_player_deathmatch =
{
};

void() info_player_usa =
{
};

void() info_player_ussr =
{
};

void() info_player_coop =
{
};