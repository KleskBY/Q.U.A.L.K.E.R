

void LocalPlayer()
{
	deltaTime = time - lastFrame;
	lastFrame = time;
	vPlayerVelocity = vlen(pmove_org - vPlayerOrigin) * 200;
	vPlayerOrigin = pmove_org;

	if(isRunning && vPlayerVelocity > 150)
	{
		cvar_set("v_idlescale", ftos(lerp(cvar("v_idlescale"), 3, 4 * deltaTime)));
	}
	else 
	{
		cvar_set("v_idlescale", ftos(lerp(cvar("v_idlescale"), 0, 8 * deltaTime)));
	}
	
	input_movevalues = normalize(input_movevalues) * cvar("cl_forwardspeed"); //strafe speed
	setproperty(VF_CL_VIEWANGLES, input_angles + [ view_punchangle_x * 3 * deltaTime, view_punchangle_y * 3 * deltaTime]); //recoil

	if(player)
	{
		makevectors(input_angles);
		player.angles = [0, input_angles_y, 0 ];
		traceline(player.origin, player.origin + '0 0 264', false, world);
		float len = vlen(trace_endpos - self.origin);
		print(ftos(len), "\n");
		print(vtos(trace_endpos), "\n");
		addentity(player);
		runstandardplayerphysics(player);
		setorigin(player, pmove_org);
		// player.origin_z = trace_endpos_z;
		// setorigin(player, player.origin + v_forward * input_movevalues_x * 0.01);
	}

	// if(vlen(pmove_org - vPlayerOrigin) > 200) vPlayerOrigin = pmove_org;
	// else vPlayerOrigin = lerpv(vPlayerOrigin, pmove_org, 15 * deltaTime);
	// setproperty( VF_ORIGIN, vPlayerOrigin + [ 0, 0, getstati( STAT_VIEWHEIGHT ) ] );
}