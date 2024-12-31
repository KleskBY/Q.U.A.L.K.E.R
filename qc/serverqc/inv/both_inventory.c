// both_inventory.c
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


typedef enum stackstype {
	stackstype_ncary_0	= 0,
	stackstype_nstak_1	= 1,
	stackstype_stack_2	= 2,	// what is stack limit, if there is one?
	stackstype_tiers_3	= 3,	// tier has durability
};


enum mt_e {
	mt_none_0			=	0,		
	mt_wood_1			=	1,		
	mt_metal_2			=	2,
	mt_metal_3			=	3,
	mt_stone_4			=	4,
	mt_coin_5			=	5,	// does "ring_inventory" on pickup and is auto-take
	mt_package_6		=	6,
	mt_gem_7			=	7,

	mt_wear_head_8		=	8,
	mt_wear_body_9		=	9,
	mt_wear_foot_10		=	10,
	mt_wear_pack_11		=	11,

};

// How does atm, vend fit in?  Maybe it doesn't
enum it_e {
	it_melee_1			=	1,		
	it_ranged_2			=	2,
	it_weap_3_mask		=	3,
// -----------------
	it_ammo_4			=	4,		// stacks
	it_spend_10			=	10,		// stacks
	it_food_11			=	11,		// stacks
//	it_material_12		=	12,		// stacks
	it_med_12			=	12,		// stacks
	it_drink_13			=	13,
//
	it_wearable_20		=	20,		// 
	it_tool_21			=	21,
	it_quest_22			=	22,
////////
	//it_storage_22		=	22,		// chest, locker, vault				func_container ?
	it_readable_31		=	31,
	it_barrier_32		=	32,
	it_world_64			=	64,		// Cannot be damaged

	it_magic_28			=	28,		// Cannot be damaged

	it_treasure_66		=	66,		// Cannot be damaged
	it_ammo_68			=	68,
	it_armor_69			=	69,
	it_rockets_70		=	70,

};


typedef struct {
	// (mum)(str x 3)(mum x 5)(str)
	float	id;
	float	msrp;
	float	dqua;
	string	g_model;	// underscores become spaces
	string	v_model;	// underscores become spaces
	string	thumb_png;	// underscores become spaces

	// stacks, ittype, toolvits, capa, material
	float	stackstype;	// stackstype_nstak_1, stackstype_stack_2, stackstype_tiers_3
	float	it_type;	// it_melee_1, it_ranged_2, it_food_11
	float	toolvits;	
	float	capacity;	// or damage for melee.  For food, health gai.
	float	material;
////
	string	altmame;	// Hmmm

	string	human_itemname_a;	// underscores become spaces
	string	itemname_uscores_a;	// 
	float	claimed;

	
} item_s;

