// 003_both_baker_defs_warp_s_replace.h - not zircon specific -
// see gold for zircon specific

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

// Baker: Ease of code

// 22 secs startup time plain map
// compile mars 11:03:40 ... 2 minutes even
// 11:07:50 load jack mars ... 11:08:34 ... under a minute (45 secs)

const float SOUNDFLAG_RELIABLE = 1;	/* The sound will restart once it reaches the end of the sample. */
const float SOUNDFLAG_FORCELOOP = 2;	/* The sound will restart once it reaches the end of the sample. */
//CHANNELFLAG_RELIABLE

// The C library function int rand(void) returns a pseudo-random number in the range of 0 to RAND_MAX.
// RAND_MAX is a constant whose default value may vary between implementations but it is granted to be at least 32767.

// QC random -- Returns a random value between 0 and 1. Be warned, this builtin can return 1 in most engines

#define f_flags			float
#define f_bool			float
#define f_enum			float		// an enum, specify
#define f_int			float
#define f_idx			float		// index into array
#define f_time_t		float		// Stores time, period since level started
#define f_uint32_t		float		// Stores time, period since level started
#define f_duration_t	float		// Stores a length of time   zoom_duration


enum threshold_e {
	THRESHOLD_NONE_0		= 0,
	THRESHOLD_AWAITING_1	= 1,
	THRESHOLD_MET_2			= 2
};

#define LETTER_MDL_DIGITAL		"fonts/func_text/digits.obj"
#define LETTER_MDL_LIBMONO		"fonts/func_text/letter.obj"
#define LETTER_MDL_OUTLINED		"fonts/func_text/outlined.obj"


#define SPACE_CHAR_32					32
#define NEWLINE_CHAR_10					10
#define NEWLINE							"\n"
#define ONE_CHAR_1						1
#define THRESHOLD_DISTANCE_TRIGGER_3_0	3.0

#define Flag_Remove_From(x,flag)		x = (x) - ((x) & (flag))
#define Flag_Mask_To_Only(x,flag)		x = ((x) & (flag))
#define Flag_Add_To(x,flag)				x |= (flag)
#define Have_Flag(x,flag)				((x) & (flag))
#define Have_Flag_Bool(x,flag)			(((x) & (flag)) != 0)
#define Have_Flag_Strict_Bool(x,flag)	(  ((x) & (flag) ) == (flag) )
#define No_Have_Flag(x,flag)			!((x) & (flag))

#define ASSIGN(X)						(X)

#define assert(x)						if (!(x)) errox("assertion fail ", #x, " ", ftos(x))
#define errox_if(x, msg)				if ( (x)) errox("error ", #x, " ", ftos(x), msg)
#define obj_assert_x(x,msg)				if (!(x)) objerror_x("obj assertion fail ",   #x, " ", ftos(x), " ", msg)
#define obj_error_if_x(x,msg)			if (x)	  objerror_x("obj error condition: ", #x, " ", ftos(x), " ", msg)
#define server_assert_plyr_ret_(x)		if (!(x)) { spr (plyr, "assertion fail ", #x, " ", ftos(x)); return; } // server does not error because would be vulnerability
#define server_assert_self_ret_(x)		if (!(x)) { spr (self, "assertion fail ", #x, " ", ftos(x)); return; } // server does not error because would be vulnerability


// math
#define ONE_HALF_DEGREE_IN_RADIANS_0_087___		0.00872664625997164788 			// no magic numbers in code please, explain what they are
#define M_PI									3.14159265358979323846 			// defined in csqc header but not in server so still here
#define DEGREES_TO_RADIANS(__ANGLE)				((__ANGLE) * ( M_PI / 180.0) )	// 1 degrees =  0.0174532925 radians

#define largest						max		// max and min are often used to do the opposite of what it sounds like
#define largest3					max3	// max and min are often used to do the opposite of what it sounds like
#define largest4					max4	// max and min are often used to do the opposite of what it sounds like

#define smallest					min		// so I prefer largest/smallest so no thinking or reading the code is needed

#define inrange(low,x,high)			( (low) <= (x) && (x) <= (high) )
#define inrangebeyond(low,x,beyond)	( (low) <= (x) && (x) < (beyond) )

