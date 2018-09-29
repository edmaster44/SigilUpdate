//::///////////////////////////////////////////////
//:: Summon Fiend
//:: nx_s2_summon_planetar.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Just like Summon Creature IX, but summons a Nycaloth Mercenary.
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

	effect eSummon = EffectSummonCreature("ps_summon_hellfire1", VFX_INVOCATION_VITRIOLIC_DOOM);
	//SpeakString("Moo!  I am a planetar.  Or a placeholder creature template.  Take your pick.");
	
    //Check for metamagic extend
	int nCasterLvl = GetHitDice(OBJECT_SELF);
	int nDuration = GetHitDice(OBJECT_SELF) + 3;
    if (nCasterLvl < 17)
	{
		SendMessageToPC(OBJECT_SELF, "You cannot use this ability until level 17.");
	}
	else
	{
	    //Apply VFX impact and summon effect
	    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
	}
}