var item_s ix[] = {
	// models/zircon_dynamics/.md3 or .obj
									// carry
		// g model											// v model											// thum														// stackstype_nstak_1  it_melee_1  toolvits capacity  material // alt
{0,		2,		100,	"models/zircon_dynamics/gold.md3",					"models/zircon_dynamics/gold.md3",					"models/zircon_dynamics/gold_thumb.png",					stackstype_stack_2,	it_spend_10,	0,		0,		item_gold_0},
{1,		25,		5,		"models/weapons/g_axe.md3",							"models/weapons/v_axe.md3",							"models/weapons/g_axe_thumb.png",							stackstype_nstak_1,	it_ranged_2,	IT_AXE /*4096*/,0,	0,	0},
{2,		25,		5,		"models/weapons/g_blaster.md3",						"models/weapons/v_blaster.md3",						"models/weapons/g_blaster_thumb.png",						stackstype_nstak_1,	it_ranged_2,	IT_SHOTGUN,				0,	0, "Blaster"},
{3,		500,	1,		"models/weapons/g_supershotgun.md3",				"models/weapons/v_supershotgun.md3",				"models/weapons/g_supershotgun_thumb.png",					stackstype_nstak_1,	it_ranged_2,	IT_SUPER_SHOTGUN,		0,	0, "Heavy Shotgun"},
{4,		200,	1,		"models/weapons/g_nailgun.md3",						"models/weapons/v_nailgun.md3",						"models/weapons/g_nailgun_thumb.png",						stackstype_nstak_1,	it_ranged_2,	IT_NAILGUN,				0,	0, "Nail gun"},
{5,		3000,	1,		"models/weapons/g_uzi.md3",							"models/weapons/v_uzi.md3",							"models/weapons/g_uzi_thumb.png",							stackstype_nstak_1,	it_ranged_2,	IT_SUPER_NAILGUN,		0,	0, "Uzi"},
{6,		3000,	1,		"models/weapons/g_grenadelauncher.md3",				"models/weapons/v_grenadelauncher.md3",				"models/weapons/g_grenadelauncher_thumb.png",				stackstype_nstak_1,	it_ranged_2,	IT_GRENADE_LAUNCHER,	0,	0, "Grenade Launcher"},
{7,		3000,	1,		"models/weapons/g_rocketlauncher.md3",				"models/weapons/v_rocketlauncher.md3",				"models/weapons/g_rocketlauncher_thumb.png",				stackstype_nstak_1,	it_ranged_2,	IT_ROCKET_LAUNCHER,		0,	0, "Rocket Launcher R-999"},
{8,		8000,	1,		"models/weapons/g_lightninggun.md3",				"models/weapons/v_lightninggun.md3",				"models/weapons/g_lightninggun_thumb.png",					stackstype_nstak_1,	it_ranged_2,	IT_LIGHTNING,			0,	0, "Lightning Gun"},
{9,		12000,	1,		"models/weapons/g_plasmagun.md3",					"models/weapons/v_plasmagun.md3",					"models/weapons/g_plasmagun_thumb.png",						stackstype_nstak_1,	it_ranged_2,	IT_PLASMAGUN_128,		0,	0, "Plasma RX-9/Zoom 72x" },
{10,	1,		100,	"models/zircon_dynamics/apple.md3",					"models/zircon_dynamics/apple.md3",					"models/zircon_dynamics/apple_thumb.png",					stackstype_stack_2,	it_food_11,		0,	0,	0},
{11,	1,		100,	"models/zircon_dynamics/banana.md3",				"models/zircon_dynamics/banana.md3",				"models/zircon_dynamics/banana_thumb.png",					stackstype_stack_2,	it_food_11,		0,	0,	0},
{12,	5,		100,	"models/zircon_dynamics/burger.md3",				"models/zircon_dynamics/burger.md3",				"models/zircon_dynamics/burger_thumb.png",					stackstype_nstak_1,	it_food_11,		0,	10,	0, "Cheeseburger"},
{13,	5,		100,	"models/zircon_dynamics/cake_jp.obj",				"models/zircon_dynamics/cake_jp.obj",				"models/zircon_dynamics/cake_jp_thumb.png",					stackstype_nstak_1,	it_food_11,		0,	0,	0},
{14,	1,		100,	"models/zircon_dynamics/can.md3",					"models/zircon_dynamics/can.md3",					"models/zircon_dynamics/can_thumb.png",						stackstype_stack_2,	it_food_11,		0,	0,	0},
{15,	1,		100,	"models/zircon_dynamics/carrot.md3",				"models/zircon_dynamics/carrot.md3",				"models/zircon_dynamics/carrot_thumb.png",					stackstype_stack_2,	it_food_11,		0,	0,	0},
{16,	1,		100,	"models/zircon_dynamics/cookie.md3",				"models/zircon_dynamics/cookie.md3",				"models/zircon_dynamics/cookie_thumb.png",					stackstype_stack_2,	it_food_11,		0,	0,	0},
{17,	1,		100,	"models/zircon_dynamics/donut_sprinkles.md3",		"models/zircon_dynamics/donut_sprinkles.md3",		"models/zircon_dynamics/donut_sprinkles_thumb.png",			stackstype_stack_2,	it_food_11,		0,	0,	0, "Donut"},
{18,	5,		100,	"models/zircon_dynamics/fish.md3",					"models/zircon_dynamics/fish.md3",					"models/zircon_dynamics/fish_thumb.png",					stackstype_stack_2,	it_food_11,		0,	0,	0},
{19,	10,		10,		"models/zircon_dynamics/fish_bones.md3",			"models/zircon_dynamics/fish_bones.md3",			"models/zircon_dynamics/fish_bones_thumb.png",				stackstype_stack_2,	it_food_11,		0,	0,	0},
{20,	5,		100,	"models/zircon_dynamics/fries.md3",					"models/zircon_dynamics/fries.md3",					"models/zircon_dynamics/fries_thumb.png",					stackstype_stack_2,	it_food_11,		0,	0,	0},
{21,	5,		100,	"models/zircon_dynamics/loaf_bread.md3",			"models/zircon_dynamics/loaf_bread.md3",			"models/zircon_dynamics/loaf_bread_thumb.png",				stackstype_nstak_1,	it_food_11,		0,	0,	0},
{22,	3,		100,	"models/zircon_dynamics/pear.md3",					"models/zircon_dynamics/pear.md3",					"models/zircon_dynamics/pear_thumb.png",					stackstype_stack_2,	it_food_11,		0,	0,	0},
{23,	5,		100,	"models/zircon_dynamics/pizza_jp.obj",				"models/zircon_dynamics/pizza_jp.obj",				"models/zircon_dynamics/pizza_jp_thumb.png",				stackstype_stack_2,	it_food_11,		0,	0,	0},
{24,	1,		100,	"models/zircon_dynamics/soda_can.md3",				"models/zircon_dynamics/soda_can.md3",				"models/zircon_dynamics/soda_can_thumb.png",				stackstype_stack_2,	it_drink_13,	0,	0,	0},
{25,	1,		100,	"models/zircon_dynamics/soda_fountain_drink.md3",	"models/zircon_dynamics/soda_fountain_drink.md3",	"models/zircon_dynamics/soda_fountain_drink_thumb.png",		stackstype_stack_2,	it_drink_13,	0,	0,	0},
{26,	10,		10,		"models/zircon_dynamics/stew.md3",					"models/zircon_dynamics/stew.md3",					"models/zircon_dynamics/stew_thumb.png",					stackstype_nstak_1,	it_food_11,		0,	10,	0},
{27,	1,		100,	"models/zircon_dynamics/strawberry.md3",			"models/zircon_dynamics/strawberry.md3",			"models/zircon_dynamics/strawberry_thumb.png",				stackstype_stack_2,	it_food_11,		0,	0,	0},
{28,	8,		100,	"models/zircon_dynamics/turkey.md3",				"models/zircon_dynamics/turkey.md3",				"models/zircon_dynamics/turkey_thumb.png",					stackstype_stack_2,	it_food_11,		0,	0,	0},
{29,	17,		7,		"models/zircon_dynamics/wine_bottle_red.md3",		"models/zircon_dynamics/wine_bottle_red.md3",		"models/zircon_dynamics/wine_bottle_red_thumb.png",			stackstype_stack_2,	it_drink_13,	0,	0,	0},
{30,	17,		7,		"models/zircon_dynamics/wine_bottle_white.md3",		"models/zircon_dynamics/wine_bottle_white.md3",		"models/zircon_dynamics/wine_bottle_white_thumb.png",		stackstype_stack_2,	it_drink_13,	0,	0,	0},
{31,	7000,	1,		"models/zircon_dynamics/potion_blue.md3",			"models/zircon_dynamics/potion_blue.md3",			"models/zircon_dynamics/potion_blue_thumb.png",				stackstype_nstak_1,	it_quest_22,	0,	0,	0, "Liquid Prometheon" },
{32,	7000,	1,		"models/zircon_dynamics/potion_green.md3",			"models/zircon_dynamics/potion_green.md3",			"models/zircon_dynamics/potion_green_thumb.png",			stackstype_nstak_1,	it_magic_28,	0,	0,	0, "Elixir"},
{33,	7000,	1,		"models/zircon_dynamics/potion_red.md3",			"models/zircon_dynamics/potion_red.md3",			"models/zircon_dynamics/potion_red_thumb.png",				stackstype_nstak_1,	it_quest_22,	0,	0,	0, "X-Radium Vial"},
{34,	7000,	1,		"models/zircon_dynamics/potion_solid.md3",			"models/zircon_dynamics/potion_solid.md3",			"models/zircon_dynamics/potion_solid_thumb.png",			stackstype_nstak_1,	it_quest_22,	0,	0,	0, "Vaccuum Energy Fluid"},
{35,	7000,	1,		"models/zircon_dynamics/ring.md3",					"models/zircon_dynamics/ring.md3",					"models/zircon_dynamics/ring_thumb.png",					stackstype_nstak_1,	it_magic_28,	0,	0,	0},
{36,	20,		5,		"models/zircon_dynamics/scroll.md3",				"models/zircon_dynamics/scroll.md3",				"models/zircon_dynamics/scroll_thumb.png",					stackstype_nstak_1,	it_quest_22,	0,	0,	0, "Scroll"},
{37,	25,		3,		"models/zircon_dynamics/ampoule.md3",				"models/zircon_dynamics/ampoule.md3",				"models/zircon_dynamics/ampoule_thumb.png",					stackstype_nstak_1,	it_med_12,		0,	10,	0},
{38,	25,		3,		"models/zircon_dynamics/bottle_01.md3",				"models/zircon_dynamics/bottle_01.md3",				"models/zircon_dynamics/bottle_01_thumb.png",				stackstype_nstak_1,	it_med_12,		0,	10,	0},
{39,	25,		3,		"models/zircon_dynamics/bottle_02.md3",				"models/zircon_dynamics/bottle_02.md3",				"models/zircon_dynamics/bottle_02_thumb.png",				stackstype_nstak_1,	it_med_12,		0,	12,	0},
{40,	25,		3,		"models/zircon_dynamics/first_aid_kit.md3",			"models/zircon_dynamics/first_aid_kit.md3",			"models/zircon_dynamics/first_aid_kit_thumb.png",			stackstype_nstak_1,	it_med_12,		0,	75,	0},
{41,	25,		3,		"models/zircon_dynamics/pill_01.md3",				"models/zircon_dynamics/pill_01.md3",				"models/zircon_dynamics/pill_01_thumb.png",					stackstype_nstak_1,	it_med_12,		0,	15,	0},
{42,	25,		3,		"models/zircon_dynamics/pill_02.md3",				"models/zircon_dynamics/pill_02.md3",				"models/zircon_dynamics/pill_02_thumb.png",					stackstype_nstak_1,	it_med_12,		0,	15,	0},
{43,	25,		3,		"models/zircon_dynamics/pill_03.md3",				"models/zircon_dynamics/pill_03.md3",				"models/zircon_dynamics/pill_03_thumb.png",					stackstype_nstak_1,	it_med_12,		0,	15,	0},
{44,	25,		3,		"models/zircon_dynamics/pill_04.md3",				"models/zircon_dynamics/pill_04.md3",				"models/zircon_dynamics/pill_04_thumb.png",					stackstype_nstak_1,	it_med_12,		0,	15,	0},
{45,	25,		3,		"models/zircon_dynamics/syringe.md3",				"models/zircon_dynamics/syringe.md3",				"models/zircon_dynamics/syringe_thumb.png",					stackstype_nstak_1,	it_med_12,		0,	25,	0},
{46,	500,	1,		"models/zircon_dynamics/binoculars.md3",			"models/zircon_dynamics/binoculars.md3",			"models/zircon_dynamics/binoculars_thumb.png",				stackstype_stack_2,	it_tool_21,		toolbits_scope_512,	2,	0, "Binooculars (32x)"},
{47,	500,	1,		"models/zircon_dynamics/canister_hd.obj",			"models/zircon_dynamics/canister_hd.obj",			"models/zircon_dynamics/canister_thumb.png",				stackstype_nstak_1,	it_tool_21,		0,	2,	0},
{48,	5000,	1,		"models/zircon_dynamics/extinguisher_uhd.obj",		"models/zircon_dynamics/extinguisher_uhd.obj",		"models/zircon_dynamics/extinguisher_uhd_thumb.png",		stackstype_nstak_1,	it_tool_21,		0,	8,	0},
{49,	25,		3,		"models/zircon_dynamics/flashlight.md3",			"models/zircon_dynamics/flashlight.md3",			"models/zircon_dynamics/flashlight_thumb.png",				stackstype_nstak_1,	it_tool_21,		toolbits_flashlight_256,	3,	0},
{50,	25,		3,		"models/zircon_dynamics/knife.md3",					"models/zircon_dynamics/knife.md3",					"models/zircon_dynamics/knife_thumb.png",					stackstype_nstak_1,	it_tool_21,		0,	15,	0},
{51,	25,		3,		"models/zircon_dynamics/opener.md3",				"models/zircon_dynamics/opener.md3",				"models/zircon_dynamics/opener_thumb.png",					stackstype_nstak_1,	it_tool_21,		0,	0,	0},
{52,	10,		3,		"models/zircon_dynamics/pan.md3",					"models/zircon_dynamics/pan.md3",					"models/zircon_dynamics/pan_thumb.png",						stackstype_nstak_1,	it_tool_21,		0,	0,	0},
{53,	10,		3,		"models/zircon_dynamics/plate.md3",					"models/zircon_dynamics/plate.md3",					"models/zircon_dynamics/plate_thumb.png",					stackstype_nstak_1,	it_tool_21,		0,	0,	0},
{54,	10,		1,		"models/zircon_dynamics/scissors.md3",				"models/zircon_dynamics/scissors.md3",				"models/zircon_dynamics/scissors_thumb.png",				stackstype_nstak_1,	it_tool_21,		99,	8,	0},
{55,	1000,	1,		"models/zircon_dynamics/scope.md3",					"models/zircon_dynamics/scope.md3",					"models/zircon_dynamics/scope_thumb.png",					stackstype_nstak_1,	it_tool_21,		toolbits_scope_512,	0,	0, "Scope (32x)"},
{56,	10,		1,		"models/zircon_dynamics/screwdriver.md3",			"models/zircon_dynamics/screwdriver.md3",			"models/zircon_dynamics/screwdriver_thumb.png",				stackstype_nstak_1,	it_tool_21,		0,	3,	0},
{57,	50,		1,		"models/zircon_dynamics/shovel.md3",				"models/zircon_dynamics/shovel.md3",				"models/zircon_dynamics/shovel_thumb.png",					stackstype_nstak_1,	it_tool_21,		0,	10,	0},
{58,	10,		1,		"models/zircon_dynamics/spoon.md3",					"models/zircon_dynamics/spoon.md3",					"models/zircon_dynamics/spoon_thumb.png",					stackstype_nstak_1,	it_tool_21,		0,	0,	0},
{59,	10,		1,		"models/zircon_dynamics/tape.md3",					"models/zircon_dynamics/tape.md3",					"models/zircon_dynamics/tape_thumb.png",					stackstype_stack_2,	it_tool_21,		0,	0,	0},
{60,	5000,	1,		"models/zircon_dynamics/usbstick.md3",				"models/zircon_dynamics/usbstick.md3",				"models/zircon_dynamics/usbstick_thumb.png",				stackstype_nstak_1,	it_tool_21,		toolbits_jacker_131072,	0,	0, "Data State Sensor"},
{61,	20,		1,		"models/zircon_dynamics/wrench.md3",				"models/zircon_dynamics/wrench.md3",				"models/zircon_dynamics/wrench_thumb.png",					stackstype_nstak_1,	it_tool_21,		0,	5,	0},
{62,	5000,	1,		"models/zircon_dynamics/crown.md3",					"models/zircon_dynamics/crown.md3",					"models/zircon_dynamics/crown_thumb.png",					stackstype_nstak_1,	it_treasure_66,	0,	0,	mt_wear_head_8},
{63,	5000,	1,		"models/zircon_dynamics/emerald.md3",				"models/zircon_dynamics/emerald.md3",				"models/zircon_dynamics/emerald_thumb.png",					stackstype_stack_2,	it_treasure_66,	0,	0,	mt_gem_7},
{64,	5000,	1,		"models/zircon_dynamics/gem.md3",					"models/zircon_dynamics/gem.md3",					"models/zircon_dynamics/gem_thumb.png",						stackstype_stack_2,	it_treasure_66,	0,	0,	mt_gem_7},
{65,	5000,	1,		"models/zircon_dynamics/sapphire.md3",				"models/zircon_dynamics/sapphire.md3",				"models/zircon_dynamics/sapphire_thumb.png",				stackstype_stack_2,	it_treasure_66,	0,	0,	mt_gem_7},
{66,	300,	1,		"models/q_items/backpack.md3",						"models/q_items/backpack.md3",						"models/q_items/backpack_thumb.png",						stackstype_nstak_1,	it_wearable_20,	toolbits_carry_more_524288,	0,	mt_wear_pack_11, "BackPack 12 Slot"},
{67,	300,	1,		"models/zircon_dynamics/backpack_heavy.md3",		"models/zircon_dynamics/backpack_heavy.md3",		"models/zircon_dynamics/backpack_heavy_thumb.png",			stackstype_nstak_1,	it_wearable_20,	toolbits_carry_tons_1048576,	0,	mt_wear_pack_11, "Heavy BackPack 18 Slot"},
{68,	800,	1,		"models/zircon_dynamics/boots_uhd.obj",				"models/zircon_dynamics/boots_uhd.obj",				"models/zircon_dynamics/boots_uhd_thumb.png",				stackstype_nstak_1,	it_wearable_20,	toolbits_sneakers_262144,	0,	mt_wear_foot_10, "Nano Quiet Boots"},
{69,	50,		1,		"models/zircon_dynamics/glasses_02_hd.obj",			"models/zircon_dynamics/glasses_02_hd.obj",			"models/zircon_dynamics/glasses_02_hd_thumb.png",			stackstype_nstak_1,	it_wearable_20,	toolbits_nightvision_1024,	0,	mt_wear_head_8, "Nano Disposable Nightvision" },
{70,	5000,	1,		"models/zircon_dynamics/glasses_hd.obj",			"models/zircon_dynamics/glasses_hd.obj",			"models/zircon_dynamics/glasses_thumb.png",					stackstype_nstak_1,	it_wearable_20,	toolbits_nightvision_1024,	0,	mt_wear_head_8, "Nano Nightvision Model 3"},
{71,	1000,	1,		"models/zircon_dynamics/grapple.md3",				"models/zircon_dynamics/grapple.md3",				"models/zircon_dynamics/grapple_thumb.png",					stackstype_nstak_1,	it_wearable_20,	toolbits_grapple_2048,	0,	0, "Mountain Grade Grapple"},
{72,	50, 	50, 	"models/q_items/ammo_box.md3",						"models/q_items/ammo_box.md3",						"models/q_items/ammo_box_thumb.png",						stackstype_nstak_1,	it_ammo_68,		0,	100,	0, "Ammo Box (100 Shells/Spikes)"},
{73,	50, 	50, 	"models/q_items/rockets_box.obj",					"models/q_items/rockets_box.obj",					"models/q_items/rockets_box_thumb.png",						stackstype_nstak_1,	it_rockets_70,	0,	20,		0, "Rockets Box (20)"},
{74,	250, 	5, 		"models/q_items/armor_red_box.obj",					"models/q_items/armor_red_box.obj",					"models/q_items/armor_red_box_thumb.png",					stackstype_nstak_1,	it_armor_69,	0,	200,	0, "Armor Box (200)"},
{75,	250, 	5, 		"models/q_items/armor_blue_box.obj",				"models/q_items/armor_blue_box.obj",				"models/q_items/armor_blue_box_thumb.png",					stackstype_nstak_1,	it_armor_69,	0,	400,	0, "Prometheon-Infused Armor Box (400)"},
{76,	500,	1,		"models/medieval/jar.md3",							"models/medieval/jar.md3",							"models/medieval/jar_thumb.png",							stackstype_nstak_1,	it_quest_22,	0,	2,		0, "Jar"},
{77,	500,	1,		"models/q_items/hammer.md3",						"models/q_items/hammer.md3",						"models/q_items/hammer_thumb.png",							stackstype_nstak_1,	it_tool_21,		toolbits_hammer_4096,	2,		0, "Hammer"},
};  // ix[]


