// slots_server.c

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

WARP_X_ (string2slots)


// makes sure a slot is 0-127 range
// and within allowed capacity (LOCKER_MAX_CARRY_18)
// slotvalidate(a,plyr.pls_carryslotz,LOCKER_MAX_CARRY_18)
float slotvalidatelockerwithcarry(float jsx, float pcap, float lcap)
{
	float is_ok = ispossibleslot(jsx); // fails if outside 0-127
	if (!is_ok) { errox("slot outside 0-127", ftos(jsx) ); return false; }

	// these check capacity
	if (islockerzone(jsx)) {
		return (is_ok = inrangebeyond (LOCKER_ITEMS_START_64, jsx, LOCKER_ITEMS_START_64 + lcap));
	}
	
	// player zone
	return (is_ok = inrangebeyond (0, jsx, pcap));
}

// regular inventory must not call this because this allows locker slots and locker is undefined if not in locker
// and we unpack locker, return dirty flags
WARP_X_ (TAKER)
float storslotswap_wedirty(entity plyr, float js1, float js2)
{
	// zpr ("storslotswap_wedirty");

	// LOCKER IS OPTIONAL HERE
	if (slotissame(js1,js2)) return false;

	// determine what to unpack
	float mix = 0; //printvarf (mix);
	if (islockerzone(js1)) { Flag_Add_To(mix, STOR_LOCKER_DIRTY_2);} else {Flag_Add_To(mix, STOR_PLAYER_DIRTY_1);}
	if (islockerzone(js2)) { Flag_Add_To(mix, STOR_LOCKER_DIRTY_2);} else {Flag_Add_To(mix, STOR_PLAYER_DIRTY_1);}

	if (Have_Flag(mix,STOR_LOCKER_DIRTY_2) && !plyr.pl_action_ent) errox ("storslotswap_wedirty: no locker");

	// unpack player, locker
	if (Have_Flag(mix,STOR_PLAYER_DIRTY_1)) { string2slots(is_player_0,	plyr.stored);    }
	if (Have_Flag(mix,STOR_LOCKER_DIRTY_2)) { string2slots(is_locker_1, plyr.pl_action_ent.stored);  }

	// no locker until unpack is done
	entity elocker = plyr.pl_action_ent; float locker_cappa = 0; if (elocker) locker_cappa = ent_locker_capacity(elocker);
	
	if (slotvalidatelockerwithcarry(js1,plyr.pls_carryslotz,locker_cappa)==false) { wpr ("storslotswap invalid src idx", ftos(js1) ); return false;}
	if (slotvalidatelockerwithcarry(js2,plyr.pls_carryslotz,locker_cappa)==false) { wpr ("storslotswap invalid dst idx", ftos(js2) ); return false;}

	// cannot check for empty without unpack
	if (slotisempty(js1)) { wpr ("storslotswap src idx has -1 no item", ftos(js1)); return false;} // cannot have empty source slot

	// stack accum check
	float issame = (storj1.itemidx == storj2.itemidx);
	if (issame) {
		float it0 = storj1.itemidx;
		float doesstack = itex.stackstype == stackstype_stack_2;
		if (doesstack) {
			float q = storj1.quan_tier;
			_slotaddquan	(js2, q); // jsx2 is dest, add the qua
			_slotclear 		(js1); // js1 is src, clear it
			goto did_stackaccum;
		}
	}

	// perform swap
	_slotswap (js1, js2);

did_stackaccum:
	// repack player, locker
	string snew;
	if (Have_Flag(mix,STOR_PLAYER_DIRTY_1)) { pb(plyr); snew = slots2string(is_player_0); StrSet (plyr.stored, snew);  }
	if (Have_Flag(mix,STOR_LOCKER_DIRTY_2)) { snew = slots2string(is_locker_1); StrSet (elocker.stored, snew);}

	// feedback
	sound(plyr, CHAN_VOICE, INVENTORY_TAKE_SOUND, 1, ATTN_NORM);
	
	// dirty
	if (Have_Flag(mix,STOR_PLAYER_DIRTY_1)) Flag_Add_To (plyr.pl_stored_dirty, STOR_PLAYER_DIRTY_1);
	if (Have_Flag(mix,STOR_LOCKER_DIRTY_2)) Flag_Add_To (plyr.pl_stored_dirty, STOR_LOCKER_DIRTY_2);

	return mix;
}

