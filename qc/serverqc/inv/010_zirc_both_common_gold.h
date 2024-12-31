// 010_zirc_both_common_gold.h - used by both client and server
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

#define MAX_PLAYERS_SUPPORTED_64	64

#define K_ATTACK_NEG2	-2
#define K_INV_NEG3		-3
#define K_RELOAD_NEG4	-4
#define K_SEARCH_NEG5	-5

#define K_FORWARD_NEG6	-6
#define K_LEFT_NEG7		-7
#define K_RIGHT_NEG8	-8
#define K_DOWN_NEG9		-9

#define imiss_not_0		0	// intermission enum
#define imiss_scores_1	1
#define imiss_finale_2	2
#define imiss_dead_5	5


#define static do_not_use_this // <------ static variables localize a variable to a file --- it does name mangling -- that may screw up save games DO NOT use at this time.

#define VOL_BASE_0_7	0.7
#define random_0_to_1	random // never returns exactly MIN or exactly MAX  random_0_to_1

#define QUEST_OVERHEAD_0_0_20	'0 0 20'

//
// Paction
//
#define target_null 0 // world // which is null

// self.button4			search
// self.button5			viewzoom

// negative values are norm with xtra ihfo 
WARP_X_(paction_request_update)
#define PACTION_LOOK_TALK_NEG1				-1
#define PACTION_LOOK_VEND_NEG2				-2
#define PACTION_LOOK_GRAB_NEG3				-3
#define PACTION_LOOK_EXIT_NEG4				-4
#define PACTION_LOOK_STOR_NEG5				-5
#define PACTION_LOOK_BOOK_NEG6				-6
#define PACTION_LOOK_SAFE_NEG7				-7
#define PACTION_LOOK_RADIO_NEG8				-8
#define PACTION_LOOK_KEYBTN_NEG9			-9
#define PACTION_LOOK_DOOR_USE_NEG10			-10
#define PACTION_LOOK_ELEV_BTN_NEG11			-11
#define PACTION_LOOK_ELEV_LEVBTN_NEG12		-12
#define PACTION_LOOK_FL_ITEM_NEG13			-13		// Gravvavle item -- like key, use FL_ITEM2_524288 a spawnflag for thin
#define PACTION_LOOK_DRIVE_NEG14			-14
#define PACTION_LOOK_TXED_NEG15				-15
#define PACTION_LOOK_DEALER_NEG16			-16
#define PACTION_LOOK_CHESS_PIECE_NEG17		-17
#define PACTION_LOOK_CHESS_SQUARE_NEG18		-18
#define PACTION_LOOK_SCREEN_NEG19			-19
#define PACTION_LOOK_DOOR_USE_RENT_NEG20	-20
#define PACTION_LOOK_VENDSELL_NEG21			-21
#define PACTION_LOOK_FORGE_NEG22			-22
#define PACTION_LOOK_RADIO_NEG23			-23

#define PACTION_ZORM_0				0
#define PACTION_BOOK_1				1
#define PACTION_INVE_2				2
#define PACTION_SAFE_3				3
#define PACTION_STOR_4				4
#define PACTION_TALK_5				5
#define PACTION_VEND_6				6
#define PACTION_OPEN_7				7
#define PACTION_BONK_8				8
#define PACTION_DROP_9				9
#define PACTION_PROGGY_10			10
#define PACTION_VENDSELL_11			11

//#define PACTION_ATTN_A			10 // Chase-cam like attention



//#define PACTION_ORG_ADJ_0_0_22		'0 0 22'  // +++ not negative --- Baker PACTION_DIST_96 needs to start from '0 0 22' not '0 0 16'
#define VIEWOFS_NORM_0_0_22			'0 0 22'
#define PACTION_DIST_96				96
#define PACTION_TOUCH_DIST_64		64			// jul152022 unused



// Locker

#define islockerzone(x)				((x) >= LOCKER_ITEMS_START_64)
#define ispossibleslot(x)			inrangebeyond (0, x, LOCKER_ITEMS_START_64 * 2)

#define LOCKER_ITEMS_START_64		64
#define MAX_ITEMS_SLOTS_64			64
#define LOCKER_TEMP_SLOT_128		128						// actually used for swap operation
#define EXO_STORE_CAPACITY_36		36

#define slot_empty_neg1				-1
#define slot_offgrid_neg2			-2
#define slot_offpane_drop_neg3		-3						// not used, idea
#define dur100						100
#define	dont_care_0					0						// used?  why?

#define	is_player_0					0						// 
#define	is_locker_1					1						// 
#define	is_xolock_2					2						// idea
#define	is_slottemp_3				3						// idea

