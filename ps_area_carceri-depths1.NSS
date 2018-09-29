#include "nw_o2_coninclude"
#include "ps_inc_functions"

void CastFleshToStone(object oSelf, object oPC)
{
	location lSelf = GetLocation(oSelf);
	location lTarget = GetLocation (oPC);;
	int nDC;
	float fDelay;
	
	effect ePetrify = EffectPetrify();
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_FLESH_TO_STONE );
    effect eLink = EffectLinkEffects(eDur, ePetrify);
	
	PlayAnimation(ANIMATION_LOOPING_CAST1, 1.0, 0.0);
	
	
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(oPC) == TRUE)
    {
		if (oPC != GetObjectByTag("ps_carceri_depths_fadspirit") && oPC != GetObjectByTag("ps_carceri_depths_fadspirit2") && oPC != GetObjectByTag("ps_carceri_depths_fadspirit3"))
		{
			nDC = GetFortitudeSavingThrow(oPC)+10;
			SpawnSpellProjectile(oSelf, oPC, lSelf, lTarget, SPELL_FLESH_TO_STONE, PROJECTILE_PATH_TYPE_HOMING_SPIRAL);
			fDelay = GetProjectileTravelTime(lSelf, lTarget, PROJECTILE_PATH_TYPE_HOMING_SPIRAL, SPELL_FLESH_TO_STONE);
	
			if (FortitudeSave(oPC, nDC, SAVING_THROW_TYPE_NONE, oSelf) == 0
	 		&& GetDistanceBetweenLocations(lSelf, lTarget) <= 20.0
			&& GetObjectSeen(oPC, oSelf) == 1)
			{
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 180.0));
			}	
		}
		oPC = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	

}

void SpawnCreature(string nTag, location lLoc, effect eEffect)
{
	//CreateObject(OBJECT_TYPE_CREATURE, "ps_carceri_depths_sp_fadk", lLoc1)
	CreateObject(OBJECT_TYPE_CREATURE, nTag, lLoc);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lLoc);
}

void ClearAll()
{
	while (GetIsObjectValid(GetObjectByTag("ps_carceri_depths_fadspirit"))) 
		DestroyObject(GetObjectByTag("ps_carceri_depths_fadspirit"));
	while (GetIsObjectValid(GetObjectByTag("ps_carceri_depths_fadspirit2"))) 
		DestroyObject(GetObjectByTag("ps_carceri_depths_fadspirit2"));
	while (GetIsObjectValid(GetObjectByTag("ps_carceri_depths_fadspirit3"))) 
		DestroyObject(GetObjectByTag("ps_carceri_depths_fadspirit3"));
}

void main()
{
	object oPC = GetPCSpeaker();
	object oSelf = OBJECT_SELF;
	effect eEffect = EffectVisualEffect(VFX_HIT_AOE_NECROMANCY);
	object oWP1 = GetWaypointByTag("wp_fknight_carp_depths");
	object oWP2 = GetWaypointByTag("wp_fpriest_carp_depths");
	
	location lLoc1 = GetLocation(oWP1);
	location lLoc2 = GetLocation(oWP2);
	
	CastFleshToStone(oSelf, oPC);
	DelayCommand(1.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetLocation(oSelf)));
	DelayCommand(1.1, DestroyObject(oSelf));	

	
	if (GetObjectByTag("ps_carceri_depths_fadspirit") == oSelf)
	{
		DelayCommand(1.0, SpawnCreature("ps_carceri_depths_sp_fadk", lLoc1, eEffect));
		DelayCommand(1.0, SpawnCreature("ps_carceri_depths_sp_fadp", lLoc2, eEffect));
	}
	else if (GetObjectByTag("ps_carceri_depths_fadspirit2") == oSelf)
	{
		DelayCommand(1.0, SpawnCreature("ps_carceri_depths_sp_fadk2", lLoc1, eEffect));
		DelayCommand(1.0, SpawnCreature("ps_carceri_depths_sp_fadp2", lLoc2, eEffect));
	}
	else if (GetObjectByTag("ps_carceri_depths_fadspirit3") == oSelf)
	{
		DelayCommand(1.0, SpawnCreature("ps_carceri_depths_sp_fadk3", lLoc1, eEffect));
		DelayCommand(1.0, SpawnCreature("ps_carceri_depths_sp_fadp3", lLoc2, eEffect));
	}
	DelayCommand(1.2, ClearAll()); 	
}