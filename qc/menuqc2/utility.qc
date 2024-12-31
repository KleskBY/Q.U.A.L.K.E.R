float dot(vector a, vector b)
{
	return a_x*b_x + a_y*b_y + a_z*b_z;
}
vector vecmul(vector a, vector b)
{
	return [a_x*b_x, a_y*b_y, a_z*b_z];
}
float tan(float x)
{
	return sin(x)/cos(x);
}
float exp(float x)
{
	x = 1 + x / 256;
	x *= x;  x*= x; x *= x; x *= x;
	x *= x;  x*= x; x *= x; x *= x;
	return x;
}

string KeyMap(float keynum) 
{
   local string chrlist, key;

   if(keynum == 32)
      key = " ";
   else
   if(keynum >= 39 && keynum <= 61)
   {
      chrlist = "'  *+,-./0123456789 ; =";   
      key = substring(chrlist, keynum - 39, 1);
   }
   else
   if(keynum <= -39 && keynum >= -61)
   {
      chrlist = "\"    <_>?)!@#$%^&*( : +";
      key = substring(chrlist, (-keynum) - 39, 1);
   }
   else
   if(keynum >= 65 && keynum <= 90)
   {
      chrlist = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      key = substring(chrlist, keynum - 65, 1);
   }
   else
   if(keynum >= 91 && keynum <= 93)
   {
      chrlist = "[\\]";
      key = substring(chrlist, keynum - 91, 1);
   }
   else
   if(keynum <= -91 && keynum >= -93)
   {
      chrlist = "{|}";
      key = substring(chrlist, (-keynum) - 91, 1);
   }   
   else
   if(keynum >= 97 && keynum <= 122)
   {
      chrlist = "abcdefghijklmnopqrstuvwxyz";
      key = substring(chrlist, keynum - 97, 1);
   }

   return key;
}

float(float f, float flag) CheckFlag
{
	if(f & flag) return TRUE;
	return FALSE;
}

float(float f, float m) modm
{
	if(m==0) return 0;
	return (f-floor(f/m)*m);
}

float(float num, float dig) GetDigit
{
	if(dig<1 || dig>7) return 0;
	return mod(floor(num/pow(10, dig-1)), 10);
}
float isinbox(vector v1, vector st, vector en)
{
	if(v1_x >= st_x && v1_x <= en_x && v1_y >= st_y && v1_y <= en_y) return true;
	return false;
}

float radians(float x)
{
	return x * M_PI / 180;
}