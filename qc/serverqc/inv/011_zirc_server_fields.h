// 011_zirc_server_fields.h
/*
Copyright (C) 2023 Baker

This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/


// POI
WARP_X_(Weapon2_ImpulseCommands)
WARP_X_(SetChangeParms)
WARP_X_(SetNewParms)
WARP_X_(worldspawn)


// PLAYER
WARP_X_(IMPULSE_INVENTORY_50)
WARP_X_(STAT_GOLD_35)

WARP_X_(WORLD_ATTR_RWATER_1)

WARP_X_ (VARZ)

typedef struct {
	float		superframetime;						// Start of level supertime
	float		light_level;						// (0-25) Set at beginning of level.  defaults (12 <----) m is 13th letter of alpha, but lightstyle a is 0 so m is 12.
	float		timeday;							// timeday_dawn_2
	string		skybox_a;
	float		is_outdoors;
	float		is_night;
	float		world_attr;
	vector		world_questpos;
	string		newmap_spawnpoint_a;				// If a spawnpoint in the map is wanted, set this
	float		curskill;
	string		map_title_a;						// not allocated
	entity		map_quest_ent;						// not the quest target!
} levstart_s;

//
// 1. GLOBALS
// 

// NAME				FIELD							COMMENTS

levstart_s			levstart;
float				gg_restore_hard_sky_kick;		// For RestoreGame - makes ClientConnect do UpdateSky
float				gg_superframetime;				// advances every ZRS_Frame called by qc in StartFrame
entity				gg_lastspawn;					// ??
entity				gg_map_music_ent;

entity				gg_trigger_firing;				// trigger that is firing a .use()

string				gg_finale_text;						// not allocated

//
// DEV
//

float				dev_lightstyle;					// worldspaw /dev 


//
// TRANSITIONAL FIELDS FOR CHANGELEVEL
//

// NAME				FIELD							COMMENTS

string				chang_nextmap;					// global for changelevel
string				chang_nextmap_spawnpoint;		// global for changelevel

//
// GLOBALS NOT PERMITTED BEYOND THIS POINT	----	GLOBALS NOT PERMITTED BEYOND THIS POINT		--	GLOBALS NOT PERMITTED BEYOND THIS POINT
// GLOBALS NOT PERMITTED BEYOND THIS POINT	----	GLOBALS NOT PERMITTED BEYOND THIS POINT		--	GLOBALS NOT PERMITTED BEYOND THIS POINT
// GLOBALS NOT PERMITTED BEYOND THIS POINT	----	GLOBALS NOT PERMITTED BEYOND THIS POINT		--	GLOBALS NOT PERMITTED BEYOND THIS POINT
//

	//
	// 2.		PRIVATE VARIABLES (NON-WORLDSPAWN) ONLY.  Worldspawn is section 3.
	//			PRIVATE VARIABLES (NON-WORLDSPAWN) ONLY.  Worldspawn is section 3.
	//			PRIVATE VARIABLES (NON-WORLDSPAWN) ONLY.  Worldspawn is section 3.
	//			PRIVATE VARIABLES (NON-WORLDSPAWN) ONLY.  Worldspawn is section 3.
	//			PRIVATE VARIABLES (NON-WORLDSPAWN) ONLY.  Worldspawn is section 3.
	//

WARP_X_ (SendFlags, SendEntity, MSG_ENTITY, CSQC_Ent_Update)

// TODO: func_text and security keypad at 45 degree angle?

.float SendFlags;
.float(entity to, float sendflags) SendEntity;


//
// PLAYER STATS
// 

// NAME				FIELD							COMMENTS
// 					.viewzoom 						// STAT_VZOOM_32				(dpp builtin)
// 					.max_health						// STAT_MAX_HEALTH_33			(progs builtin)
.float				pls_world_attr;					// STAT_WORLD_ATTR_50 (PutClientInServer sets) only reliable comm of world state I can think of
.vector				pls_world_questpos;				// STAT_WORLD_ATTR_QUESTPOS_52 thru 54
.float				pls_world_curskill;				// STAT_WORLD_ATTR_CURSKILL_51
.float				pls_activeslot;					// STAT_ACTIVESLOT_34
.float				pls_gold;						// STAT_GOLD_35


.float 				pls_xp;							// STAT_XP_36
.float				pls_carryslotz;					// STAT_CARRYSLOTS_37

WARP_X_ (toolbits_flashlight_256)
.float				pls_toolbits;					// STAT_TOOLBITS_38
.float				pls_toolstate;					// STAT_TOOLSTATE_39
.float				pls_remain_amount;				// STAT_REMAIN_AMOUNT_40
.float				pls_total_amount;				// STAT_TOTAL_AMOUNT_41
.float				pls_possible_action;			// STAT_PACTION_42
.float				pls_in_camera;					// STAT_IN_CAMERA_43

.float				qr[12];
.float				qrit0;
.float				qrj;

WARP_X_ (pls_activeslot)

.float				qemptowep;						// empty

//
// PLAYER STATS INNER
// 

// NAME				FIELD							COMMENTS
.float 				pl_xcrossnum;					// transition id
.string 			pl_exostore;					// exo-store locker	(see also stored in worldspawn
.float				pl_stored_dirty;				// 2 means locker dirty
.float				pl_keys;						// replaces keyz for player (formerly items)
.float				pl_powerups;					// replaces powerups for player (compat) (formerly items)

.entity				pl_action_ent;					// Possible action entity
.string				pl_action_string_a;				// stuffcmd paction_string_update
.float				pl_action_dirty;				// At end of frame - ONLY POSITIVE VALUES MEAN WE ARE UP TO DATE.  Means default value of 0 causes a client update.

//
// PLAYER FIELDS PRIVATE
// 

// NAME				FIELD							COMMENTS

// func_liquid & func_ladder
//.string			fmover;
//.float			drag;
.float				laddertime;						// If laddertime > time -- on ladder
.float				ladderjump;
.float				gravity;						// actually a system global from the Mission Pack builds of Quake
.float				oldgravity;
.float				zerogtime;

.float				pl_nextjumptime;				// Wall climbing
.entity				pl_weaponentity;				// For holding non-weapon like an apple
.float				pl_throw_j_p1;					// idx of item
.float				pl_searchstarttime;				// PL
.float				pl_searchendtime;
.float				pl_searchnexttime;
.float				pl_searchdown;
.float				pl_throwdown;

.float				pl_skill_melee;					// TODO

//
// ITEM FIELDS PRIVATE
// 

// NAME				FIELD							COMMENTS
.float				it_door_key;					// replaces items for door
.string				it_formalname;					// used over all other descriptive names
.float				it_itemidxp1;
//.float			it_letter_digitnum;				// letter digit
.float				it_powerups;					// replaces items for powerups

.string				text_input;						// 

.entity				controller_chain;				// next ent in chain
.entity				controller_head;				// 
.entity				controller_ent;

.entity				our_door_ent;					// elevator/keypad security (keep)
//.float			our_last_pos;
//.float			our_isdirty;

// camera
.entity				info_cam_ent;					// Current info_cam_ent, we might 
.entity				fake_body;						// for camera to look at;
.entity				saved_settings;
//.string			attentions;						// player attentions triggered?

.float				old_movetype;

.float				camera_end_time;				// our_camera;
.float				camera_retrigger_ok_time;		// no re-trigger a camera for a few

.entity 			first_camera;					// 

.vector				our_mdlsize;					// func_text: set the model size -- sort of a temp hack

//
// ITEM PLACER FIELDS PRIVATE
// 

// NAME				FIELD							COMMENTS
.float				ti_placedown;
.float				ti_placeit0;					// ?
.entity				ti_placer;
.float				ti_placersize;
.float				ti_placerok;
.entity				ti_placeblocker;

//
// MISC
//

.entity				it_chrevo;						// For chain reversal
.string				it_grav_canfallcansupport;		// hack for gravity we hope to try regarding destroyed objects supporting others
.float				it_grav_support_count;

//.entity			it_children[MAX_TEXTSIZE_32];	// func_text
//.float			it_numchildren;


//
// UNION-ISH
//

// player use ...
#define flashlight_ent1			my_ent1
#define flashlight_ent2			my_ent2
#define nightvision_ent3		my_ent3

// items: radio 
#define sound_ent1				my_ent1
#define who_dropped_ent1		my_ent1			// prevent take on drop
//#define seconds_length1			my_float1
//#define seconds_length2			my_float2
//#define seconds_length3			my_float3

// monster
#define turret_base_ent1		my_ent1
#define turret_gun_ent2			my_ent2

#define capacity_float1			my_float1
#define material_float2			my_float2

#define eqslot_float3			my_float3

    .entity	tur_head;			// tag_head
    .entity	vehicle_hudmodel;
    .entity	vehicle_viewport;
    .entity	gun1;				// tag_hardpoint01
    .entity	gun2;				// tag_hardpoint02

.vector				my_vec1;	// centerpos_vec1, ..
.vector				my_vec2;	// glow color (keypad_key)
.vector				my_vec3;	// norm color (keypad_key)
.vector				my_vec4;	// disabled color (keypad_key)

#define glowcolor_vec2	my_vec2	// bulk teleport field
#define normcolor_vec3	my_vec3	// bulk teleport field
#define disacolor_vec4	my_vec4	// bulk teleport field

#define centerpos_vec1	my_vec1	// bulk teleport field

.entity				my_ent1;
.entity				my_ent2;
.entity				my_ent3;
.entity				my_ent4;
.entity				my_ent5;

.float				my_float1;
.float				my_float2;
.float				my_float3;
.float				my_float4;
.float				my_float5;


WARP_X_ (VARZ)

//
// WORLDSPAWN ONLY BEYOND THIS POINT	----	WORLDSPAWN ONLY BEYOND THIS POINT		--	WORLDSPAWN ONLY BEYOND THIS POINT
// WORLDSPAWN ONLY BEYOND THIS POINT	----	WORLDSPAWN ONLY BEYOND THIS POINT		--	WORLDSPAWN ONLY BEYOND THIS POINT
// WORLDSPAWN ONLY BEYOND THIS POINT	----	WORLDSPAWN ONLY BEYOND THIS POINT		--	WORLDSPAWN ONLY BEYOND THIS POINT
//

//
// 3. WORLDSPAWN
//

// NAME				FIELD							COMMENTS
.float				backfacerender_deprecated;		// will be removed in future.  used for ship wreck so faces don't get culled making it look funky
													// Future will be for item system to know to set this flag.

.float				item_amount;						// dropped items
.string				itemname;						// "fridge" or "chest"

.float				make_this_static;				// func_text: will makestatic after droptofloor option
.float				nodroptofloor;					// item_x:  Don't droptofloor.  Keeps items in inappropriate places from falling out of map.
.float				peaceful;						// monster doesn't attack unless attacked (0 1 or PEACEFUL_SLEEP_2)
.string				reveals;						// breakable crate becomes this when broken
//.string			safecombo;						// passcode
.float				safetier;
.float				interval;
.float				intervaljitter;
.float				startjitter;
.float				active;
//.float			flash_type;
.string				spawnpoint;						// specific spawn point in map to use .. see example
.string				extra_data;						// Available for "use"
.string				extra_data2;
.string				condition;

// camera
.string				next_camera;					// info_camera
.string				look_at;						// info_camera
.float				transition_seconds;				// info_camera
.float				zoom_factor;
.float				zoom_seconds;
.string				message2;						// attn
.string				message3;						// attn

.string				quest_target;					// 

.float				seconds_length1;				// radio_toggle - soundlength(e.noise1);
.float				seconds_length2;
.float				seconds_length3;

.string				effects_name;
.string				flash_name;
	
	
// spawnpoint example:
//
//	EXIT
//			{
//				"classname"		"item_exit"
//				"origin"		"19 302 1080"
//				"itemname"		"telepod"
//				"map"			"czest1dm"
//				"spawnpoint"	"mystics"			// <------------ go to the mystics spawm poimt im the map
//			}
//
//	DEST
//
//			{
//				"classname"		"info_player_start"	// gauntlet
//				"origin"		"82 563 -8"
//				"angles"		"-3 147 0"
//				"spawnpoint"	"gauntlet"
//			}
//

// NAME				FIELD							COMMENTS
.float				gravity;						// global Q3 for level
.string				map_music;						// locker (also used by plyr ent)
.float				map_music_volume;
.string				stored;							// locker (also used by plyr ent)
.string				readtext;						// book

.string				talkdialog;						// talk dialog "tree"
.string				talkname;						// "johnson" --- For interactable entities
.string				talkpic;						// "johnson" --- For interactable entities

.float				text_isclock;					// func_text: it's a clock
.float				text_numchars;					// func_text: set number of characters, instead of using strlen(message)
.float				text_isdigital;
.string				passcode;						// see text_input

.string				attach_to;						// Means follow.
.string				controller;						// explain?
.string				controller_role;				// 

.string				teledest;						// item, weapon

.string				worldhints;						// "worldhints" "[saltwater][outdoors]" or "worldhints" "[r_water]"


.float				action_type;					// func_mechanical
.vector				relative_move;					// elevator


WARP_X_ (video_start_time_u, rad_time, video_frame_fps_u, speed)
.string				video_image;
//.float			video_frame_width;
//.float			video_frame_height;
//.float			video_frame_count;


// worldhints:
//	[r_water]										// notifies client of WORLD_ATTR_RWATER_1 in pls_world_attr / STAT_WORLD_ATTR_50, client settings may enable r_water feature or may ignore it if effects level is low
//	[nometalsteps]									// do not do metal footsteps on map, use regular instead (map might overdo it with metal surfaces)
//	[outdoors]										// sky and lightlevel depend on time
//	[indoors]										// lightlevel depend on time, but mostly just lights on or off
//	[lowlight]										// sets lightstyle to low (6) to have map darkish

// animation "unions"
#define moveseq_u				lip
#define	movestring_u			deathtype		// "do this;do that"
#define	think_done_u			th_melee
#define video_start_time_u		rad_time
#define video_frame_fps_u		speed

#define exhaust_count_u			waitmax

#define action_to_describe_u	message2		// "to place your order"
#define trader_name_u			talkname		// "Wally Burger"
#define vendtype_u				lip				// 0 v, 1 trade, 2 sell

#define vend_mach_0		0
#define vend_trader_1	1
#define vend_pawner_2	2


