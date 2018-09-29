//::///////////////////////////////////////////////
//:: Create Greater Undead
//:: NW_S0_CrGrUnd.nss
//:: Copyright (c) 2005 Obsidian Entertainment
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Update By: Alersia
//:: Update On: 28/02/16
//:: Changed summoned creature
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{
    if (!X2PreSpellCastCode())
    {       return;    }

    //Declare major variables, 
	//counts Spellcaster levels and Palemaster levels

	int iMetaMagic = GetMetaMagicFeat();
	int iCasterlevel = PS_GetCasterLevel(OBJECT_SELF);
    int iDuration = PS_GetCasterLevel(OBJECT_SELF);
	
	// Duration 	
	if (iMetaMagic == METAMAGIC_EXTEND)
    {
        iDuration = iDuration * 2;	//Duration is +100%
    }
			
	effect eSummon;	
				
    //Summon the appropriate creature based on the summoner level
    if (iCasterlevel <= 16)
    {
        // Blaspheme
		eSummon = EffectSummonCreature("ps_sum_creategun_8", VFX_FNF_SUMMON_UNDEAD);
    }
    else
    {
        // Dread Wraith        
		eSummon = EffectSummonCreature("ps_sum_creategun_9", VFX_FNF_SUMMON_UNDEAD);
    }   
		
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(iDuration));
}