#define isin1(x,a)					((x) == (a))
#define isin2(x,a,b)				((x) == (a) || (x) == (b))
#define isin3(x,a,b,c)				((x) == (a) || (x) == (b) || (x) == (c))
#define isin4(x,a,b,c,d)			((x) == (a) || (x) == (b) || (x) == (c) || (x) == (d))

// 2d
#define bottomof(r)	(r.y + r.h)
#define rightof(r)		(r.x + r.w)

#define bottom_of_e(e)			(e.origin.z  + e.mins.z)
#define top_of_e(e)				(e.origin.z  + e.maxs.z)

// str
#define QUOTED(x)					"\"", x, "\""
#define QUOTE						"\""
#define CRLF						"\n"									// I do not like \n all over the place, yes no cr in there, whatever
																			// I just need what we use to be understood and non-stupid

//#define centerprint_x(e, ...)		centerprint(e, __VA_ARGS__)				// DP varadic yes
#define spr(e, ...)					sprint(e, __VA_ARGS__, CRLF)			// self print to 1 player only
#define sprf(e, ...)				sprint(e,sprintf(__VA_ARGS__),CRLF)		// unused so far

#define dpr(...)					dprint(__VA_ARGS__, CRLF)				// developer print (developer cvar > 0) DP varadic yes
#define dpp(...)					dprint(__VA_ARGS__, CRLF)				// keep out of searches (stuff we don't want to see like DarkPlaces extension sample code)

#define zpr_item_fell_out(e)		zpr("item fell out of level at ", vtos(e.origin), " classname ", e.classname, " ", e.model);

#define bpr(...)					bprint(__VA_ARGS__, CRLF)				// broadcast print to all players - DP varadic yes
#define zpr(...)					print(__VA_ARGS__, CRLF)				// DP varadic yes
#define wpr(...)					print(__VA_ARGS__, CRLF)				// warn print

#define errox(...)					error(strcat("",__VA_ARGS__))			// DP not varadic, has owh CRLF
#define objerror_x(...)				objerror(strcat("",__VA_ARGS__))		// DP not varadic, has owh CRLF
#define localcmd_x(...)				localcmd(__VA_ARGS__, CRLF)				// DP varadic
#define stuffcmd_x(...)				stuffcmd(__VA_ARGS__, CRLF)				// DP varadic 8 yes


#define printvarf(w)				zpr (#w, " ", ftos(w))
#define printvarv(w)				zpr (#w, " ", vtos(w))
#define printvars(w)				zpr (#w, " ", w)
#define printvarsq(w)				zpr (#w, " \"", w, "\"")

#define modify																// yet we have not used modify yet ... I dont prefer funcs modifying vars anyway 
#define WARP_X_(...)														// Allows easy going to the definition of X anywhere we want 
#define WARP_X_CALLERS_(...)												// Allows easy going to the definition of X anywhere we want
#define WARP_X_RELATED_(...)												// Allows easy going to the definition of X anywhere we want

#define PLACE_X_(...)														// 

#define PLUS1(X)					(X + 1)									// For idx
#define UNPLUS1(X)					(X - 1)

//#define QUOTE "\""

// String - StrExists, StrSet, StrClear, string_does_start_with, string_does_end_with, string_replace (? name?)

#define	startpos_0					0										// strstrofs more legible
#define not_found_neg1				-1										// strstrofs more legible

// ascii	= str2chr(sch, /*pos*/ 0);
#define string_does_contain(s,sfind)		(strstrofs(s,sfind,startpos_0) != not_found_neg1)
#define string_does_match_caseless(s,s2)	(strcasecmp(s,s2) == 0)
#define string_replace(s,sfin,srepl)		strreplace(sfin,srepl,s)
#define string_append(s,...)				s = strcat(s,__VA_ARGS__)

#define string_left(s,count)				substring(s, startpos_0, count)			// len 10 "01234 56789" -> string_mid(s, 5) -> "56789"

// string_mid: make startpos is validated before call, it is not validated here
#define string_mid(s,startpos)					substring(s, startpos, strlen(s) - startpos)
#define string_range(s,startpos,endpos)			substring (s,startpos, (endpos- startpos + 1)) // 01 1 - 9 pp 1 is 2;  1 9 9 - 1 8 
#define string_start_count(s,startpos,count)	substring
#define string_range_width(startpos,endpos)		(endpos - startpos + 1)

