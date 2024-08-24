

void LocalPlayer()
{
	vPlayerVelocity = vlen(pmove_org - vPlayerOrigin) * 200;
	vPlayerOrigin = pmove_org;

	if(isRunning && cvar("cl_forwardspeed") > 120 && input_movevalues_x > 1 /*&& vPlayerVelocity > 50*/)
	{
		cvar_set("v_idlescale", ftos(Lerp(cvar("v_idlescale"), 3, 4 * frametime)));
		// cvar_set("chase_back", ftos(lerp(cvar("chase_back"), -25, 4 * frametime)));
		
		cvar_set("v_ipitch_cycle", "25");
		cvar_set("v_iroll_cycle", "12");
		cvar_set("v_iyaw_cycle", "12");
		cvar_set("v_iyaw_level", "0.25");
		cvar_set("v_ipitch_level", "0.25");
	}
	else 
	{
		cvar_set("v_idlescale", ftos(Lerp(cvar("v_idlescale"), 0.35, 6 * frametime)));
		// cvar_set("chase_back", ftos(lerp(cvar("chase_back"), -15, 4 * frametime)));
		
		cvar_set("v_ipitch_cycle", ".5");
		cvar_set("v_iroll_cycle", "0.5");
		cvar_set("v_iyaw_cycle", "2");
		cvar_set("v_iyaw_level", "0.3");
		cvar_set("v_ipitch_level", "0.1");
	}
		
	input_movevalues = normalize(input_movevalues) * cvar("cl_forwardspeed"); //strafe speed
	setproperty(VF_CL_VIEWANGLES, input_angles + [ view_punchangle_x * 3 * frametime, view_punchangle_y * 3 * frametime]); //recoil
	setproperty(VF_CL_VIEWANGLES, input_angles + [ view_punchangle_x * 3 * frametime, view_punchangle_y * 3 * frametime]); //recoil
}