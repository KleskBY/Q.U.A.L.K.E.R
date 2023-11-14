void(string s, ...) cmd = #46;
string(string s) str_cvar = #448;

void localsound(string sample) = 
{
	pointsound('0 0 0', sample, 1, 0);
};

float showCursor;