// 012_zirc_server_functions_macros.h
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

// static corpse is not working... use colormod when we go hard into it

#define OSelf_Push_Set_Temp(xoself, e)	entity xoself = self; self = e
#define OSelf_Pop(xoself)				self  = xoself

#define OOther_Push_Set_Temp(xother, e)	entity xother = other; other = e
#define OOther_Pop(xother)				other  = xother


#define JIT_Ent_Find_(e, e_ent,e_ent_name,s_describe) \
	if (!e_ent ) { \
		e_ent = find_ent_or_error(e, s_describe, e_ent_name, /*JIT is not spawn-time*/ false); \
	} // ender

// Discouraged!
#define Spawn_Ent_Find_(e, e_ent,e_ent_name,s_describe) \
	if (!e_ent ) { \
		e_ent = find_ent_or_error(e, s_describe, e_ent_name, /*sensitive to ent order*/ true); \
	} // ender

#define JIT_Ent_Find_Or_ErrMsg_(e, e_ent,e_ent_name,s_describe,pukemsg) \
	if (!e_ent ) { \
		obj_error_if_x (!e_ent_name, pukemsg); \
		e_ent = find_ent_or_error(e, s_describe, e_ent_name, /*JIT is not spawn-time*/ false); \
	} // ender

#define STATIC_CORPSE_OPTION_					if (cvar(CVAR_zrs_static_corpses))		{ self.think = SUB_Static; self.nextthink = time + 3; } // Ender
#define NOMONSTERS_DEATHMATCH_OPTION_			if (deathmatch || cvar("nomonsters"))	{ spawnflags_remove(self); return; }


	// Static corpses:
	// benefits  -- lower net traffic, physics thinks, smaller saves, smaller demos
	// downs:		supports position and angles ... not much else.
	//				won't fall with lifts (permanent floater)
	//				becomes permanently inaccessible to QuakeC
	//
	// Corpse removal reduces all of the above even more, but that has negatives too
	// The main one is you can no longer tell where you've been by dead bodies
	// The other negatives are more exotic when doing "advanced stuff" that prefers entity numbers not get changed much from worldspawn
	// but make static does that too.

#define bmodel_to_origin_low(bm)		(bm.origin + bm.mins)
#define origin_to_bmodel_low(pos, bm)	(pos - bm.mins)

#define DEFAULT_QC_SCALEZ(s_info_unused,field,val) \
			if (field == 0) field = val

#define DEFAULT_QC_FLOATZ(s_info_unused,field,val) \
			if (field == 0) field = val

#define DEFAULT_QC_STRING(s_info_unused,field,val) \
			if (!field) field = val


#define BModel_Precache_SetModel(e,m,solidy,movetypey)	\
			e.solid = solidy; e.movetype = movetypey; precache_model (m);	setmodel (e, m)

// Like  NextThink_Set (self, button_return, self.ltime + self.wait);
//		NextThink_Set (self, LinkDoors, self.ltime + NEXTTHINK_SOON_0_1);

#define NextThink_Set(e, func, t)				e.think = func; e.nextthink = t

#define PLAYER_CVAR_INVSTORE(plyr)				sprintf(CVAR_zrs_cross_player_invstore "_%d", plyr.pl_xcrossnum); 
#define PLAYER_CVAR_EXOSTORE(plyr)				sprintf(CVAR_zrs_cross_player_exostore "_%d", plyr.pl_xcrossnum); 

#define RANDOM_50_50(x,y)						(random() < 0.5) ? x : y
#define isbrushmodel(x)							string_does_start_with(x.model, "*")
#define isbrush_origin_brush_at_worldspawn(x)	(x.origin[0] != 0 || x.origin[1] != 0 || x.origin[2] != 0) // Misses 0, 0, 0 case but I'm not worrying about that right now.
#define IsPlayer(x)								x.classname == "player"


#define CVAR_zrs_cross_superframetime			"zrs_cross_superframetime"			// 
#define CVAR_zrs_cross_nextmap_spawnpoint		"zrs_cross_nextmap_spawnpoint"
#define CVAR_zrs_cross_player_invstore			"zrs_cross_player_invstore"
#define CVAR_zrs_cross_player_exostore			"zrs_cross_player_exostore"
#define CVAR_zrs_static_corpses					"zrs_static_corpses"


//
// Constant Macros
// 

#define ROLE_status_light						"status_light"	// keypad entity
#define ROLE_keypad_keybutton					"keypad_keybutton"

#define ROLE_elevator_button					"elevator_button"
#define ROLE_elevator_call_button				"elevator_call_button"
#define ROLE_elevator_door						"elevator_door"
#define ROLE_elevator_level_door				"elevator_level_door"