// #define itex					ix[it0]

string g_model_to_item (string s_g_model)
{
	string imame = s_g_model;
	imame = string_fs_strip_extension(imame);
	imame = string_fs_strip_path(imame);
	imame = string_remove_lead(imame, "g_"); // g_axe ->> axe
	imame = string_remove_trail(imame, "_jp");
	imame = string_remove_trail(imame, "_hd");
	imame = string_remove_trail(imame, "_uhd");
	imame = string_replace(imame, "_", " ");

	return imame;
}

string g_model_to_uscores (string s_g_model)
{
	string imame = s_g_model;
	imame = string_fs_strip_extension(imame);
	imame = string_fs_strip_path(imame);
	imame = string_remove_lead(imame, "g_"); // g_axe ->> axe
	imame = string_remove_trail(imame, "_jp");
	imame = string_remove_trail(imame, "_hd");
	imame = string_remove_trail(imame, "_uhd");
	

	return imame;
}

void itemq_init (void)
{	
	for (float it0 = 0; it0 < ix.length; it0 ++) {
		if (itex.claimed) {
			wpr (ftos (it0), " already claimed ",itex.g_model, "v:", itex.itemname_uscores_a);
		}

		// Clean name ...
		// models/zircon_dynamics/glasses_hd.obj			<--- _hd
		// models/zircon_dynamics/extinguisher_uhd.obj		<--- _uhd
		// models/zircon_dynamics/cake_jp.obj				<--- _jp  (J.A.C.K. problem with md3 so we use obj format)

		//string imame = itex.g_model;
		//imame = string_fs_strip_extension(imame);
		//imame = string_fs_strip_path(imame);
		//imame = string_remove_lead(imame, "g_"); // g_axe ->> axe
		//imame = string_remove_trail(imame, "_jp");
		//imame = string_remove_trail(imame, "_hd");
		//imame = string_remove_trail(imame, "_uhd");
		//imame = string_replace(imame, "_", " ");
		string imame = g_model_to_item(itex.g_model);
		string imame2 = string_capital_first_char(imame);
		itex.human_itemname_a = strzone(imame2);

		imame =  string_replace(imame, " ", "_");
		itex.itemname_uscores_a = strzone(imame);

		

		if (cvar("developer")) {
			zpr (itex.g_model, " >> ", imame);
		}

		itex.claimed = true;
		
	} // end for

	//itemq_print ();
}