#define CURSOR_NORM_0				0						// CL
#define CURSOR_DROP_1				1
#define CURSOR_USER_2				2
#define CURSOR_NODROP_3				3

WARP_X_ (CVAR_fov, CVAR_viewsize, ..) // CSQC onlys

#define CVAR_teamplay				"teamplay"				// 
#define CVAR_skill					"skill"					// 
#define CVAR_r_water				"r_water"				// 
#define CVAR_timelimit				"timelimit"
#define CVAR_fraglimit				"fraglimit"

#define CMD_loadsky					"loadsky"

#define CMD_zsv_to_client_upd_inventory			"zsv2cl_upd_inventory"	// 
#define CMD_zsv_to_client_upd_locker			"zsv2cl_upd_locker"		// 
#define CMD_zsv_to_client_safe_reply			"zsv2cl_safe_reply"		// 
#define CMD_zsv_to_client_talk_reply			"zsv2cl_talk_reply"		// 
#define CMD_zsv_to_client_levelup				"zsv2cl_levelup"		// 
#define CMD_zsv_to_client_paction_update		"zsv2cl_paction_update"	// string update
#define CMD_zsv_to_client_zoom_attention		"zsv2cl_zoom_attention"	// string update
#define CMD_zsv_to_client_turn_attention		"zsv2cl_turn_attention"	// string update
#define CMD_zsv_to_client_turn_attention_msg	"zsv2cl_turn_attention_msg"	// string update
#define CMD_zsv_to_client_map_title				"zsv2cl_map_title"		// 
#define CMD_zsv_to_client_map_quest				"zsv2cl_map_quest"		// 



#define CMD_cl2sv_uexit				"uexit"					// both	
#define CMD_cl2sv_ucode				"ucode"					// both	
#define CMD_cl2sv_uinvdrop			"uinvdrop"				// both
#define CMD_cl2sv_uinvswap			"uinvswap"				// both
#define CMD_cl2sv_ustordrop			"ustordrop"				// both
#define CMD_cl2sv_ustorswap			"ustorswap"				// both
#define CMD_cl2sv_uraid				"uraid"					// both
#define CMD_cl2sv_uget				"uget"					// both
#define CMD_cl2sv_uask				"uask"					// both
#define CMD_cl2sv_ubuy				"ubuy"					// both
#define CMD_cl2sv_usell				"usell"					// both
#define CMD_cl2sv_say				"say"					// both
//#define CMD_cl2sv_uthrow			"uthrow"				// both

#define INV_PEEK_SECS_0_3			0.3						// cl


#define CVAR_zr_hotbar				"zr_hotbar"				// Bool?  Show hotbar in HUD.   0 is off.
#define CVAR_zr_wearbar				"zr_wearbar"			// Bool?  Show wearbar in HUD.  0 is off.
#define CVAR_zr_star				"zr_star"				// Star animation.  Default 1.  0 is off, 2 is center screen.
#define CVAR_zr_hints				"zr_hints"				// Hover tips in inventory.  zr_hints 0 turns them off.
#define CVAR_zr_r_water				"zr_r_water"			// zr_r_water 0 means r_water is never turned on, zr_r_water 1 means r_water is activated when needed [r_water] map hint
#define CVAR_zr_ivid				"zr_ivid"				// Video test
#define CVAR_zr_inventory_peek		"zr_inventory_peek"		// allows peeking into inventory (by continuously holding TAB for over INV_PEEK_SECS_0_3) which means releasing TAB exits inventory.  zr_inventory_peek 0 turns this off
#define CVAR_zr_inventory_options	"zr_inventory_options"	// 1 shows check marks in inventory to turn on off hotbar/wearbar.


#define CVAR_zr_show_speed			"zr_show_speed"			// Show speed
#define CVAR_zr_show_paction		"zr_show_paction"		// Show paction



//#define CVAR_pvt_quest				"pvt_quest"			// 
//#define CVAR_pvt_quest_pos			"pvt_quest_pos"		// 
#define CVAR_pvt_pagenum			"pvt_pagenum"			// 
//#define	CVAR_pvt_chasesaved			"pvt_chasesaved"		//


#define ALE_inventory				"inventory"				// IMPULSE_INVENTORY_50
#define ALE_psearch					"+search"				// +button4
#define ALE_messagemode				"messagemode"			// t
#define ALE_reload					"+hook"					//
#define ALE_pattack					"+attack"				// +button0
#define ALE_pforward				"+forward"				// +forward
#define ALE_pleft					"+left"					// +left
#define ALE_pright					"+right"				// +right
#define ALE_pmoveleft				"+moveleft"				// +left
#define ALE_pmoveright				"+moveright"			// +right
#define ALE_pdown					"+back"					// +back
#define ALE_pdrop					"+drop"					// +button6
															// button5 --> zoom