#define ROLE_cardstack							"cardstack"
#define ROLE_playerpos							"playerpos"
#define ROLE_housepos							"housepos"
#define ROLE_usedpos							"usedpos"
#define ROLE_betstation							"betstation"
#define ROLE_betkey								"betkey"

// key ...
#define button0_Attack							button0 	// mouse1
#define button1_Unusable						button1 	// 
#define button2_Jump							button2 	// space
#define button3_notusedyet						button3 	// 
#define button4_Search							button4 	// e
#define button5_ViewZoom						button5 	// mouse2
#define button6_Drop							button6		// g


WARP_X_ (MOVE_NOMONSTERS)

#define TL_everything_0							FALSE		// traceline
#define TL_bsp_solid_only_1						TRUE

#define GIB_NEG_40								-40

#define USE_COLORMAP_1024 1024

#define SERVERFLAG_RUNE_BIT_1					1
#define SERVERFLAG_RUNE_BIT_2					2
#define SERVERFLAG_RUNE_BIT_4					4
#define SERVERFLAG_RUNE_BIT_8					8
#define SERVERFLAG_RUNE_MASK_15					15
#define SERVERFLAG_RECUR_32						32
#define SERVERFLAG_CROSS_MAPSPOT_64				64


#define timeday_normal_0						0
#define	timeday_night_1							1
#define timeday_dawn_2							2
#define timeday_noon_3							3
#define timeday_dusk_4							4
#define timeday_noon_hour_12					12


#define PEACEFUL_1								1
#define PEACEFUL_SLEEP_2						2
#define PEACEFUL_DEALER_3						3
#define PEACEFUL_LOOK_4							4

//
#define STOR_PLAYER_DIRTY_1 					1
#define STOR_LOCKER_DIRTY_2 					2
#define STOR_XOLOCK_DIRTY_4 					4


// world
#define	WRLD_MEDIEVAL_0							0
#define	WRLD_METAL_1							1
#define	WRLD_BASE_2								2

#define	WRLD_ZIRCON_MODERN_10					10
#define	WRLD_ZIRCON_PAST_11						11
#define	WRLD_ZIRCON_FUTURE_12					12

#define	ITX_SPIN_4096							4096	// self.modelflags |= MF_ROTATE;
#define	ITX_FULLBRIGHT_8192						8192	// self.effects |= EF_FULLBRIGHT;
#define	ITX_DO_NOT_SPIN_16384					16384	// default this (collides with DOOR_USE_RENT_16384)
#define	ITX_HOVER_32768							32768	// keys for now

WARP_X_ (LIGHT_STARTS_OFF_1, PLAT_LOW_TRIGGER_1, SECRET_NO_SHOOT_8, DOOR_START_OPEN_1, TRIGGER_PUSH_ONCE_1, /*tele*/ PLAYER_ONLY_1, SPAWNFLAGS_PATH_CORNER_FLY_POLE_1)

#define SPAWNFLAGS_RADIO_MAPMUSIC_OFF_1			1		// Turns off map music instead
#define SPAWNFLAGS_PATH_CORNER_FLY_POLE_1		1
#define	SPAWNFLAGS_EXIT_COST_AND_REMOVE_1		1
#define	SPAWNFLAGS_CONTAINER_IS_FORGE_2			2
#define	SPAWNFLAGS_CONTAINER_BUSY_4				4
#define	SPAWNFLAGS_CONTAINER_PRODUCT_8			8
#define	SPAWNFLAGS_ITEM_PRECAcHE_16				16

#define	SPAWNFLAGS_DRAMATIC_DAMAGE_65536		65536	// spawnflags
#define SPAWNFLAGS_NON_SOLID_262144				262144	// spawnflags
#define SPAWNFLAGS_AMBUSh_MASK_3				3		// do not wake except actually seeing te player
#define SPAWNFLAGS_THIN_TOUCH_BOX_524288		524288	// spawnflags - allow harder to pick up keys

WARP_X_ (FL_JUMPRELEASED /*4096*/ ) 

#define FL_CAMERA_8192							8192	// Spawn_Camera_With_Angles, Spawn_Camera
#define FL_VEHICLE_16384						16384

#define FL_ITEM2_524288							524288	// thin extra wide (example: make a key use real bbox at spawn while retaining FL_ITEMS for other things)
#define FL_ORIGIN_BRUSH_131072					131072	// identify these for correct calculations or does it matter?

#define	DOOR_SECRET_DEFAULT_0					0
#define	DOOR_SECRET_SOUND_MEDIEVAL_1			1
#define	DOOR_SECRET_SOUND_METAL_2				2
#define	DOOR_SECRET_SOUND_BASE_3				3

