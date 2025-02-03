// ps_gh_electrocution
//
// Looks for creatures within a certain radius of a waypoint,
// then "electrocutes" them, without doing any damage.

void main()
{
	object oWP = GetNearestObjectByTag("WP_Electrocute");
		location lLoc = GetLocation(oWP);
	object oTarget = GetFirstObjectInShape(SHAPE_CUBE, 5.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	
	PlaySound("as_sw_lever1");
	// * note that nActive == 1 does  not necessarily mean the placeable is active
	// * that depends on the initial state of the object
	int nActive = GetLocalInt (OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE");
	// * Play Appropriate Animation
	if (!nActive)
   {
     ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
		object oVFX1 = GetObjectByTag("electrosource1");
			effect eBeam1 = EffectNWN2SpecialEffectFile("sp_arc_of_lightning",oVFX1);
		object oVFX2 = GetObjectByTag("electrosource2");
			effect eBeam2 = EffectNWN2SpecialEffectFile("sp_arc_of_lightning",oVFX2);
			while (GetIsObjectValid(oTarget))
		{
			// Effects go here.
			DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oTarget,3.0f));
			DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2,oTarget,3.0f));
			PlaySound("al_mg_jacobs1");
			oTarget = GetNextObjectInShape(SHAPE_CUBE, 5.0, lLoc, FALSE, OBJECT_TYPE_CREATURE);
		}
	}
	else
	{
     	ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
		SpeakString("*Recharging electricity nodes...*",TALKVOLUME_TALK);
	}
      // * Store New State
	SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",!nActive);

}