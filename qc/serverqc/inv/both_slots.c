// both_slots.c
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


WARP_X_(ix)
WARP_X_(itemq_init)

//typedef struct {
//	float left, top, width, height;
//} rect_s;

// a geveric slot 0 could e player or a chest or a locker, etc.
	#define startj_for(x) ((x) ? LOCKER_ITEMS_START_64 : 0)
	#define beyond_for(x) (x ? (LOCKER_ITEMS_START_64 * 2) : LOCKER_ITEMS_START_64)

typedef struct {
	float	itemidx;		// for fast access
	float	quan_tier;		// must e 1 or greater
	float	dur;			// 0 to 100 or -1
	float	istackstype;	// 0 (no carry), stacks, tiers (never stacks)
// -------


#ifndef ZIRCON_SERVER
	string	s_a;
	float	slen;
	float	sx;
	float	sy;
// -------
	float	x;
	float	y;
	float	w;
	float	h;

	float	ike_x;
	float	ike_y;
	float	ike_w;
	float	ike_h;

	float	quan_x;
	float	quan_y;
	float	quan_fsize1;

	float	tier_x;
	float	tier_y;
	float	tier_fsize1;
	
	vector	text_pos;		// for?
	vector	atext_pos;		// for?
	string	as_a;

	vector	box_pos;
	vector	box_size;
	vector	ike_pos;
	vector	ike_size;
	vector	quan_font_size;
	vector	tier_font_size;

#endif //! ZIRCON_SERVER

} slot_s;


WARP_X_ (paction_searchy)
WARP_X_ (item_container)

slot_s storz[MAX_ITEMS_SLOTS_64 * 2 + 1]; // 128 acts as a temp
string s_item_strings_a[MAX_ITEMS_SLOTS_64];
var float s_item_strings_count = 0;


string join_s_item_strings_a(float count)
{
	string s = "";
	for (float j = 0; j < count; j ++) {
		switch (j) {
		case 0:		s = s_item_strings_a[j];					break;
		default:	s = strcat(s, ",", s_item_strings_a[j]);	break;
		} // switch
	} // for
	return s;
}

float split_comma_s_item_strings_a_argc(string s)
{
	s_item_strings_count = 0;
	float argc = tokenizebyseparator(s, ","); // separator is discarded

	//zpr ("split_comma_s_item_strings_a_argc ", QUOTED(s), " # it is", ftos(argc));
	
	// 1. Comma parse
	for (float n = 0; n < argc; n ++) {
		if (n >= MAX_ITEMS_SLOTS_64) {	wpr ("Stored exceeding maxlines ", ftos(MAX_ITEMS_SLOTS_64) );  break; }
		StrSet(s_item_strings_a[n], argv(n)); s_item_strings_count++;
		//zpr ("# ", ftos(n), QUOTED(s_item_strings_a[n]) );
	}
	return argc;
}

float slotisempty(float j)
{
	return (storj.itemidx == slot_empty_neg1);	
}

float slotissame(float js1, float js2)
{
	return (js1 == js2);
}

// for stacking
float slotissameitem(float js1, float js2)
{
	return (storj1.itemidx == storj2.itemidx);
}

void _slotclear(float j)
{
	storj.itemidx		= slot_empty_neg1;
	storj.quan_tier		= 1;
	storj.dur			= dur100;
	storj.istackstype	= stackstype_ncary_0;
}

void _slots_clear(float is_locker)
{
	float startj = startj_for(is_locker), beyond = beyond_for(is_locker);

	for (float j = startj; j < beyond; j ++) {
		_slotclear (j);
	} // storz
	
	s_item_strings_count = 0;
}

// 8 to 11 are prohivited --- only certain can go there.
// 0 to 7 try to be for guns?
// 6 callers
WARP_X_ (TAKER)

// player .. disallow slots 8 thru 11

