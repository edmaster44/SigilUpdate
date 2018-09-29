//::///////////////////////////////////////////////
//:: Summon Celestial
//:: nx_s2_summon_planetar.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Just like Summon Creature IX, but summons an Astral Deva.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/22/2007
//:: Edited By: Xndar
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	if (GetHitDice(OBJECT_SELF) < 17 && GetIsPC(OBJECT_SELF)) // just so that only PC celestials are restricted - have no idea if we have any NPC half-celestials, but just to make sure
	{
		SendMessageToPC(OBJECT_SELF, "You cannot use this ability until level 17.");
	}
	else
	{
		effect eSummon = EffectSummonCreature("ps_summon_gategood", VFX_HIT_AOE_HOLY);
		//SpeakString("Moo!  I am a planetar.  Or a placeholder creature template.  Take your pick.");
		
	    //Check for metamagic extend
		int nDuration = GetHitDice(OBJECT_SELF) + 3;
	    int nMetaMagic = GetMetaMagicFeat();
	    if (nMetaMagic == METAMAGIC_EXTEND)
	    {
	        nDuration = nDuration *2;	//Duration is +100%
	    }
		
	    //Apply VFX impact and summon effect
	    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));

	}
}