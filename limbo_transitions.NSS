#include "x0_i0_transport"
string GetLimboTransition(string sTag)
{
	object oHolder = GetObjectByTag("limbo_transitionmanager");
	return (GetLocalString(oHolder, sTag));
}

string GetLimboDescription(string sTag)
{
	string sDest = GetLimboTransition(sTag);
	if (sDest == "limbo_blocked")
		return "The way has closed behind you, and you cannot go this way.";
		
	else if (sTag == "ruinswhirlwind" && sDest == "wp_limbo_airstairs")
		return "The whirlwind sweeps you up and deposits you on a small island in the sea of chaos.";
	else if (sTag == "ruinsdive" && sDest == "wp_limbo_stormcave")
		return "You dive down into the water, and are pulled along by the currents. Eventually you see light ahead, and emerge in a sea cave.";
	else if (sTag == "stormwhirlwind" && sDest == "wp_limbo_hermitage")
		return "The whirlwind sweeps you up and deposits you near some old ruins of once-stabilized limbo.";
	else if (sTag == "stormstairs" && sDest == "wp_limbo_firecave")
		return "You climb the stairs and eventually come to the mouth of a 'cave' in a giant chunk of rock.";
	else if (sTag == "firepit" && sDest == "wp_limbo_earthcave")
		return "You dive down into the fire pit, and fall for what seems like forever. Eventually you hit rock.";
	else if (sTag == "airstairs" && sDest == "wp_limbo_stormwhirlwind")
		return "You climb the stairs for a few hundred steps, and then a strong gust of wind sweeps you off your feet, and deposits you on a small island.";
	else if (sTag == "hermitageout" && sDest == "wp_limbo_stormwhirlwind")
		return "You leap into the sea of chaos, and are caught up in a whirlwind. Eventually you are deposited on a storm-wracked island.";
	
	else if (sTag == "ruinswhirlwind" && sDest == "wp_limbo_stormwhirlwind")
		return "The whirlwind sweeps you up and deposits you on a storm-wracked island.";
	else if (sTag == "ruinsdive" && sDest == "wp_limbo_airstairs")
		return "You dive down into the water, but before you touch the waves, a whirlwind sweeps you up and deposits you on a small island in the sea of chaos.";
	else if (sTag == "earthin" && sDest == "wp_limbo_hermitage")
		return "You step out again into the chaos of limbo, and fall, or fly, for a very long time before coming upon some old ruins of once-stabilized limbo.";
	else if (sTag == "stormwhirlwind" && sDest == "wp_limbo_ruinswhirlwind")
		return "The whirlwind sweeps you up and deposits you on a chain of islands, covered in ruins of once-stabilized limbo.";
	else if (sTag == "firepit" && sDest == "wp_limbo_airstairs")
		return "You dive down into the fire pit, and fall for what seems like forever. Then a gust of wind picks you up, and deposits you on a small island.";
	else if (sTag == "airstairs" && sDest == "wp_limbo_hermitage")
		return "You climb the stairs for what seems like forever, and then they simply end near the ruins of once-stabilized limbo.";
	else if (sTag == "hermitageout" && sDest == "wp_limbo_earthout")
		return "You leap into the sea of chaos, and are caught up in a whirlwind. Eventually you find yourself at the mouth of a cave.";
		
	else if (sTag == "ruinsdive" && sDest == "wp_limbo_firestairs")
		return "You dive down into the water, but before you touch the waves, a whirlwind sweeps you up and deposits you on the remnants of a stair leading to a fire-dominated area.";	
	else if (sTag == "earthin" && sDest == "wp_limbo_stormstairs")
		return "You leave the cave, and descend a long set of stairs. The stairs end at a storm-wracked island.";
	else if (sTag == "stormwhirlwind" && sDest == "wp_limbo_airstairs")
		return "The whirlwind sweeps you up and deposits you on a small island.";
	else if (sTag == "stormstairs" && sDest == "wp_limbo_earthin")
		return "You climb the stairs and eventually come to the mouth of a 'cave' in a giant chunk of rock.";
	else if (sTag == "firestairs" && sDest == "wp_limbo_hermitage")
		return "You climb the stairs for what seems like forever, and then they simply end near the ruins of once-stabilized limbo.";
	else if (sTag == "firepit" && sDest == "wp_limbo_ruinswhirlwind")
		return "You dive down into the pit of fire, and fall for hundreds of feet before a whirlwind sweeps you up and deposits you near some ruins.";
	else if (sTag == "hermitageout" && sDest == "wp_limbo_firestairs")
		return "You leap into the sea of chaos, and are caught up in a whirlwind. You eventually find yourself on the remnants of a stair leading to a fire-dominated area. ";
	
	else if (sTag == "ruinswhirlwind" && sDest == "wp_limbo_firestairs")
		return "The whirlwind sweeps you up and deposits you on the remnants of a stair leading to a fire-dominated area.";	
	else if (sTag == "ruinsdive" && (sDest == "wp_limbo_earthcave" || sDest == "wp_limbo_earthin"))
		return "You dive down into the water, and are pulled along by the currents. Eventually the lake ends, and you emerge in a cave.";
	else if (sTag == "earthout" && sDest == "wp_limbo_stormwhirlwind")
		return "You step out of the cave, and back into the sea of limbo. A whirlwind sweeps you up and deposits you on a storm-wracked island.";
	else if (sTag == "stormwhirlwind" && sDest == "wp_limbo_earthout")
		return "The whirlwind sweeps you up and deposits you next to a cave in a chunk of rock.";
	else if (sTag == "stormstairs" && sDest == "wp_limbo_firestairs")
		return "You climb the stairs and emerge from the storm, only to find yourself at the edge of a fire dominated area.";
	else if (sTag == "firestairs" && sDest == "wp_limbo_ruinswhirlwind")
		return "You climb the stairs and emerge in the sea of limbo. A gust of wind pushes you along, and eventually leaves you near ruins of once-stabilized land.";
	
	else if (sTag == "ruinscave" && sDest == "wp_limbo_firestairs")
		return "You go through the arch of rock, and find yourself on a set of stairs leading down into a fire-dominated area.";
	else if (sTag == "firestairs" && sDest == "wp_limbo_ruinscave")
		return "You climb the stairs, and come to an arch of rock. Stepping through it, you find yourself near the ruins of once-stabilized limbo.";
	else if (sTag == "firepit" && sDest == "wp_limbo_stormwhirlwind")
		return "You dive down through the fire, and are caught up in a storm. You eventually find yourself once again on land.";
	else if (sTag == "hermitageout" && sDest == "wp_limbo_ruinswhirlwind")
		return "You leap into the sea of chaos, and are caught up in a whirlwind. Eventually you are deposited near the ruins of once-stabilized limbo.";
	
	else if (sTag == "ruinswhirlwind" && sDest == "wp_limbo_hermitage")
		return "The whirlwind sweeps you up and deposits you near the ruins of once-stabilized limbo.";
	else if (sTag == "ruinsdive" && sDest == "wp_limbo_stormwhirlwind")
		return "You leap off the log, only to be swept up by a whirlwind and deposited on a storm-wracked island.";
	else if (sTag == "stormstairs" && sDest == "wp_limbo_firepit")
		return "You climb the stairs, and get above the storm. The lashing rain is replaced by dripping lava, and you emerge in a lake of fire.";
	else if (sTag == "hermitageout" && sDest == "wp_limbo_earthcave")
		return "You leap once again into the sea of limbo, and get caught in a downdraft that sweeps you into a chasm.";
	return "";
}

void main ()
{
	object oPC = GetLastUsedBy();
	string sWP = GetLimboTransition(GetTag(OBJECT_SELF));
	//SendMessageToPC(oPC, "You should be going here: "+sWP);
	object oWP = GetWaypointByTag(sWP);
	TransportToWaypoint(oPC, oWP);
	string sText = GetLimboDescription(GetTag(OBJECT_SELF));
	if (sText != "")
		SendMessageToPC(oPC, sText);
}