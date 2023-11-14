

void LocalPlayer()
{
	vPlayerVelocity = vlen(pmove_org - vPlayerOrigin) * 200;
	vPlayerOrigin = pmove_org;

	if(isRunning && vPlayerVelocity > 150)
	{
		cvar_set("v_idlescale", ftos(lerp(cvar("v_idlescale"), 3, 4 * frametime)));
	}
	else 
	{
		cvar_set("v_idlescale", ftos(lerp(cvar("v_idlescale"), 0, 8 * frametime)));
	}
	
	input_movevalues = normalize(input_movevalues) * cvar("cl_forwardspeed"); //strafe speed
	setproperty(VF_CL_VIEWANGLES, input_angles + [ view_punchangle_x * 3 * frametime, view_punchangle_y * 3 * frametime]); //recoil
	setproperty(VF_CL_VIEWANGLES, input_angles + [ view_punchangle_x * 3 * frametime, view_punchangle_y * 3 * frametime]); //recoil
}