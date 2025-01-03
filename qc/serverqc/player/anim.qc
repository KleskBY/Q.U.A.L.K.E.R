



float PLAYER_IDLE_START_FRAME = 0;
float PLAYER_IDLE_END_FRAME = 0;
float PLAYER_CROUCH_IDLE_START_FRAME = 42;
float PLAYER_CROUCH_IDLE_END_FRAME = 42;
float PLAYER_IDLE_END_FRAME = 0;
float PLAYER_WALK_START_FRAME = 1;
float PLAYER_WALK_END_FRAME = 37;
float PLAYER_RUN_START_FRAME = 1;
float PLAYER_RUN_END_FRAME = 37;

float PLAYER_CROUCH_START_FRAME = 43;
float PLAYER_CROUCH_END_FRAME = 73;


float PLAYER_ANIM_TIME = 0.03; //30fps
.float next_frame;
void PlayerAnimation()
{
	if(self.next_frame > time) return;
	self.next_frame = time + PLAYER_ANIM_TIME;
	self.frame = self.frame + 1;
	if(self.running) self.frame = self.frame + 1;
	
	if (fabs(self.velocity_x) > 15 || fabs(self.velocity_y) > 15)
	{
		if(self.running)
		{
			if (self.frame >= PLAYER_RUN_END_FRAME || self.frame < PLAYER_RUN_START_FRAME) self.frame = PLAYER_RUN_START_FRAME;
		}
		else if(self.crouching)
		{
			if (self.frame >= PLAYER_CROUCH_END_FRAME || self.frame < PLAYER_CROUCH_START_FRAME) self.frame = PLAYER_CROUCH_START_FRAME;
		}
		else
		{
			if (self.frame >= PLAYER_WALK_END_FRAME || self.frame < PLAYER_WALK_START_FRAME) self.frame = PLAYER_WALK_START_FRAME;
		}
	}
	else 
	{
		if(self.crouching)
		{
			self.frame = PLAYER_CROUCH_IDLE_START_FRAME;
		}
		else
		{
			if (self.frame >= PLAYER_IDLE_END_FRAME || self.frame < PLAYER_IDLE_START_FRAME) self.frame = PLAYER_IDLE_START_FRAME;
		}
	}
};