WARP_X_CALLERS_ (slotdropex, pb, perform_throw_drop)

void dropped_contentstransition (float old_contents, float cur_contents)
{
	//zpr ("Crossed into lava ", etos(self), " ", self.classname);
	string salt = ent_bestname(self);

	if (cur_contents == CONTENT_LAVA /*self.classname == "item_dropped"*/) {
		zpr ("An item -- ", salt, " -- has disintegrated in lava");
		remove (self);
	}

}


void perform_drop_inv_upacked (entity plyr, float j, float quan, float velx)
{		
	float it0				= storj.itemidx;

	entity edrop			= spawn (); // DROP
	edrop.classname			= "item_dropped";
	edrop.contentstransition= dropped_contentstransition;

	edrop.itemname			= itex.itemname_uscores_a;
	edrop.it_itemidxp1		= PLUS1(it0);

	Flag_Add_To (edrop.effects,	 EF_NOMODELFLAGS);

	string s_contents		= _slotstring(j);
	StrSet (edrop.stored,s_contents); // may contain level and durability (or stack means quan) or specialid in future?

	edrop.owner				= edrop;
	edrop.who_dropped_ent1	= plyr;
	edrop.origin			= plyr.origin + '0  0 12';

	edrop.flags				= 0;//FL_ITEM;
	edrop.solid				= SOLID_BBOX;
	edrop.movetype			= MOVETYPE_BOUNCE;
	edrop.avelocity			= '0 300 0';
	edrop.item_amount		= quan;

	makevectors (plyr.v_angle);

	if (plyr.v_angle_x) {
		if (velx) {
			edrop.velocity = v_forward*(300*velx) + v_up * 10 + crandom()*v_right*10 + crandom()*v_up*10; // throw
		} else {
			edrop.velocity = v_forward * 100 + v_up * 100 + crandom()*v_right*100 + crandom()*v_up*100; // drop
		}
	}
	else
	{
		edrop.velocity	= aim(plyr, 10000);
		if (velx) {
			edrop.velocity	= edrop.velocity * 300 * velx; // throw
		} else {
			edrop.velocity = edrop.velocity * 600; // drop
		}
		edrop.velocity_z = 10;
	}

	edrop.velocity += plyr.velocity;
	
	edrop.angles		= vectoangles(edrop.velocity);  edrop.angles_x = edrop.angles_z = 0; // for collidable items we only want yaw spin

	if (!edrop.noise && item1_isgettable(edrop.it_itemidxp1))	edrop.noise = item1_pickupnoise(edrop.it_itemidxp1);
	if (edrop.noise)											precache_sound (edrop.noise);
	
	// attempt by me to take item size into account, must be after setmodel so size is done
	
	// we have no idea of model sizes
	edrop.origin  += normalize(v_forward) * (edrop.size / 2); 
	setorigin		(edrop, edrop.origin);

	precache_model	(itex.g_model);
	setmodel		(edrop, itex.g_model);

	WARP_X_ (RestoreGame)
	Flag_Add_To (edrop.spawnflags, SPAWNFLAGS_ITEM_PRECAcHE_16); // 

	//zpr ("exitor");
	NextThink_Set (edrop, SUB_Remove, time + DROP_DISINTEGRATION_TIME_120); //NEXTTHINK_NEVER_ZERO; // edrop.nextthink = time + 120;
}