#define string_instr(s,sfind)					strstrofs(s, sfind, startpos_0) // -1 if sub is not in s1. .. not_found_neg1 instr
#define string_find_pos(s,sfind)				string_instr(s, sfind)
#define string_find_pos_start_at(s,sfind,spos)	strstrofs(s, sfind, spos)

WARP_X_ (func_text)

// Remove characters that DarkPlaces might do something weird --- like color or replace with a cvar, etc.
string string_scrub(string s)
{
	string sout;
	float num_rejects;
	// not 44 '%' 36 '$' 34 dq 94 '^' 129 tidle 96 sq  32-126 except <----

	// Allowed 32, 45 "-", 46 "+"; 44 "," 48 '0' to 57 '9' 58 ":" 59 ";" 

	float slen = strlen(s);

	for (float pos = 0; pos < slen; pos ++) {
		string sch = substring(s, pos, 1);
		float ok = TRUE;
		//printvarf (pos);
		//printvars (sch);

		float	ascii	= str2chr(sch, startpos_0); // turn our single char to ascii
		//printvarf (ascii);

		if (ascii < SPACE_CHAR_32 || ascii > 126) {
			ok = FALSE;
			goto skip;
		}

		// This is assuming DarkPlaces didn't already do weird stuff to the string ??
		// Is this too late?
		if (sch == "'"   /*34 */) ok = FALSE;	// squote
		if (sch == "$"   /*36 */) ok = FALSE;
		if (sch == "%"   /*44 */) ok = FALSE;
		if (sch == "^"   /*94 */) ok = FALSE;
		if (sch == "~"   /*126*/) ok = FALSE;
		if (sch == "`"   /*   */) ok = FALSE;	// backquote

		// We will be quoting the string so this is not helpful
		if (sch == "\""  /*   */) ok = FALSE;	// dquote

skip:
		//printvarf (ok);
		if (ok == FALSE) {	sout = strcat(sout, " "); num_rejects += 1; }
		else			 {	sout = strcat(sout, sch);		            }
	} // each char

	//if (num_rejects > 0)	zpr (QUOTED(s) " scru-> " QUOTED(sout));
	//else					zpr (QUOTED(s) " zero-> " QUOTED(sout));
	//zpr ("scru");
	return sout;
}

string string_capital_first_char(string s)
{
	string s1= strtoupper(string_left(s,1));
	string s2= string_mid(s,1);
	string sout= strcat(s1,s2);
	return sout;
}

// returns not_found_neg1 if not found (?)
float string_find_lastpos(string s, string sf)
{
	// pos of last /
	//float xout = ;;
	//float x;
	//printvars (s);
	//printvars (sf);
	float lastpos = not_found_neg1;
	while (1) {
		float prevpos = lastpos;
		
		
		if (lastpos == not_found_neg1) lastpos = startpos_0;
		else lastpos = lastpos + strlen(sf);
		//zpr ("vefore");
		//printvarf (lastpos);
		lastpos = strstrofs(s, sf, lastpos);
		//printvarf (lastpos);
		//	zpr ("after");
		if (lastpos == not_found_neg1) {
		//	printvars (s);
		//	printvars (sf);
		//	printvarf (prevpos);
			return prevpos;
		}
		
	}
}



float string_does_end_with(string s, string strending)
{
	// this1.bsp		// len 9 .. start at 5  len1-lenother
	// 0123456789
	float s_len		= strlen(s);			// 9
	float s2_len	= strlen(strending);	// 4
	float offset	= s_len - s2_len;		// 5

	if (s_len < s2_len) {
		//opr (s, " DOES NOT end with ", strending, " due to length");
		return FALSE;
	}

	if (strstrofs(s, strending, offset) == offset) {
		// Hit
		//opr (s, " ends with ", strending);
		return TRUE;
	}
	//opr (s, " DOES NOT end with ", strending);
	return FALSE;
}

