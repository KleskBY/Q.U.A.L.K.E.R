///////////////////////////
// file constants

const float FILE_READ = 0;
const float FILE_APPEND = 1;
const float FILE_WRITE = 2;

///////////////////////////
// logical constants (just for completeness)

const float TRUE 	= 1;
const float FALSE = 0;

///////////////////////////
// boolean constants

const float true = 1;
const float false = 0;

///////////////////////////
// msg constants

const float MSG_BROADCAST		= 0;		// unreliable to all
const float MSG_ONE				= 1;		// reliable to one (msg_entity)
const float MSG_ALL				= 2;		// reliable to all
const float MSG_INIT			= 3;		// write to the init string

const float	EF_BRIGHTFIELD	= 1;
const float	EF_MUZZLEFLASH 	= 2;
const float	EF_BRIGHTLIGHT 	= 4;
const float	EF_DIMLIGHT 	= 8;

const float	AS_STRAIGHT		= 1;
const float	AS_SLIDING		= 2;
const float	AS_MELEE		= 3;
const float	AS_MISSILE		= 4;

// edict.flags
const float	FL_FLY					= 1;
const float	FL_SWIM					= 2;
const float	FL_CLIENT				= 8;	// set for all client edicts
const float	FL_INWATER				= 16;	// for enter / leave water splash
const float	FL_MONSTER				= 32;
const float	FL_GODMODE				= 64;	// player cheat
const float	FL_NOTARGET				= 128;	// player cheat
const float	FL_ITEM					= 256;	// extra wide size for bonus items
const float	FL_ONGROUND				= 512;	// standing on something
const float	FL_PARTIALGROUND		= 1024;	// not all corners are valid
const float	FL_WATERJUMP			= 2048;	// player jumping out of water
const float	FL_JUMPRELEASED			= 4096;	// for jump debouncing

// edict.movetype values
const float	MOVETYPE_NONE			= 0;	// never moves
const float MOVETYPE_ANGLENOCLIP    = 1;
const float MOVETYPE_ANGLECLIP              = 2;
const float	MOVETYPE_WALK			= 3;	// players only
const float	MOVETYPE_STEP			= 4;	// discrete, not real time unless fall
const float	MOVETYPE_FLY			= 5;
const float	MOVETYPE_TOSS			= 6;	// gravity
const float	MOVETYPE_PUSH			= 7;	// no clip to world, push and crush
const float	MOVETYPE_NOCLIP			= 8;
const float	MOVETYPE_FLYMISSILE		= 9;	// fly with extra size against monsters
const float	MOVETYPE_BOUNCE			= 10;
const float	MOVETYPE_BOUNCEMISSILE	= 11;	// bounce with extra size

// edict.solid values
const float	SOLID_NOT				= 0;	// no interaction with other objects
const float	SOLID_TRIGGER			= 1;	// touch on edge, but not blocking
const float	SOLID_BBOX				= 2;	// touch on edge, block
const float	SOLID_SLIDEBOX			= 3;	// touch on edge, but not an onground
const float	SOLID_BSP				= 4;	// bsp clip, touch on edge, block

// range values
const float	RANGE_MELEE				= 0;
const float	RANGE_NEAR				= 1;
const float	RANGE_MID				= 2;
const float	RANGE_FAR				= 3;

// deadflag values

const float	DEAD_NO					= 0;
const float	DEAD_DYING				= 1;
const float	DEAD_DEAD				= 2;
const float	DEAD_RESPAWNABLE		= 3;

// takedamage values

const float	DAMAGE_NO				= 0;
const float	DAMAGE_YES				= 1;
const float	DAMAGE_AIM				= 2;

// point content values

const float	CONTENT_EMPTY			= -1;
const float	CONTENT_SOLID			= -2;
const float	CONTENT_WATER			= -3;
const float	CONTENT_SLIME			= -4;
const float	CONTENT_LAVA			= -5;
const float CONTENT_SKY             = -6;

const float STATE_RAISED            = 0;
const float STATE_LOWERED           = 1;
const float	STATE_UP		= 2;
const float	STATE_DOWN		= 3;

// sound channels
// channel 0 never willingly overrides
// other channels (1-7) allways override a playing sound on that channel
const float	CHAN_AUTO		= 0;
const float	CHAN_WEAPON		= 1;
const float	CHAN_VOICE		= 2;
const float	CHAN_ITEM		= 3;
const float	CHAN_BODY		= 4;

const float	ATTN_NONE		= 0;
const float	ATTN_NORM		= 1;
const float	ATTN_IDLE		= 2;
const float	ATTN_STATIC		= 3;
const float	TE_SPIKE		= 0;
const float	TE_SUPERSPIKE	= 1;
const float	TE_GUNSHOT		= 2;
const float	TE_EXPLOSION	= 3;
const float	TE_TAREXPLOSION	= 4;
const float	TE_LIGHTNING1	= 5;
const float	TE_LIGHTNING2	= 6;
const float	TE_WIZSPIKE		= 7;
const float	TE_KNIGHTSPIKE	= 8;
const float	TE_LIGHTNING3	= 9;
const float	TE_LAVASPLASH	= 10;
const float	TE_TELEPORT		= 11;
const vector	VEC_ORIGIN = '0 0 0';