float deplete_item_unpack_re_is_gone (entity plyr, float j, float quan)
{
	// unpack player, locker
	string2slots(is_player_0,	plyr.stored);

//	float j   = plyr.pls_activeslot;
	float it0 = plyr.qr[j];
	

	float doesstack = itex.stackstype == stackstype_stack_2;
	float is_gone = true;
	if (doesstack && storj.quan_tier > 1) {
		_slotaddquan (j, -1);
		is_gone = false;
	} else {
		_slotclear	(j);
	}

	// repack player, locker
	string snew;
	pb(plyr); snew = slots2string(is_player_0); StrSet (plyr.stored,snew);

	// dirty
	Flag_Add_To (plyr.pl_stored_dirty, STOR_PLAYER_DIRTY_1);	

	return is_gone;
}

void perform_throw_drop (entity plyr, float j, float velx)
{
	float quan_1 = 1;

	// unpack player, locker
	string2slots(is_player_0,	plyr.stored);

	// perform drop
	perform_drop_inv_upacked (plyr, j, quan_1, velx);

	// deplete
	float is_gone = deplete_item_unpack_re_is_gone (plyr, j, quan_1);

	// feedback
	sound(plyr, CHAN_VOICE, "actions/jumpland.wav", 1, ATTN_NORM);

	// We are hotbar / pls_active_slot
	if (plyr.weapon == IT_ITEM_256 && is_gone) {
		plyr.weapon = W_BestWeaponHotbar_IT_bit();
		OSelf_Push_Set_Temp (oself, plyr);
			W_SetCurrentAmmo ();
		OSelf_Pop (oself);
	} // isgone

}


void pb (entity plyr)
{
	float j;
	float oldcap = plyr.pls_carryslotz;
	
	plyr.pls_toolbits = 0; // e.pls_toolstate is field with vehicles
	float mygold;
	for (j = 0; j < plyr.pls_carryslotz; j ++) {
		float it0 = storj.itemidx;

		if (it0 == item_gold_0)			mygold += storj.quan_tier;
		else {
			if (it0 >= 0) {
				switch (itex.toolvits) {
				default: break;

					// These must slot 1 to 8 to matter ...
				case IT_AXE:
				case IT_SHOTGUN:
				case IT_SUPER_SHOTGUN:
				case IT_NAILGUN:
				case IT_SUPER_NAILGUN:
				case IT_GRENADE_LAUNCHER:
				case IT_ROCKET_LAUNCHER:
				case IT_LIGHTNING:
				case IT_PLASMAGUN_128:
					if (j < hotbar_beyond_8) { Flag_Add_To (plyr.pls_toolbits, itex.toolvits); } 
					break;

				case toolbits_flashlight_256:
				case toolbits_scope_512:
				case toolbits_jacker_131072:
				case toolbits_grapple_2048:
					Flag_Add_To (plyr.pls_toolbits, itex.toolvits);
					
					break;

				// Restricted
				case toolbits_nightvision_1024:
					if (j == mt_wear_head_8) { Flag_Add_To (plyr.pls_toolbits, itex.toolvits); } 
					break;

				case toolbits_sneakers_262144:
					if (j == mt_wear_foot_10) { Flag_Add_To (plyr.pls_toolbits, itex.toolvits); } 
					break;

				case toolbits_carry_more_524288:
				case toolbits_carry_tons_1048576:
					if (j == mt_wear_pack_11) { Flag_Add_To (plyr.pls_toolbits, itex.toolvits); } 
					break;

				}
			}
		}

	}
	plyr.pls_gold = mygold;
	plyr.pls_carryslotz = DEFAULT_CARRYSLOTS_BASE_12 + DEFAULT_CARRYSLOTS_NORM_6;
	if (Have_Flag (plyr.pls_toolbits,toolbits_carry_more_524288))    plyr.pls_carryslotz = DEFAULT_CARRYSLOTS_BASE_12 + DEFAULT_CARRYSLOTS_NORM_6 + 12;
	if (Have_Flag (plyr.pls_toolbits,toolbits_carry_tons_1048576))   plyr.pls_carryslotz = DEFAULT_CARRYSLOTS_BASE_12 + DEFAULT_CARRYSLOTS_NORM_6 + 18;
	
	
	if (plyr.pls_carryslotz < oldcap) {
		// Must drop stuff
		float drops;
		
		for (j = plyr.pls_carryslotz; j < oldcap; j ++) {
			if (storj.itemidx == slot_empty_neg1 ) continue;

			if (!drops) {
				spr (plyr, "Reduced carry capacity, must drop some ...");
			}
			drops ++;
			float it0		= storj.itemidx;
			float quan_all	= storj.quan_tier;
			spr (plyr, "Dropping ", itex.human_itemname_a );
			perform_drop_inv_upacked (plyr, j, quan_all, /*vel*/ 0);

			// remove
			_slotclear	(j);
		}

	}

	// Quick reference
	for (j = hotbar_start_0; j < wearbar_beyond_12; j ++) {
		plyr.qr[j] = storj.itemidx;
	}

	plyr.qemptowep = not_found_neg1;
	for (j = 0; j < plyr.pls_carryslotz; j ++) {
		if (storj.itemidx == slot_empty_neg1 ) {
			plyr.qemptowep = j; 
			continue;
		}
	}

	//printvarf (plyr.pls_toolbits);
}


