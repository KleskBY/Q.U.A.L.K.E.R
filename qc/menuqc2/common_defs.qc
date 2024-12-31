.entity		next;
.entity		previous;
.entity		closer = next;
.entity		further = previous;
.vector		mins, maxs;		// bounding box extents reletive to origin
.vector		ideal_pos;
.vector		size;			// maxs - mins
.entity		chain;
.entity		elements = chain;
.entity		animations;
.string		netname;
.string		text = netname;
.string		name = netname;
.float		flags;
.float		effects;
.entity		owner;		// who launched a missile
.entity		container = owner;
.vector		origin;			// ***
.vector		view_ofs;
.vector		velocity;
.vector		angles;
.vector		color;
.vector		content_origin=angles;
.vector		avelocity;
.vector		content_size=avelocity;
.vector		v_angle;
.float		scale;
.float		fontsize = scale;
.float		animation_duration = scale;
.float		radius;


.float		solid;
.float		team;
.float		object_type;
.float		action_start;
.float		animation_start;
.float		font = animation_start;
.float		movetype; 
.float		is_active = movetype;
.float		skin;
.float		handles_input = skin;

.float		frame;
.float		scroll = frame;
.float		minvalue;
.float		maxvalue;
.float		rendered;

.float		frags;
.float		animation_ended = frags;
.float		stack = frags;

.float		scrollpercent;
.float		align = scrollpercent;


.float 		index;
.float		enabled = index;

entity		self;
//entity		other;
entity		world;

float		time;
float		frametime;
.void()		touch;
.void()		use;
.void()		think;
.void()		blocked;		// for doors or plats, called when can't push other
.float		nextthink;
.void()		draw = blocked;
.void()		animate = blocked;
.void()		input = use;
.void()		next_action = touch;
.string		model;
.float		alpha;