// inventory_server.c

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


string ent_bestname(entity e)
{
	if (StrExists(e.it_formalname)) {
		return e.it_formalname;
	}

	if (e.it_itemidxp1) {
		float it0 = UNPLUS1(e.it_itemidxp1);
		return salt_magic_idx(it0);
//		if (StrExists(itex.altmame)) {
//			return itex.altmame;
//		}
	}
	
	return e.itemname;
}




float ent_is_exostore(entity e)
{
	if (e.capacity_float1 == EXOSTORE_36)
		return true;

	return false;
}

float ent_locker_capacity(entity e)
{
	if (e.capacity_float1) 
		return e.capacity_float1;

	return 6;
}

string ent_open_sound(entity e) // used PACTION_OPEN_7
{
	switch (e.material_float2) {
	//case mt_wood_1:	return "100_CC0/lock_open_01.ogg";
	case 6: return INVENTORY_CANNOT_PAY_SOUND; //"actions/jumpland.wav"
	case 2:	return "100_CC0/lock_open_01.ogg";
	case 3:	return "100_CC0/metal_open_01.ogg";
	case 4:	return "100_CC0/metal_open_01.ogg";
	case 1:	return "actions/jumpland.wav";
	default:
	case 5:	return "actions/chest.wav";;
	//default:			
	}
	
}