string string_after(string s, string swhat)
{
	//zpr ("string_after " , QUOTED(s), " " , QUOTED(swhat) );
	float spos = strstrofs(s, swhat, startpos_0);
	if (spos != not_found_neg1) {
		string sout = string_mid(s, spos + strlen (swhat) );
		//printvars (sout);
		return sout;
	}

	return "";
}



float string_does_start_with(string s, string strbegin)
{
	// this1.bsp		// len 9 .. start at 5  len1-lenother
	// 0123456789
	float s_len		= strlen(s);			// 9
	float s2_len	= strlen(strbegin);		// 4
	
	if (s_len < s2_len) {
		//opr (s, " DOES NOT end with ", strending, " due to length");
		return FALSE;
	}

	if (strstrofs(s, strbegin, startpos_0) == 0) {
		return TRUE;
	}
	return FALSE;
}

// starts with 0-9
float string_is_numeric(string s)
{
	float	ascii	= str2chr(s, startpos_0);

	if  (inrange('0',ascii,'9')) return TRUE;
	return FALSE;
}

// fteqcc: "null strings will be considered equal to merely empty strings"

// WARNING: This needs { } if an "if" statement calls it.

#define StrSet(x,Str) \
	StrClear(x); \
	if (StrExists(Str)) { \
		x = strzone(Str); \
	} else \
		x = "" // Ender

#define StrClear(x) \
	if (StrExists(x)) { \
		strunzone(x); x=""; \
	} else \
		x  = "" // Ender -- need so macro calls can end with semicolon -- can't think of a good noop statement
#define StrExists(x) \
	( (strlen(x)==0) ? 0 : 1) // Ender



// returns xy of pct -- pos = circlepos (circle_center_pos, r, 1 / m_num_segments_61);
vector circlepos (vector circle_center_pos, float r, float pct)
{
	pct=pct -0.25;
	float theta = 2.0 * M_PI * pct; 
	vector pos;
	pos.x = (r * cos(theta)) + circle_center_pos.x; 
	pos.y = (r * sin(theta)) + circle_center_pos.y;
	return pos;
}

// Time

#define use_localtime_true		true
#define use_localtime_false		false

// func_text / clock
#define MIN_TEXTSIZE_1			1
#define MAX_TEXTSIZE_512		512   //#define MAX_TEXTSIZE_32		32
#define MAX_TEXTCHARCODE_96		96
#define MIN_TEXTCHARCODE_32		32

#define	TILDE_CHAR_BACKQUOTE	'`' // Yeah

#define btn_collide(bxer, pos) ((bxer.x <= pos.x && pos.x < (bxer.x + bxer.w)) && (bxer.y <= pos.y && pos.y < (bxer.y + bxer.h)))

#define MONSTER_PAUSETIME_EXTRA_HIGH_9s		99999999
#define NEXTTHINK_NEVER_ZERO				0
#define NEXTTHINK_SOON_0_1					0.1
#define NEXTTHINK_ROTATING_EXTRA_HIGH_9s	99999999


#define	CHAN_PROJECTILE_4	4	// Projectiles
#define	CHAN_WEAPON2_5		5	// Nex fire (separated as it is a very long sound)
#define	CHAN_PAIN_6			6	// Pain
#define	CHAN_PLAYER_7		7	// Player body

//#define SVC_SKYBOX							37
#define AS_STRING							1		// CSQC addstat -- worldspawn is where we do it
#define AS_INT								2
#define AS_FLOAT_TRUNCATED					2
#define AS_FLOAT							8



//#define ZENT_TYPE_R_WATER_ENT_1			1
//#define ZENT_TYPE_PARTICLE_EMITTER_2		2

#define CL_ENT_VIS_1				1
#define CL_ENT_ORG_2				2
#define CL_ENT_ANG_4				4
#define CL_ENT_ORG_ANG_6			6
#define CL_ENT_SKIN_8				8
#define CL_ENT_COLORMOD_16			16
#define CL_ENT_SCALE_32				32
#define CL_ENT_MODEL_64				64
//#define CL_ENT_SIZE_128			128
#define CL_ENT_VID_INFO_256			256
//#define CL_ENT_VID_FPS_512		512
//#define CL_ENT_VID_PLAY_TIME_1024	1024
//#define CL_ENT_SCREEN_PROG_2048	2048
#define CL_ENT_PROG_INFO_4096		4096