//PlayerPostThink
// SetNewParms and SetChangeParms

#define IT_ALL_AMMOS_MASK			(IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS)

//
// Controls
//

#define	IMPULSE_FLASHLIGHT_13		13
#define	IMPULSE_NIGHTVISION_14		14
#define IMPULSE_NEXTWEAP_10			10
#define IMPULSE_PREVWEAP_12			12

#define IMPULSE_CHEAT_GIVE_9		9
#define IMPULSE_QUAD_GIVE_255		255
#define IMPULSE_DROP_35				35

#define IMPULSE_LIGHTUP_33			33
#define IMPULSE_LIGHTDOWN_34		34


#define IMPULSE_INVENTORY_50		50
#define IMPULSE_RELOAD_77			77
#define IMPULSE_MAPVIEW_88			88
//#define IMPULSE_SEARCHY_51		51	utto

#define IMPULSE_THROWUP_63			63
#define IMPULSE_THROWDOWN_64		64

//
// Stats
//

WARP_X_ (STAT_SECRETS, STAT_MONSTERS, STAT_ITEMS, STAT_TOTALSECRETS, STAT_TOTALMONSTERS)
WARP_X_ (STAT_FRAGLIMIT, STAT_TIMELIMIT, STAT_MOVEVARS_GRAVITY)
WARP_X_ (maxclients, pmove_inwater, coop, deathmatch, mapname, message)
// Q: How does map title show?

// team scores?  gametype?
// We may want to MSG_ALL for things that don't seem supported like levelname[40] but 128 in Fitz

WARP_X_  (STAT_ITEMS)

#define STAT_VZOOM_32				32 			// q: why not viewzoom 21?
#define STAT_MAX_HEALTH_33			33 			// 
#define STAT_ACTIVESLOT_34			34
#define STAT_GOLD_35 				35 			// 
#define STAT_XP_36 					36 			// 
#define STAT_CARRYSLOTS_37 			37 			// 
#define STAT_TOOLBITS_38			38 			// Do you have scope?  Flashlight?
#define STAT_TOOLSTATE_39 			39 			// Is flashlight on?  Is nightvision active?  Etc.
#define STAT_REMAIN_AMOUNT_40		40 			// 
#define STAT_TOTAL_AMOUNT_41		41 			// 
#define STAT_PACTION_42				42 			// 
#define STAT_IN_CAMERA_43			43 			// 

#define STAT_WORLD_ATTR_50			50			// WORLD_ATTR_RWATER_1, etc.
#define STAT_WORLD_ATTR_CURSKILL_51	51			// gg_curskill (skill)
#define STAT_WORLD_ATTR_QUESTPOS_52	52 			// to 54

WARP_X_ (IT_LIGHTNING, IT_WEAPONS_MASK_XXX)
#define	IT_PLASMAGUN_128			128
#define	IT_ITEM_256					256

#define WORLD_ATTR_RWATER_1			1			// .levstart.world_attr
#define WORLD_ATTR_NOMETALSTEP_2	2			// for a map with an annoying amt of metal floors for no particular reason
#define WORLD_ATTR_QUEST_TARGET_64	64			// .levstart.world_attr
#define WORLD_ATTR_UINITIALIZED_256	256
#define WORLD_ATTR_SIREN_512		512			// .levstart.world_attr
#define WORLD_ATTR_TRESPASS_1024	1024		// .levstart.world_attr
#define WORLD_ATTR_DEFENSE_2048		2048		// .levstart.world_attr

#define VZOOM_64X					(0.25 / 16)	// 0.03125 //0.0350. 0625//125 		// 
#define VZOOM_32X					(0.25 / 8)	// 0.03125 //0.0350. 0625//125 		// 
#define VZOOM_16X					(0.25 / 4)	// 0.03125 //0.0350. 0625//125 		// 
#define VZOOM_8X					(0.25 / 2)	// 0.03125 //0.0350. 0625//125 		// 
#define VZOOM_4X_0_25				0.25		// 0.03125 //0.0350. 0625//125 		// 
#define VZOOM_NORM_1_0				1.0 		// 

#define DEFAULT_GOLD_60				60	
#define DEFAULT_CARRYSLOTS_18		18			// (16 + 12 FIXED) 
#define DEFAULT_CARRYSLOTS_BASE_12	12			// (16 + 12 FIXED) 
#define DEFAULT_CARRYSLOTS_NORM_6	6			// (16 + 12 FIXED) 
#define DEFAULT_XP_0				0