// is_manual_move does nothing and we wouldn't call this for a manual_move
float slotfindbestidx(float islocker, float it0, float cap, float is_manual_move)
{
//	float is_wep = itex.it_melee_1;
//	float is_hel = .toolvits, toolbits_nightvision_1024;
//	float is_arm = toolbits_armor_8192;
//	float is_fot = toolbits_sneakers_262144;
//	float is_ack = toolbits_carry_more_524288;

	//printvarf (is_manual_move);

	float startj = startj_for(islocker/*is_player_0*/), beyond = beyond_for(islocker);
	beyond = startj + cap;
	float doesstack = itex.stackstype == stackstype_stack_2;

	// find a stack
	if (doesstack) {
		for (float j = startj; j < beyond; j ++) {
			if (storj.itemidx == it0) return j;
		} // for
	} // stacks

	// If weapon, try to put in favorite spot
	if (islocker == is_player_0 && inrange(1, it0, 9)) {
		float fav; // ng and lightning are not going to be much used.
		fav = 0; if (it0 == 1) { if (storz[fav].itemidx == slot_empty_neg1)  return fav; }		// 0 axe
		fav = 1; if (it0 == 2) { if (storz[fav].itemidx == slot_empty_neg1)  return fav; }		// 1 blaster
		fav = 2; if (it0 == 3) { if (storz[fav].itemidx == slot_empty_neg1)  return fav; }		// 2 ssg
		fav = 3; if (it0 == 9) { if (storz[fav].itemidx == slot_empty_neg1)  return fav; }		// 3 plasma
		fav = 4; if (it0 == 5) { if (storz[fav].itemidx == slot_empty_neg1)  return fav; }		// 5 uzi
		fav = 5; if (it0 == 6) { if (storz[fav].itemidx == slot_empty_neg1)  return fav; }		// 6 gl
		fav = 6; if (it0 == 7) { if (storz[fav].itemidx == slot_empty_neg1)  return fav; }		// 7 rl
	}

	// If wearable, try to put in favorite spot
	if (islocker == is_player_0 && inrange(mt_wear_head_8, itex.material, mt_wear_pack_11)) {
		// Try to put in favorite spot
		if (storz[itex.material].itemidx == slot_empty_neg1)
			return itex.material;
	}

//	// Try put weapon on hotbar?
//	if (islocker == is_player_0 && inrange(1, it0, 9)) {
//
//	}

	// find empty - disallow wep slot
	if (islocker == is_player_0) {
		for (float j = startj + mt_wear_head_8; j < beyond; j ++) {
			if (storj.itemidx != slot_empty_neg1) continue;
			// Perhaps ...
			if (inrange(mt_wear_head_8 /*wearbar_start_8*/, j, mt_wear_pack_11)) {
				// Deny item in special slot
				if (itex.material !=  j) continue;
			}
			return j;
		} // for
	}

	// find empty - any slot
	for (float j = startj; j < beyond; j ++) {
		if (storj.itemidx != slot_empty_neg1) continue;
		return j;
	} // for

	return slot_empty_neg1; // no room
}

void _slotswap(float js1, float js2)
{
	#define tempx	storz[LOCKER_TEMP_SLOT_128]

	_slotclear(LOCKER_TEMP_SLOT_128);

	tempx.itemidx		= storj1.itemidx;		// for fast access
	tempx.quan_tier		= storj1.quan_tier;	// must e 1 or greater
	tempx.dur			= storj1.dur;			// 0 to 100 or -1

	storj1.itemidx		= storj2.itemidx;		// for fast access
	storj1.quan_tier	= storj2.quan_tier;	// must e 1 or greater
	storj1.dur			= storj2.dur;			// 0 to 100 or -1

	storj2.itemidx		= tempx.itemidx;		// for fast access
	storj2.quan_tier	= tempx.quan_tier;		// must e 1 or greater
	storj2.dur			= tempx.dur;			// 0 to 100 or -1

	#undef tempx
}

void _slotcopy(float jdst, float jsrc)
{
	storjdst.itemidx	= storjsrc.itemidx;		// for fast access
	storjdst.quan_tier	= storjsrc.quan_tier;	// must e 1 or greater
	storjdst.dur		= storjsrc.dur;			// 0 to 100 or -1
}

// add
void _slotaddquan(float j, float quan)
{
	storj.quan_tier += quan;
}

void _slotfillitemquan(float j, float it0, float quan) // not used yet
{
	_slotclear(j);

	storj.itemidx	= it0;		// for fast access
	storj.quan_tier	= quan;		// must e 1 or greater
	storj.dur		= dur100;
}