// CMD_ubuy - requires vend
float slotbuy_already_asserted_vend(entity plyr, float j, float cec_it0) // switches container
{
	assert (j >= LOCKER_ITEMS_START_64);
	assert (j < 128);
	entity elocker = plyr.pl_action_ent;
	assert(elocker != world); // this cannot trigger, caller already checked

	// unpack player, locker
	string2slots(is_player_0,	plyr.stored);
	string2slots(is_locker_1,	plyr.pl_action_ent.stored);

	float locker_cappa = 64; //ent_locker_capacity(elocker);

	if (slotvalidatelockerwithcarry(j,plyr.pls_carryslotz,locker_cappa) == false) { wpr ("slotget invalid src idx", ftos(j) ); return false;}	

	if (storj.itemidx == slot_empty_neg1) { wpr ("slotbuy: src is empty slot j", ftos(j) ); return false;}
	float it0 = storj.itemidx;

	if (cec_it0 != it0) { wpr ("slotbuy: it0 and expected mismatch", ftos(j) ); return false;}

	float fcost = storj.dur;
	//printvarf (j);
	//printvars (itex.human_itemname_a);
	//printvarf (storj.quan_tier);
	//printvarf (storj.dur); 
	//printvarf (self.pls_gold);
	float can_pay = self.pls_gold >= fcost;

	if (can_pay == false) {
		spr (plyr, INVENTORY_CANNOT_PAY," "  , salt_magic_idx(it0), " costs ", ftos(fcost)  ); 
		sound(plyr, CHAN_AUTO, INVENTORY_CANNOT_PAY_SOUND, 1, ATTN_NORM);
		return false;
	}

	float islockerishsrc	= islockerzone(j);
	float desttype			= islockerishsrc ? is_player_0 : is_locker_1; // need the other as dest
	float destcap			= desttype ? locker_cappa : plyr.pls_carryslotz;
	float jdst				= slotfindbestidx(desttype, it0, destcap, true);
	
	// -1 fail, stacks or not stacks
	if (jdst == slot_empty_neg1) {
		spr (plyr, INVENTORY_FULL_MSG); sound(plyr, CHAN_AUTO, INVENTORY_FULL_SOUND, 1, ATTN_NORM);
		return false;
	}

	float issame		= (storj.itemidx == storjdst.itemidx);
	float doesstack		= itex.stackstype == stackstype_stack_2;

	if (doesstack && issame)	_slotaddquan	(jdst, 1 /*storj.quan_tier*/); // diff
	else {
		_slotcopy		(jdst, j); // TROU!!!
		storz[jdst].quan_tier = 1;
		storz[jdst].dur = 100;
	}

	storj.quan_tier --;
	if (storj.quan_tier <= 0) {
		_slotclear (j);
	}

	//float it0			= itemq_lookup_idx(s_of_item);
	slotsremoveamount(is_player_0, item_gold_0, plyr.pls_carryslotz, fcost);

	// repack player, locker
	string snew;
	pb(plyr); snew = slots2string(is_player_0); StrSet (plyr.stored, snew);
	snew = slots2string(is_locker_1); StrSet (elocker.stored, snew);
		
	// dirty
	Flag_Add_To (plyr.pl_stored_dirty, STOR_PLAYER_DIRTY_1);
	Flag_Add_To (plyr.pl_stored_dirty, STOR_LOCKER_DIRTY_2);

	// feedback
	sound(plyr, CHAN_VOICE, INVENTORY_BUY_SOUND, 1, ATTN_NORM);

	return true;
}