// Poker decal
#define ESCORE_MAX_FLAGS			(CL_ENT_VIS_1 | CL_ENT_ORG_ANG_6 | CL_ENT_SKIN_8 | CL_ENT_COLORMOD_16 | \
											CL_ENT_SCALE_32 | CL_ENT_MODEL_64)

#define VIDEOX_MAX_FLAGS			(CL_ENT_VIS_1 | CL_ENT_ORG_ANG_6 |				   CL_ENT_COLORMOD_16 | \
											CL_ENT_SCALE_32 | CL_ENT_MODEL_64| CL_ENT_VID_INFO_256)

#define PROGGY_MAX_FLAGS			(CL_ENT_VIS_1 | CL_ENT_ORG_ANG_6 |				   CL_ENT_COLORMOD_16 | \
											CL_ENT_SCALE_32 | CL_ENT_MODEL_64 | \
										/*CL_ENT_SCREEN_PROG_2048 | */ CL_ENT_PROG_INFO_4096)

	//video_image(sound) : "video_image - video texture sheet"
	//video_frame_width(integer) : "video_frame_width - width of sheet subpic"
	//video_frame_height(integer) : "video_frame_height - width of sheet subpic"
	//video_frame_count(integer): "video_frame_count - if not width x height"
	//health(integer) : "health - health 0 means not auto-start" : 1


#define ENT_TYPE_SCORE_DECAL_1	1				// poker decal
#define ENT_TYPE_VIDEO_2		2				// 
#define ENT_TYPE_PROGGY_3		3				// 




#define SEND_IT_TRUE_1						1
#define SENDFLAGS_ALL_FFF_FFF				0xFFFFFF

#define ZEFFECTS_NDNE_0						0
#define TEFFECTS_NDNE_0						0

#define COLORBSOLID_255						0


string string_fs_get_path(string s)
{
	string s0 = s;
	float lastpos = string_find_lastpos (s, "/");
	if (lastpos != not_found_neg1) {
		s0 = string_left (s,lastpos);
	}
	return s0;

}

string string_fs_strip_path(string s)
{
	// pos of last /
	
	string s0 = s;
	float lastpos = string_find_lastpos (s, "/");
	if (lastpos != not_found_neg1) {
		s0 = string_mid (s,lastpos + 1);
	}
	return s0;
}

string string_fs_strip_extension(string s)
{
	// pos of last /
	
	string s0 = s;
	float lastpos = string_find_lastpos (s, ".");
	if (lastpos != not_found_neg1) {
		s0 = string_left (s,lastpos);
	}
	return s0;
}


string string_remove_lead(string s, string s_remove)
{
	float lastpos = string_find_lastpos (s, s_remove);

	if (lastpos == 0) {
		string s0 = string_mid (s, strlen(s_remove));
		return s0;
	}
	return s;
}

//string_remove_trail(imame, "_uhd");
string string_remove_trail(string s, string s_trail_remove)
{
	float lastpos = string_find_lastpos (s, s_trail_remove);

	if (lastpos != not_found_neg1) {
		string s0 = string_left (s, lastpos);
		return s0;
	}
	return s;
}


float is_rdiv2_mdl(string s)
{
	string s0 =				 s;												//printvars (s0);
	string s_strip_pathed	= string_fs_strip_path(s0);						//printvars (s_strip_pathed);
	string s_strip_ext		= string_fs_strip_extension(s_strip_pathed);	//printvars (s_strip_ext);
	
	if (string_does_end_with(s_strip_ext,"_rdiv2")) {
		return 2;
	}
	return 0;
}

void vector_swap(vector v1, vector v2)
{
	vector v1copy = v1;
	v1 = v2;
	v2 = v1copy;
}

WARP_X_ (book_from_file)