#define toolbits_none_0				0
#define toolbits_flashlight_256		256
#define toolbits_scope_512			512
#define toolbits_nightvision_1024	1024
#define toolbits_grapple_2048		2048
#define toolbits_hammer_4096		4096
//float	IT_AXE					= 4096;
#define toolbits_vehicle_boat_16384	16384
#define toolbits_vehicle_car_32768	32768
#define toolbits_vehicle_air_65536	65536
#define toolbits_vehicle_mask_xxx	(toolbits_vehicle_boat_16384 + toolbits_vehicle_car_32768 + toolbits_vehicle_air_65536)

#define toolbits_jacker_131072		131072
#define toolbits_sneakers_262144	262144

#define toolbits_carry_more_524288	524288
#define toolbits_carry_tons_1048576	1048576


#define IS_IT_AXE_OR_NONE(e)			isin2 (e.weapon, IT_WEAPON_NONE_0, IT_AXE)
#define IS_IT_AXE_OR_ITEM_OR_NONE(e)	isin3 (e.weapon, IT_WEAPON_NONE_0, IT_AXE, IT_ITEM_256)
#define IS_IN_VEHICLE(e)				(Have_Flag (e.pls_toolstate, toolbits_vehicle_mask_xxx) != 0)
#define IS_IN_VEHICLE_LAND(e)			(Have_Flag (e.pls_toolstate, toolbits_vehicle_car_32768) != 0)
#define IS_IN_VEHICLE_AIR(e)			(Have_Flag (e.pls_toolstate, toolbits_vehicle_air_65536) != 0)

// both_inventory.c
void itemq_init (void);
void itemq_print (void);

#define BUY_PREFIX_PLUS		"+"
#define BUY_LCASE			"buy"

#define SAFE_NUM_ARGC_3 3			// used



// metric trashses
#define boxwidth_56			56
#define tweenwidth_8		8
#define tweencalc(count,w,marg,tween,headxtra) marg + headxtra + (w + tween) * count - tween + marg

#define ikewidth_32			32
#define margsize_x_2		2
#define margsize_y_0		0
#define quan_fsize_20		20
#define tier_fsize_20		20
#define hotbar_btm_8 		8
#define ike_indent			(boxwidth_56-ikewidth_32)/2
#define back_zero_0			0
#define back_solid_2		2
#define player_start_0 		0
#define locker_beyond_100 	100 // add 36

#define locker_start_64 	64
#define locker_beyond_100 	100 // add 36
//#define locker_beyond_128 	locker_beyond_128

#define hotbar_start_0 	 	0
#define hotbar_count_8 		8
#define hotbar_beyond_8 	8

#define wearbar_start_8 	8
#define wear_count_4 		4
#define wearbar_beyond_12	12
#define std_start_12 		12
#define std_count_42 		42 
#define std_beyond_54		54 // abs max?
#define large1_start_54		54
#define large1_beyond_55	55 // 

#define ig_margin_10		10
#define ig_fsize_32_32		'32 32'
#define ig_sfsize_20_20		'20 20'

#define ig_numcols_6		6
#define ig_maxnumrows_7		6

vector	iboxwidth_56_56		= {boxwidth_56, boxwidth_56};

#define ig1_title						"INVENTORY"
#define ig_wearing						"Wearing"
#define ig_wearing_font_size_16_16		'16 16'
#define describe_text_font_size_24_24	'24 24'

#define item_gold_0						0
#define item_apple_10					10
#define item_hammer_77					77

#define itex					ix[it0]
#define itemq_salt(itemx)		itemx.altmame ? itemx.altmame : itemx.human_itemname_a
#define itemq_lookup_idxp1(s)	PLUS1(itemq_lookup_idx(s))

#define storj				storz[j]
#define storj1				storz[js1]
#define storj2				storz[js2]
#define storjdst			storz[jdst]
#define storjsrc			storz[jsrc]
#define storjitem			ix[storj.itemidx]

#define pair_pad_at(pp,ppsrc,pad) \
	pp##_pos.x = ppsrc##_pos.x - pad; \
	pp##_pos.y = ppsrc##_pos.y - pad, \
	pp##_size.x = pad + ppsrc##_size.x + pad; \
	pp##_size.y = pad + ppsrc##_size.y + pad // Ender

