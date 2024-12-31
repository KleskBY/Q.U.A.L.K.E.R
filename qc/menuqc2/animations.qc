void addAnimation(entity element, entity animation)
{
	animation.container = element;
	entity e = element.animations;
	if(e == world)
	{
		element.animations=animation;
		animation.previous = world;
		return;
	}
	while(e.next)
		e=e.next;
	animation.previous=e;
	e.next = animation;
}
void(entity e) deleteAnimation
{
	if(e.container.animations==e)
		e.container.animations=e.next;
	if(e.previous)
		e.previous.next=e.next;
	if(e.next)
		e.next.previous=e.previous;
	if(e.next_action)
		e.next_action();
	remove(e);
}

void(entity e) deleteAnimations
{
	entity a = e.animations;
	entity nxt;
	while(a)
	{
		nxt = a.next;
		remove(a);
		a = nxt;
	}
	e.animations = world;
}

void fadein_animation()
{
	float alph = bound(0, (gettime() - current_animation.animation_start)/current_animation.animation_duration, 1);
	alph*=current_animation.maxvalue-current_animation.minvalue;
	alph+=current_animation.minvalue;
	self.alpha = alph;
	if(alph==current_animation.maxvalue)
		deleteAnimation(current_animation);
}

entity(float start, float duration, float minval, float maxval, entity e) fadein
{
	entity a = spawn();
	a.animate = fadein_animation;
	a.animation_start = start;
	a.animation_duration = duration;
	a.minvalue = minval;
	a.maxvalue = maxval;
	addAnimation(e, a);
	return a;
}
void fadeout_animation()
{
	float alph = 1-bound(0, (gettime() - current_animation.animation_start)/current_animation.animation_duration, 1);
	alph*=current_animation.maxvalue-current_animation.minvalue;
	alph+=current_animation.minvalue;
	self.alpha = alph;
	if(alph==0)
		deleteAnimation(current_animation);
}
entity (float start, float duration, float minval, float maxval, entity e) fadeout
{
	entity a = spawn();
	a.animate = fadeout_animation;
	a.animation_start = start;
	a.animation_duration = duration;
	a.minvalue = minval;
	a.maxvalue = maxval;
	addAnimation(e, a);
	return e;
}