#define	DOOR_SOUND_SILENT_0						0 // "No sounds"
#define	DOOR_SOUND_STONE_1						1
#define	DOOR_SOUND_MACHINE_2					2
#define	DOOR_SOUND_STONE_CHAIN_3				3
#define	DOOR_SOUND_SCREECH_4					4
#define	DOOR_SOUND_CUSTOM_5						5

#define TRIGGER_PUSH_ONCE_1						1

// spawnflags
#define DOOR_START_OPEN_1						1
#define	DOOR_REVERSE_2							2
#define DOOR_DONT_LINK_4						4
#define DOOR_GOLD_KEY_8							8
#define DOOR_SILVER_KEY_16						16
#define DOOR_TOGGLE_32							32
#define	DOOR_X_AXIS_64							64
#define	DOOR_Y_AXIS_128							128

#define DOOR_LOCKED_4096						4096	// keypad or button activated
#define DOOR_USE_MANUAL_8192					8192	// press to activate ... like cabinent or manual door
#define DOOR_USE_RENT_16384						16384	// collides with ITX_DO_NOT_SPIN_16384

#define DOOR_WAIT_STAY_OPEN_NEG1				-1

#define	SECRET_OPEN_ONCE_STAYS_OPEN_1			1		// stays open
#define	SECRET_1ST_LEFT_2						2		// 1st move is left of arrow
#define	SECRET_1ST_DOWN_4						4		// 1st move is down from arrow
#define	SECRET_NO_SHOOT_8						8		// only opened by trigger
#define	SECRET_YES_SHOOT_16						16		// shootable even if targeted


//#define item_sneakers_9						9
//#define item_flashlight_10						10
//#define item_scope_11							11
//#define item_jacker_12							12

#define SKILL_NIGHTMARE_3						3

#define INVISI_ALPHA_0_4						0.4
#define INVISI_ALPHA_NOT_0_0					0.0
#define POWERUPS_0								0
#define KEYS_0									0

// Camera
#define CAMERA_TRANSITION_1						1
#define CAMERA_SEQ_NOABORT_16					16
#define CAMERA_SEQ_STOP_PLAYER_32				32
#define CAMERA_SEQ_TRANSITION_RETURN_64			64

#define PLAYER_CAMERA_ABORT_NEG1				-1
#define INTERMISSION_LIKE_0_0_0					'0 0 0' // Causes normal stuff to not happen in PlayerPreThink

#define WATER_LEVEL_NOT_0						0
#define WATER_LEVEL_FEET_1						1
#define WATER_LEVEL_WAIST_2						2
#define WATER_LEVEL_EYES_MAX_3					3

#define modelindex_zero_0						0
#define water_ok_time_12						12
#define lightnormal_m_12						12

// Monsters
#define	MONSTER_SKIN_HAND_GREEN_0				0
#define	MONSTER_SKIN_HAND_ORANGE_1				1

#define	MONSTER_SKIN_GUARD_RED_0				0
#define	MONSTER_SKIN_GUARD_BLACK_1				1
#define	MONSTER_SKIN_GUARD_BLUE_2				2
#define	MONSTER_SKIN_GUARD_GOLD_3				3
//#define MONSTER_SKIN_GUARD_GREEN_4			4



WARP_X_(paction_dropy_project)

// Frame
WARP_X_(PlayerPreThink) // PlayerJump, attack_finished and out of ammo

WARP_X_(e SV_Physics)
	WARP_X_(StartFrame) // does not do much ..increases the frame counter
		WARP_X_(PlayerPreThink) // JUMP
			
		WARP_X_(PlayerPostThink)
			WARP_X_(Weapon2_ImpulseCommands)
		
WARP_X_(SV_ParseClientCommand)
WARP_X_(worldspawn)
WARP_X_(RestoreGame)


WARP_X_(SetChangeParms)				// changelevel
WARP_X_(SetNewParms)
WARP_X_(ClientConnect)
WARP_X_(PutClientInServer)




// Issues ... 

// Can avoid save game issue saving ix fields?  Might not issue if never update the strings.
// Does RestoreGame call worldspawn?  no right?

// Q
//KLESKBY void ai_sleep ();
//KLESKBY void execute_changelevel();

// Zirc





void GotoNextMap ();



float crandom() { return random(-1, 1); } // random from -1 to 1

void paction_request_update(entity plyr, float paction_num, entity target, string sendo);

void TE_gunshot_at(vector org);
void vault_try_already_asserted_locker (entity plyr, string sguess);

void PlayerDie();
void ZR_Cross_WorldState ();
//void ZRS_PCIS_DecodeLevelParms(entity plyr);