float findplyrit0 (float it0)
{
	for (float j = 0; j < MAX_ITEMS_SLOTS_64; j ++ ) {
		if (storj.itemidx == slot_empty_neg1)
			continue;

	}
}

string slotsellgen (entity plyr, string s_seller_stored) // switches container
{
	// unpack player, locker
	string2slots(is_player_0,	plyr.stored);
	string2slots(is_locker_1,	s_seller_stored);

	for (float n = 0; n < MAX_ITEMS_SLOTS_64; n ++ ) {
		float j = n + MAX_ITEMS_SLOTS_64;

		if (storj.itemidx == slot_empty_neg1)
			continue;

		float it0	= storj.itemidx;

		float jdst	= not_found_neg1;
		//printvarf (it0);
		for (float js2 = 0; js2 < MAX_ITEMS_SLOTS_64; js2 ++ ) {
			if (storj2.itemidx != it0)
				continue;

			if (storj2.quan_tier == 0) // can this happen?
				continue;

			//zpr ("it0 ", ftos(it0), "found i pl slot ", ftos (js2) );

			jdst = js2;
		}
		//zpr ( (jdst == not_found_neg1) ? "you have" : "no have");
		storj.quan_tier = (jdst == not_found_neg1)? 22 : 33;
	} // j, n

	string s = slots2string(is_locker_1);
	//zpr (s);
	return s;
}


// CMD_ubuy - requires vend
WARP_X_ ()
float slotsell_already_asserted_vend(entity plyr, float j, float it0) // switches container
{
//	assert (j >= LOCKER_ITEMS_START_64);
//	assert (j < 128);
	entity elocker = plyr.pl_action_ent;
	assert(elocker != world); // this cannot trigger, caller already checked

	// unpack player, locker
	string2slots(is_player_0,	plyr.stored);
	string2slots(is_locker_1,	plyr.pl_action_ent.stored);

	// TR
		
		float gold_idx = slotfindbestidx(is_player_0, item_gold_0, plyr.pls_carryslotz, /*is_manual_move*/ false);
		//float pawn_idx = slotfindbestidx(is_locker_1, it0, 64, /*is_manual_move*/ false);
		float is_pawn_slot_this_it0 = storj.itemidx == it0;
//		zpr ("slotsell");
//		printvarf (pawn_idx);
//		printvarf (pawn_idx);
		if (is_pawn_slot_this_it0 == false) {
			spr (plyr, "The sales index does not match sellers record" ); 
			sound(plyr, CHAN_AUTO, INVENTORY_CANNOT_PAY_SOUND, 1, ATTN_NORM);
			return;
		}

		float uhave = slotsgettotalamountof(is_player_0, it0, plyr.pls_carryslotz);
		string salt = itemq_salt(itex);

//			assert (pawn_idx == j);
// cost
		if (uhave <= 0) {
			spr (plyr, INVENTORY_DO_NOT_HAVE, " ("  , salt, ")" ); 
			sound(plyr, CHAN_AUTO, INVENTORY_CANNOT_PAY_SOUND, 1, ATTN_NORM);
			return;
		}

		if (gold_idx == slot_empty_neg1) {
			spr (plyr, "No space in inventory to receive payment");
			sound(plyr, CHAN_AUTO, INVENTORY_CANNOT_PAY_SOUND, 1, ATTN_NORM);
			return;
		}

		// Verify seller offers item, find price
		float sell_idx = slotfinditemwithcount (is_locker_1, it0, MAX_ITEMS_SLOTS_64, 1);
		if (sell_idx == slot_empty_neg1) {
			spr (plyr, "Seller does not wish to purchase this item" , " ("  , salt, ")" ); 
			sound(plyr, CHAN_AUTO, INVENTORY_CANNOT_PAY_SOUND, 1, ATTN_NORM);
			return;
		}

		float fprice = storj.dur; // Right?

		//printvarf (fprice);
// give
		// GO!
		slotsremoveamount(is_player_0, it0, plyr.pls_carryslotz, 1);

// GOLD

		// to inventory
		j = gold_idx;
		float is_dest_empty = storj.itemidx == slot_empty_neg1;
		
		if (is_dest_empty)	_slotfillitemquan	(j, it0, fprice);
		else				_slotaddquan		(j, fprice);

	// repack player
	string snew;
	pb(plyr); snew = slots2string(is_player_0); StrSet (plyr.stored, snew);
	
		
	// dirty
	Flag_Add_To (plyr.pl_stored_dirty, STOR_PLAYER_DIRTY_1);

	// feedback
	sound(plyr, CHAN_VOICE, INVENTORY_BUY_SOUND, 1, ATTN_NORM);

	return true;
}

