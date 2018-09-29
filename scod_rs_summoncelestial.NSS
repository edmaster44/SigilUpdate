//::///////////////////////////////////////////////
//:: Summon Fiend
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

	effect eSummon = EffectSummonCreature("ps_summon_halfcelestial", VFX_HIT_AOE_HOLY);
	//SpeakString("Moo!  I am a planetar.  Or a placeholder creature template.  Take your pick.");
	
    //Check for metamagic extend
	int nCasterLvl = GetHitDice(OBJECT_SELF);
	int nDuration = GetHitDice(OBJECT_SELF) + 3;
    if (nCasterLvl < 17)
	{
		SendMessageToPC(OBJECT_SELF, "You cannot yet use this ability.");
	}
	else
	{
    	//Apply VFX impact and summon effect
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
	}
}