//#define vector_pair(pp)	vector pp##_pos, pp##_size
#define pair_size_match(pp,pp2)		(pp##_size[0] == pp2##_size[0] && pp##_size[1] == pp2##_size[1])
#define pair_size_copy(pp,pp2)		pp##_size[0] = pp2##_size[0], pp##_size[1] = pp2##_size[1]
#define pair_set_size_ab(pp,a,b)	pp##_size[0] = a, pp##_size[1] = b
#define pair_set_pos_ab(pp,a,b)		pp##_pos[0] = a, pp##_pos[1] = b

#define pair_pos_x_beyond(pp)		(pp##_pos[0] + pp##_size[0])
#define pair_pos_x_center(pp)		(pp##_pos[0] + pp##_size[0]/2)
#define pair_pos_y_center(pp)		(pp##_pos[1] + pp##_size[1]/2)
#define pair_pos_y_beyond(pp)		(pp##_pos[1] + pp##_size[1])


#define pairion_hit(p,sz,pos) (inrangebeyond(p.x,pos.x,p.x+sz.x) && inrangebeyond(p.y,pos.y,p.y+sz.y))


#define vectron(e) \
		e.box_pos[0]			= e.x;				\
		e.box_pos[1]			= e.y;				\
		e.box_size[0]			= e.w;				\
		e.box_size[1]			= e.h;				\
		e.ike_pos[0]			= e.ike_x;			\
		e.ike_pos[1]			= e.ike_y;			\
		e.ike_size[0]			= e.ike_w;			\
		e.ike_size[1]			= e.ike_h;			\
		e.quan_font_size[0]		= e.quan_fsize1;	\
		e.quan_font_size[1]		= e.quan_fsize1;	\
		e.text_pos[0]			= e.tier_x;			\
		e.text_pos[1]			= e.tier_y;			\
		e.tier_font_size[0]		= e.tier_fsize1;	\
		e.tier_font_size[1]		= e.tier_fsize1	// ender


	WARP_X_(ig1)
	WARP_X_(ig_s)

#define		WEPNUM_AXE_0						0
#define		WEPNUM_SHOTGUN_1					1
#define		WEPNUM_SSHOTGUN_2					2
#define		WEPNUM_NAILGUN_3					3

#define		DEFAULT_SHELLS_25					25
#define		DEFAULT_HEALTH_100					100

#define		PARM_LEVEL_CHANGE_0					0
#define		PARM_LEVEL_CHANGE_1					1	// parm14
#define		ZIRCON_DEFAULT_INV_AXE_GOLD_10		",,,,,,,,,,,,499 gold,2 apple"
#define		ZIRCON_INV_AVAILALBE_COMMA			","
#define		ITEM_MAX_HEALTH_DEFAULT_175			175

#define		ent_it0(e)							UNPLUS1(e.it_itemidxp1)
#define		ent_sv_to_cl_string(capa,mame,e)	sprintf("[%02d %s]%s", capa, mame, e.stored)

#define		INVENTORY_FULL_SOUND				"player/axhit2.wav"
#define		INVENTORY_CANNOT_PAY_SOUND			"actions/break.wav"
#define		INVENTORY_TAKE_SOUND				"actions/leather_inventory.wav"
#define		INVENTORY_FULL_MSG					"Inventory full, drop something first"
#define		INVENTORY_CANNOT_PAY				"Not enough gold to purchase item"
#define		INVENTORY_DO_NOT_HAVE				"You do not have this item to sell"
#define		INVENTORY_CANNOT_RENT				"Not enough gold to rent item"
#define		INVENTORY_BUY_SOUND					"actions/sell_buy_item.wav"

#define		SERVER_ASSERT_SELF_ACTION_ENT(swhy)	server_assert_self_ret_(self.pl_action_ent != world)

#define		PLACER_SUCCESS_SOUND				"player/axhit2.wav"
#define		PLACER_FAIL_SOUND					"actions/break.wav"
#define		EXO_HEAL_SOUND						"zirco/replenish.ogg"

#define		SELL_SOUND							"actions/sell_buy_item.wav"
#define		DROP_DISINTEGRATION_TIME_120		120 // why 2 minutes, vs never?


#define angle_shortest_path_wrap_gt_pos_neg_180(x) \
		if (x[0] >  180)  x[0] -= 360; \
		if (x[1] >  180)  x[1] -= 360; \
		if (x[2] >  180)  x[2] -= 360; \
		if (x[0] < -180)  x[0] += 360; \
		if (x[1] < -180)  x[1] += 360; \
		if (x[2] < -180)  x[2] += 360 //ender


//#define	ZVC_MAP_TITLE_1		1

#define CARD_YAW_TWIST_90	90.0 // not sure why, let's not ask either at this time