// CMD_uget - requires locker "stor"
float slotget_already_asserted_talker(entity plyr, float j) // switches container
{
	entity elocker = plyr.pl_action_ent;
	assert(elocker != world); // this cannot trigger, caller already checked

	// unpack player, locker
	string2slots(is_player_0,	plyr.stored);
	string2slots(is_locker_1,	plyr.pl_action_ent.stored);

	float locker_cappa = ent_locker_capacity(elocker);

	if (slotvalidatelockerwithcarry(j,plyr.pls_carryslotz,locker_cappa) == false) { wpr ("slotget invalid src idx", ftos(j) ); return false;}	

	if (storj.itemidx == slot_empty_neg1) { wpr ("slotget: src is empty slot j", ftos(j) ); return false;}
	float it0 = storj.itemidx;

	float islockerishsrc	= islockerzone(j);
	float desttype			= islockerishsrc ? is_player_0 : is_locker_1; // need the other as dest
	float destcap			= desttype ? locker_cappa : plyr.pls_carryslotz;
	float jdst				= slotfindbestidx(desttype, it0, destcap, true);
	
	// -1 fail, stacks or not stacks
	if (jdst == slot_empty_neg1) {
		spr (plyr, INVENTORY_FULL_MSG); sound(plyr, CHAN_AUTO, INVENTORY_FULL_SOUND, 1, ATTN_NORM);
		return 0;
	}

	float issame		= (storj.itemidx == storjdst.itemidx);
	float doesstack		= itex.stackstype == stackstype_stack_2;

	if (doesstack && issame)	_slotaddquan	(jdst, storj.quan_tier);
	else						_slotcopy		(jdst, j);

	_slotclear (j);

	// repack player, locker
	string snew;
	pb(plyr); snew = slots2string(is_player_0); StrSet (plyr.stored, snew);
	snew = slots2string(is_locker_1); StrSet (elocker.stored, snew);
		
	// dirty
	Flag_Add_To (plyr.pl_stored_dirty, STOR_PLAYER_DIRTY_1);
	Flag_Add_To (plyr.pl_stored_dirty, STOR_LOCKER_DIRTY_2);

	// feedback
	sound(plyr, CHAN_VOICE, INVENTORY_TAKE_SOUND, 1, ATTN_NORM);

	return 1;
}