void pb (entity plyr); // toolbits check
entity sound_ent_restart_with_origin(entity esrc, string wavname, float wavtime);
void SUB_Snd_Again_Think ();
void radio_toggle (entity plyr /*we care why?*/, entity e);
void BonusFlash(entity plyr);
void pre_remove_faller(entity edie);
float droptofloor2(entity efall);
//vector droptofloor3(entity efall);
//void PlaceIt(entity plyr);
void PlaceItToggle(entity plyr);
void PlaceItStart(entity plyr, float it0);
void PlaceItKill(entity plyr);
void PlaceItFinal(entity plyr);

//string salt_magic(entity item);
string item1_pickupnoise(float idxp1);
float item1_isgettable(float idxp1);

void XPP(entity plyr, float amt, entity ekilled);
//KLESKBY void LaunchLaser2(vector org, vector vec);
//KLESKBY void Laser_Touch ();

#define projectile_remove		remove
#define spawnflags_remove		remove		// deathmatch mode or spawnflags prevent this entity from the start
#define dropfloorfail_remove	remove		// 
#define itemused_remove			remove		// TRIGGER_PUSH_ONCE_1, grab backpack
#define helper_ref_remove		remove		// nightvision think entity, radio sound ent, 



void _orig_adjust (float x, float y, float z);
void bound_other_ammo();
float W_BestWeaponHotbar_IT_bit();
void W_SetCurrentAmmo();
void SUB_regen();


void map_music_change();



string einfo(entity e); // prints ent num and classname .. not really ground-breaking
//void attachment_check ();
//void PlayerPreThink_Camera (entity plyr);
//void info_camera_use();
//void Camera_Start_NewCam (entity plyr, entity newcam);

void SUB_CalcAngleMoveSpeed(vector destangle, float traveltime, void() func);

//float player_is_in_camera (entity plyr);

//void broadcast_skin(entity head, string s_role_filter, float skinnum);
//void broadcast_func_text_text(entity head, string s);
//void controller_build_chain_set_controller_ent ();

void vehicle_enter();
void vehicle_exit();



vector relpos3 (entity e, float dfwd, float dright, float dup);

//void attach_x_to_y (entity x_small, entity y_big);



//KLESKBY void LaunchLaserRed2 (vector org, vector vec);
//KLESKBY void Laser_Touch2 ();

void player_stand1();

#define EXOSTORE_36 36
#define ANVIL_2		2

float give_it(entity plyr, string sitem /*entity etake*/);
void slotsremoveamount(float islocker, float it0, float cap, float fcost);

//KLESKBY void IA_LookAt ();

#define TURN_SPEED_1		1 
#define TURN_SPEED_CLOSE_9	9 // We stop turning to not act overly interactive

#define IS_DISABLED_ZERO_LESS_HEALTH(e) (e.health <= 0)
#define DISABLED_NEG1					-1
#define ENABLED_POS1					1

 /*not ltime*/
#define NextThink_Set_Delayed_Trigger_field_Servant_TimePlus(e,DelayThink,timex) \
		if (e.trigger_field) {					\
			dpr ("e.trigger_field shutdown");	\
			remove (e.trigger_field);			\
			e.trigger_field=world;				\
		}										\
		assert (e.trigger_field == world);		\
		entity xt = spawn();					\
		xt.classname		= "DelayedUse";		\
		xt.trigger_field	= e;				\
		xt.think1			= DelayThink;		\
		e.trigger_field		= xt;				\
		NextThink_Set (e.trigger_field, Delay_Think1_Trigger_field, timex) // ender

#define NextThink_Set_Delayed_Raw_TimePlus(e,WhatToDo,timex) \
		entity xt = spawn();					\
		xt.classname		= "DelayedUse";		\
		xt.think1			= WhatToDo;		    \
		NextThink_Set (xt, Delay_Think1_Raw_And_Remove_Self, timex) // ender

void Delay_Think1_Trigger_field ();


#define SEND_VECTOR(v) v.x, v.y, v.z

#define	sxcmd_move_to_1			1
#define	sxcmd_turn_to_2			2
#define	sxcmd_move_turn_to_3	3
#define	sxcmd_skin_to_4			4


#define for_each_control_for_x_with_role(E,Eboss,ROLO) \
	for (entity E = Eboss.controller_head /*head*/; E; E = E.controller_chain) { if (E.controller_role != ROLO) continue;

#define for_each_end }



#define NEWLINE_CARET		"^"


float _SVX_SendEntity (float ent_type, entity clplyr, float changedflags);
void origin_brush_maybe_set_flag ();


float video_SendEntity(entity clplyr, float changedflags);
float proggy_SendEntity(entity clplyr, float changedflags);

void item_nova ();

float slotsgettotalamountof(float islocker, float it0, float cap);

float slotfinditemwithcount(float islocker, float it0, float cap, float amt);


void dropped_contentstransition (float old_contents, float cur_contents);

#define GENERIC_BOX "models/q_items/rockets_box.obj"