const vector	VEC_HULL2_MIN = '-32 -32 -24';
const vector	VEC_HULL2_MAX = '32 32 64';

const float 	M_PI 							= 3.14159265358979323846;

const float IE_KEYDOWN = 0;
const float IE_KEYUP = 1;
const float IE_MOUSEDELTA = 2;
const float K_TAB	= 9;
const float K_ENTER = 13;
const float K_ESCAPE = 27;
const float K_SPACE = 32;
const float K_BACKSPACE = 127;
const float K_UPARROW = 128;
const float K_DOWNARROW = 129;
const float K_LEFTARROW = 130;
const float K_RIGHTARROW = 131;
const float K_LALT = 132;
const float K_RALT = -245;
const float K_LCTRL = 133;
const float K_RCTRL = -246;
const float K_LSHIFT = 134;
const float K_RSHIFT = -247;
const float K_F1	= 135;
const float K_F2	= 136;
const float K_F3	= 137;
const float K_F4	= 138;
const float K_F5	= 139;
const float K_F6	= 140;
const float K_F7	= 141;
const float K_F8	= 142;
const float K_F9	= 143;
const float K_F10	= 144;
const float K_F11	= 145;
const float K_F12	= 146;
const float K_INS	= 147;
const float K_DEL	= 148;
const float K_PGDN = 149;
const float K_PGUP = 150;
const float K_HOME = 151;
const float K_END	= 152;
const float K_KP_HOME	= 164;
const float K_KP_UPARROW = 165;
const float K_KP_PGUP = 166;
const float K_KP_LEFTARROW = 161;
const float K_KP_5 = 162;
const float K_KP_RIGHTARROW = 163;
const float K_KP_END = 158;
const float K_KP_DOWNARROW = 159;
const float K_KP_PGDN = 160;
const float K_KP_ENTER = 172;
const float K_KP_INS = 157;
const float K_KP_DEL = 167;
const float K_KP_SLASH = 168;
const float K_KP_MINUS = 170;
const float K_KP_PLUS = 171;
const float K_KP_NUMLOCK = 154;
const float K_KP_STAR = 169;
const float K_KP_EQUALS = 173;
const float K_MOUSE1 = 512;
const float K_MOUSE2 = 513;
const float K_MOUSE3 = 514;
const float K_MOUSE4 = 517;
const float K_MOUSE5 = 518;
const float K_MOUSE6 = 519;
const float K_MOUSE7 = 520;
const float K_MOUSE8 = 521;
const float K_MOUSE9 = 522;
const float K_MOUSE10	= 523;
const float K_LWIN = 239;
const float K_RWIN = 240;
const float K_APP	= -241;
const float K_SEARCH = -242;
const float K_POWER = 130;
const float K_VOLUP = -243;
const float K_VOLDOWN = -244;
const float K_JOY1 = 768;
const float K_JOY2 = 769;
const float K_JOY3 = 770;
const float K_JOY4 = 771;
const float K_AUX1 = 784;
const float K_AUX2 = 785;
const float K_AUX3 = 786;
const float K_AUX4 = 787;
const float K_AUX5 = 788;
const float K_AUX6 = 789;
const float K_AUX7 = 790;
const float K_AUX8 = 791;
const float K_AUX9 = 792;
const float K_AUX10 = 793;
const float K_AUX11 = 794;
const float K_AUX12 = 795;
const float K_AUX13 = 796;
const float K_AUX14 = 797;
const float K_AUX15 = 798;
const float K_AUX16 = 799;
const float K_AUX17 = 800;
const float K_AUX18 = 801;
const float K_AUX19 = 802;
const float K_AUX20 = 803;
const float K_AUX21 = 804;
const float K_AUX22 = 805;
const float K_AUX23 = 806;
const float K_AUX24 = 807;
const float K_AUX25 = 808;
const float K_AUX26 = 809;
const float K_AUX27 = 810;
const float K_AUX28 = 811;
const float K_AUX29 = 812;
const float K_AUX30 = 813;
const float K_AUX31 = 814;
const float K_AUX32 = 815;
const float K_PAUSE = 153;
const float K_MWHEELUP = 515;
const float K_MWHEELDOWN = 516;
const float K_PRINTSCREEN = 174;
const float K_CAPSLOCK = 155;
const float K_SCROLLLOCK = 156;
const float K_SEMICOLON = 59;
const float K_PLUS = 43;
const float K_TILDE = 126;
const float K_BACKQUOTE = 96;
const float K_BACKSLASH = 92;

const float K_DPAD_UP = 816;
const float K_DPAD_DOWN = 817;
const float K_DPAD_LEFT = 818;
const float K_DPAD_RIGHT = 819;
const float K_LBUMPER = 824;
const float K_RBUMPER = 825;
const float K_B = 827;
const float K_A = 826;
const float K_START = 820;
const float K_RJOY_UP = 836;
const float K_RJOY_DOWN = 837;
const float K_RJOY_LEFT = 838;
const float K_RJOY_RIGHT = 839;