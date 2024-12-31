


////////////////////////////////
/////////// GLOBALS ////////////
////////////////////////////////


float current_health, current_ammo, current_weapon;
float showScores;
float completedTime;
float isRunning;


float showInventory;

vector vPlayerOrigin;
float vPlayerVelocity;

float lerp(float a, float b, float factor)
{
    return a * (1.0 - factor) + (b * factor);
}
vector lerpv(vector a, vector b, float factor)
{
    return a * (1.0 - factor) + (b * factor);
}