void _slotfromstring(float j, string s)
{
	float spaced_argc = tokenizebyseparator(s, " "); // separator is discarded
	
	if (spaced_argc > 3) wpr("Unusual amount of spaced args > 3 for ", s, " is ", ftos(spaced_argc) ); 
	spaced_argc = bound(0, spaced_argc, 3);

	float did_name = false;
	float it0 = not_found_neg1;
		
	// 3. spaced args
	//zpr ("_slotfromstring argc ", ftos(spaced_argc), "src:", QUOTED(s));  //zpr ("_slotfromstring ", ftos(k), " parm ", QUOTED(sparm) );
	for (float k = 0; k < spaced_argc; k ++) {
		string sparm = argv(k);
				
		if (StrExists(sparm)==false) {
			wpr ("s2slots ignored a empty token ", QUOTED(sparm), " at ", ftos(k) ); //ignore
			continue;
		}

		// 0-9 - numeric
		if  (string_is_numeric(sparm)) {
			if (k==0) { storj.quan_tier	= stof(sparm); }
			else	  {	storj.dur		= stof(sparm); }
			continue;
		} // if digit

		// must be name
		if (did_name) {
			wpr ("did name already so ignoring this parm-> ", QUOTED(sparm));
			continue;
		}

		it0 = itemq_lookup_idx(sparm);
		
		if (it0 == not_found_neg1) { errox ("item ", QUOTED(sparm), " not_found"); }
		
		storj.itemidx		= it0;
		storj.istackstype	= itex.stackstype;
		did_name = true;
	} // for spaced attr
	// chk
	//if (storj.dur == dur100_neg1)	storj.dur = 100;
	//storj.dur = bound(0,storj.dur,100);

	storj.quan_tier = bound(1,storj.quan_tier,99999);
}

// Mar 19 2022 "stored" ",flashlight,can,2 apple,10 gold,5 axe 100"


string _slotstring(float j)
{
	if (storj.itemidx == slot_empty_neg1) { 
		return ""; 
	}
	float it0 = storj.itemidx;
	
	string sout = sprintf("%d %s %d", storj.quan_tier, itex.itemname_uscores_a, storj.dur);
	return sout;
}

//"stored" ",flashlight,can,2 apple,10 gold,5 axe 100"
string slots2string(float is_locker)
{
	string sout = "";
	float startj = startj_for(is_locker), beyond = beyond_for(is_locker);
	
	s_item_strings_count = 0;
	float hi_item_string = -1; // used to cap
	for (float n = 0; n < MAX_ITEMS_SLOTS_64; n ++) {
		float j = startj + n;

		string sc =_slotstring(j);
		StrSet(s_item_strings_a[s_item_strings_count], sc); s_item_strings_count++;

		if (storj.itemidx == slot_empty_neg1) {
			if (hi_item_string == -1)
				hi_item_string = n;
			
		} else {
			hi_item_string = -1;
		}
	} // for

	//printvarf (hi_item_string);
	float numslots_2pack = hi_item_string;
	sout = join_s_item_strings_a(numslots_2pack);
//	zpr (s_who, " contains ", ftos(storz_count), " items from " QUOTED(s_stored) );
	//printvars (sout);
	return sout;
} // string slots2string


float string2slots(float is_locker, string s_stored)
{
	_slots_clear(is_locker);
	//zpr ("string2slots", QUOTED(s_stored));
	
	float startj = startj_for(is_locker), beyond = beyond_for(is_locker);
	
	// Mar 19 2022 "stored" ",flashlight,can,2 apple,10 gold,5 axe 100"
	// Comma split	
	float comma_argc = split_comma_s_item_strings_a_argc(s_stored);
	if (comma_argc > MAX_ITEMS_SLOTS_64) {
		errox ("string2slots too many comma tokens ", ftos(comma_argc), " limit ", ftos(MAX_ITEMS_SLOTS_64) ) ;
	}

	// 2. comma parse 
	for (float j = 0; j < comma_argc; j ++) {
		//zpr("split # ", ftos(j), " ", QUOTED(s_item_strings_a[j]) );
		if (StrExists(s_item_strings_a[j])==false)
			continue; // blank slots are ok but we do not parse them
		float js = j + startj;
		_slotfromstring(js, s_item_strings_a[j]);
	} // for comma items

//	zpr (s_who, " contains ", ftos(storz_count), " items from ", QUOTED(s_stored) );
	return true;
} // float string2slots