f_bool string_to_file_data_folder_is_ok(string s, string spath)
{
	// Writes to frikking data/data/tt.txt
	float f = fopen (spath /*"t.txt"*/, FILE_WRITE);
	float open_ok = (f >= 0);
	if (!open_ok) return 0; // is_ok no
	fputs (f, s); //assert (f >= 0);

	fclose (f);
	return 1; // is true
}
// warnsize is for finale text
string _string_from_file(string spath, float warnsize)
{
	float f = fopen (spath /*"zs/test.s"*/, FILE_READ);
	float isok = (f >= 0); //returns fhandle >= 0 if successful fhandle < 0 if unable to open file for any reason
	string sout;
	// 3 whiffs
	float whiffs;
	float linenum;
	if (isok) {
		while (1) {
			string s_line  = fgets(f); // has newline?  cr?
			//printvarsq (s_line);
			//printvarf (strlen(s_line));
			if (warnsize) {
				if (s_line == "1234567890123456789012345678901234567890") {
					dpr ("skipped a measure bar line");
					continue;
				}
			}

			if (!s_line) {
				whiffs ++;
				
				s_line = "\n";
				linenum ++;
				if (whiffs > 2) {
					break;	
				}
			} else {
				if (warnsize) {
					if (strlen(s_line) > warnsize) {
						zpr ("linenum ", ftos(linenum+1), " exceeds length chars max ", ftos(warnsize) );
					}
				}

				//printvars(s_line);
				linenum ++;
				s_line = strcat (s_line, "\n");
				whiffs = 0;
			}

			sout = 	strcat(sout, s_line);
		} // while
		fclose (f);
	}
	//printvarsq (sout);

	// now remove trailing \n
	while (string_does_end_with (sout, "\n")) {
		sout = string_left(sout, strlen(sout)-1 );
	}

	//printvarsq (sout);

	return sout;
}

string string_from_file(string spath)
{
	return _string_from_file(spath, /*warnsize*/ 0);
}



string book_from_file(string spath)
{
	string sout = string_from_file(spath);

	if (strlen(sout)) {
		sout = string_replace(sout, "\n\n", "[p]");
		sout = string_replace(sout, "\n", "");
	}

	//printvarsq (sout);
	return sout;
}
	
string talk_from_file(string spath)
{
	//zpr ("talk_from_file");
	//printvars (spath);
	string sout = string_from_file(spath);

	if (strlen(sout)) {
		sout = string_replace(sout, "|\n\n", "|");	// allow tags line to standalone
		sout = string_replace(sout, "<\n\n", "<");	// allow tags line to standalone
		sout = string_replace(sout, ">\n\n", ">");	// allow tags line to standalone

		sout = string_replace(sout, "|\n", "|");	// allow tags line to standalone
		sout = string_replace(sout, ">\n", ">");	// allow tags line to standalone
		sout = string_replace(sout, "<\n", "<");	// allow tags line to standalone
		
		sout = string_replace(sout, "\n\n", "[p]");
		
		sout = string_replace(sout, "\n", "");
	}

	//printvarsq (sout);
	return sout;
}

//
string finale_from_file(string spath)
{
	//zpr (spath);
	//printvars (spath);
	string sout = _string_from_file(spath, /*warnsize*/ 40);

	//printvars (sout);

	if (strlen(sout)) {
		sout = string_replace(sout, "[p]", "\n\n");
		//sout = string_replace(sout, "\n", "");
	}

	//printvarsq (sout);
	return sout;
}

float string_find_count(string s, string sfind)
{
	float num_found;
	float s_len = strlen(s);
	float sfind_len = strlen(sfind);

	float searchpos = startpos_0;

	while (1) {
		float commapos = strstrofs(s, sfind /*","*/, searchpos);

		if (commapos == not_found_neg1)
			break;

		num_found ++;
		searchpos = commapos + sfind_len;
	} // while

	return num_found;
}

float string_maxline_width(string s, string sfind)
{
	//float num_found;
	float s_len = strlen(s);
	float sfind_len = strlen(sfind);
	float searchpos = startpos_0;
	float max_w;

	while (1) {
		float commapos = strstrofs(s, sfind /*","*/, searchpos);
		float this_w;
		if (commapos == not_found_neg1) {
			this_w = (/*endpos*/ (s_len -1)		- /*startpos*/ searchpos		+ 1);
		} else {
			this_w = (/*endpos*/ (commapos -1)	- /*startpos*/ searchpos		+ 1);
		}

		if (this_w > max_w) max_w = this_w;

		if (commapos == not_found_neg1)
			break;

		//num_found ++;
		searchpos = commapos + sfind_len;
	} // while

	return max_w;
}