float itemq_lookup_idx(string s)
{
	for (float it0 = 0; it0 < ix.length; it0++) {
		//if (itex.itemname_a == s) return it0;
		if (itex.itemname_uscores_a == s) return it0;
		
	}
	return not_found_neg1;
}


float itemq_lookup_g_model_idx(string s_g_model)
{
	string s0 = g_model_to_uscores (s_g_model);
	//printvars (s_g_model);
	//printvars (s0);
	return itemq_lookup_idx(s0);
}


void itemq_print (void)
{
	for (float it0 = 0; it0 < ix.length; it0 ++) {
		zpr (sprintf ("%4d | %20s %4d %-25s %-25s %-25s", itex.id, itex.itemname_uscores_a, itex.it_type, itex.g_model, itex.v_model, itex.thumb_png) );
	} // end for
}

WARP_X_(itemq_lookup_idx)


// inventory_server.c has server only stuff

string salt_magic_idx(float it0)
{
	if (StrExists(itex.altmame)) {
		return itex.altmame;
	}
	return itex.human_itemname_a;
}

float item1_isgettable(float idxp1)
{
	//zpr ("item1_isgettable");
	//printvarf (idxp1);
	
	if (idxp1 == 0) return false; // can't get unknown thing
	assert (inrangebeyond(0, UNPLUS1(idxp1), ix.length));

	float it0 = UNPLUS1(idxp1);
	if (itex.it_type <= it_tool_21) return true;
	return true;
}