// requires locker "stor"
// CMD_uget - requires locker "stor"
float slotraid_already_asserted_locker(entity plyr)
{ WARP_X_ (item_take_it)

	entity elocker = plyr.pl_action_ent;
	assert(elocker != world); // this cannot trigger, caller already checked

	float numtakes = 0; 
	float numfails = 0; 

	// unpack player, locker
	string2slots(is_player_0,	plyr.stored);
	string2slots(is_locker_1,	plyr.pl_action_ent.stored);

	// no locker until unpack is done
	float locker_cappa = ent_locker_capacity(elocker);

	// Take everything we can
	for (float n = 0; n < locker_cappa; n ++ ) {
		float j = n + LOCKER_ITEMS_START_64;

		if (storj.itemidx == slot_empty_neg1)
			continue;

		float it0	= storj.itemidx;		
		float jdst	= slotfindbestidx(is_player_0, it0, plyr.pls_carryslotz, false);

		if (jdst == slot_empty_neg1) {
			numfails ++;
			continue; // Other items may stack
		}

		float issame	= (storj.itemidx == storjdst.itemidx);
		float doesstack = itex.stackstype == stackstype_stack_2;

		if (doesstack && issame)	_slotaddquan	(jdst, storj.quan_tier);
		else						_slotcopy		(jdst, j);
			
		_slotclear (j);

		numtakes ++;
	}

	// repack player, locker
	string snew;
	pb(plyr); snew = slots2string(is_player_0); StrSet (plyr.stored, snew);

	snew = slots2string(is_locker_1); StrSet (elocker.stored, snew);

	// dirty
	Flag_Add_To (plyr.pl_stored_dirty, STOR_PLAYER_DIRTY_1);
	Flag_Add_To (plyr.pl_stored_dirty, STOR_LOCKER_DIRTY_2);

	// feedback
	string s_so;
	if (numfails) {
		s_so = INVENTORY_FULL_SOUND;
	} else if (numtakes) {
		s_so = INVENTORY_TAKE_SOUND;
	} else {
		s_so = PLACER_FAIL_SOUND; // Whiff
	}
	sound(plyr, CHAN_AUTO, s_so, 1, ATTN_NORM);

	return numtakes;
} // slotraid

// remove contents - locker not required
float slotdropex(entity plyr, float j)
{
	// determine what to unpack
	float mix = 0; 
	if (islockerzone(j)) { Flag_Add_To(mix, STOR_LOCKER_DIRTY_2);} else {Flag_Add_To(mix, STOR_PLAYER_DIRTY_1);}

	if (Have_Flag(mix,STOR_LOCKER_DIRTY_2) && !plyr.pl_action_ent) errox ("slotdropex: no locker");
	
	// unpack player, locker
	if (Have_Flag(mix,STOR_PLAYER_DIRTY_1)) { string2slots(is_player_0,	plyr.stored);   }
	if (Have_Flag(mix,STOR_LOCKER_DIRTY_2)) { string2slots(is_locker_1,	plyr.pl_action_ent.stored); }

	// no locker until unpack is done
	entity elocker = plyr.pl_action_ent; 
	float locker_cappa = 0; if (elocker) locker_cappa = ent_locker_capacity(elocker);

	// cannot check for empty without unpack
	if (slotvalidatelockerwithcarry(j,plyr.pls_carryslotz,locker_cappa )==false) { wpr ("slotdropex invalid src idx", ftos(j) ); return false;}
	if (slotisempty(j)) { wpr ("storslotswap src idx has -1 no item", ftos(j)); return false;} // cannot have empty source slot

	// perform drop
	perform_drop_inv_upacked (plyr, j, storj.quan_tier, /*vel*/ 0);

	// remove
	_slotclear	(j);

	// repack player, locker
	string snew;
	
	if (Have_Flag(mix,STOR_PLAYER_DIRTY_1)) { pb(plyr); snew = slots2string(is_player_0); StrSet (plyr.stored,snew);  }
	if (Have_Flag(mix,STOR_LOCKER_DIRTY_2)) { snew = slots2string(is_locker_1); StrSet (elocker.stored,snew);}

	// feedback
	sound(plyr, CHAN_VOICE, "actions/jumpland.wav", 1, ATTN_NORM);
	
	// dirty
	if (Have_Flag(mix,STOR_PLAYER_DIRTY_1)) Flag_Add_To (plyr.pl_stored_dirty, STOR_PLAYER_DIRTY_1);
	if (Have_Flag(mix,STOR_LOCKER_DIRTY_2)) Flag_Add_To (plyr.pl_stored_dirty, STOR_LOCKER_DIRTY_2);

	return mix;

}