// why mot tokemize imstread?
string string_instance(string s, string sfind, float num)
{
	float num_found		= 0;
	float s_len			= strlen(s);
	float sfind_len		= strlen(sfind);
	float searchpos		= startpos_0;

	while (1) {
		float commapos	= string_find_pos_start_at(s, sfind, searchpos);		
		float endpos	= (commapos == not_found_neg1) ? (s_len -1) : (commapos -1);
		float this_w	= string_range_width (searchpos, endpos);

		if (num_found == num) {
			string sout = string_range (s, searchpos, endpos);
			return sout;
		}

		if (commapos == not_found_neg1)
			break;

		searchpos = commapos + sfind_len;
		num_found ++;
	} // while

	return "";
}


string _s_fake_src_a;
float _fake_pos;
float _fake_len;

void string_fopen_static (string s)
{
	StrSet (_s_fake_src_a, s);
	_fake_pos = 0;
	_fake_len = strlen(s);
	//printvars (_s_fake_src_a);
	//printvarf (_fake_len);
}

void string_fclose_static ()
{
	StrClear (_s_fake_src_a);
}

// It does not signal EOF .. I think data better off in files ... todo.
string string_freadline_static()
{
	string sout;
	float pos = _fake_pos;
	if (pos >= _fake_len) {
		float k = pos - _fake_pos; // we are at beyond, the ch 10
		sout = substring (_s_fake_src_a, _fake_pos, k);
		_fake_pos += k; // beyond (EOF)
	} else {
		float newliney_pos = string_find_pos_start_at (_s_fake_src_a, NEWLINE, pos);

		if (newliney_pos != not_found_neg1) {
			/*float*/ k = newliney_pos - _fake_pos; // we are at beyond, the ch 10
			//memcpy (s_line, &s_fake_src_a[fake_pos], k);
			//s_line[k] = 0;
			
			sout = substring (_s_fake_src_a, _fake_pos, k);
			_fake_pos += (k + 1); // after ch 10
		} else {
			/*float*/ k = _fake_len - _fake_pos; // we are at beyond, the ch 10
			sout = substring (_s_fake_src_a, _fake_pos, k);
			_fake_pos += k; // after ch 10
		} // if
	} // if

	//zpr ( "sout " , QUOTED(sout)  );
	return sout;		
}

float hypoteneuse_2_sides (float a, float b)
{ // only either pitch or roll is allowed to be set.
	float w2 = (a * a) + (b * b);
	float c = sqrt(w2); // hypoteneuse
	return c;
}

// c = hypoteneuse_leg_plus_angle (e.size.z /*19*/, e.angles.z /*25*/);
float hypoteneuse_leg_plus_angle (float leg_length, float angle_degrees)
{
	//recv a  0		0		25 (25 roll)
	//recv sz 25		0.1		19 (25 width we no care)

	float aside_19		= leg_length; // 19;
	float bside			= aside_19 * tan(DEGREES_TO_RADIANS(angle_degrees));  // roll
	float cside			= hypoteneuse_2_sides (aside_19, bside);

	return cside;
}


//                     5 4 3 2  1 0
// "eee/vid_yellow_warp_w_480_h_480_n_23.jpg"

// This does what?
// Takes vid_cube_w_268_h_200_n_100.jpg
// Parse the width and height and num frames
vector Parso_Vid_Width_Height_Framecount(string spic)
{
	// remove path
	// remove extensio
	// find _w_
	string s0 = spic;
	s0 = string_fs_strip_path(s0);
	s0 = string_fs_strip_extension(s0);
	float wpos = string_instr(s0, "_w_");
	assert (wpos!= not_found_neg1);
	string s1 = string_mid(s0, wpos + 1);
	// 0: w_
	// 1: 480_
	// 2: h_
	// 3: 480_
	// 4: n
	// 5 _23
	vector vout;
	float uscore_argc = tokenizebyseparator(s1, "_"); // separator is discarded
	assert (uscore_argc==6);
	vout.x = stof( argv(1) );	// w
	vout.y = stof( argv(3) );	// h
	vout.z = stof( argv(5) );	// n
	//printvarv (vout);
return vout; 
	// Tags to buttons
}