//
// item1 functions are required to be hardened against receiving 0, which is invalid
//
WARP_X_ (slotdropex)
WARP_X_ (item_nova)
float item1_ispackage(float idxp1)
{
	if (idxp1 == 0) return false; // can't get unknown thing
	assert (inrangebeyond(0, UNPLUS1(idxp1), ix.length));

	float it0 = UNPLUS1(idxp1);
	
	if (itex.material == mt_package_6) return true;
	return false;
}

float item1_isautotake(float idxp1)
{
	if (idxp1 == 0) return false; // can't get unknown thing
	assert (inrangebeyond(0, UNPLUS1(idxp1), ix.length));

	float it0 = UNPLUS1(idxp1);
	
	if (it0 == item_gold_0) return true;
	if (itex.it_type == it_treasure_66) return true; // err sure!
	return false;
}
  

// this is stored in e.noise, must not be random or sprintfed as we do not use StrSet
WARP_X_ ()
string item1_pickupnoise(float idxp1)
{
	//printvarf (idxp1);
	//printvarf (ix.length);
	if (idxp1 == 0) return false; // can't get unknown thing
	assert (inrangebeyond(0, UNPLUS1(idxp1), ix.length));

	float it0 = UNPLUS1(idxp1);
	//printvarf (it0);
	//printvarf (itex.material);
	if (it0 == item_gold_0)			{ return "actions/ring_inventory.wav"; }
	if (itex.material == mt_gem_7)	{ return "100_CC0/hammer_02.ogg";	}
	
	return "actions/cloth_inventory.wav";
}

//float item1_maxhealth(float idxp1)
//{
//	if (idxp1 == 0) return ITEM_MAX_HEALTH_DEFAULT_175; // can't get unknown thing
//	assert (inrangebeyond(0, UNPLUS1(idxp1), ix.length));
//	float it0 = UNPLUS1(idxp1);
//	return itex.capacity;
//}
//
