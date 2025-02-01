#include "ff_safevar"

//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 08/29/2008: Will ignore SR check, in case of Acid Bomb (won't work otherwise)

#include "X0_I0_SPELLS"
#include "psi_inc_psifunc"

void main()
{

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
	object oManifester = GetAreaOfEffectCreator();
    int nDamage;
    effect eDam;
    effect eVis = EffectNWN2SpecialEffectFile("fx_teleport_new.sef");
    effect eSlow = EffectMovementSpeedDecrease(50);
    object oTarget = GetEnteringObject();
    float fDelay = GetRandomDelay(1.0, 2.2);
	

    if (GetIsFriend(oTarget, oManifester))
	{
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), 14322));
        //Spell resistance check
        
            //Roll Damage
            //Enter Metamagic conditions
            
				object oDestination = GetNearestObjectByTag("psi_wormhole_wp", oTarget);
				location lTarget = GetLocation(oTarget);
                //slowing effect
				if (PS_GetLocalInt(oTarget, "DIMENSIONAL_ACHORED"))
				{
					SendMessageToPC(oTarget, "A Dimensional Anchor makes it impossible to teleport.");
					return;	
				}
				
				AssignCommand(oTarget, ActionJumpToObject(oDestination));
				ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lTarget, RoundsToSeconds(4));
               
     }       
        
    
}