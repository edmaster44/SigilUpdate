//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: The Dead Walk(!)
//:: nw_s0_icharm.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
        5.7.2.5	Dead Walk, The
        Complete Arcane, pg. 133
        Spell Level:	4
        Class: 		Misc

        This functions identically to the animate dead spell (3rd level wizard).

        [Rules Note] There is a gem component to make the animated creatures 
        last more than 1 minute per level. Special component rules for spells 
        don't exist in NWN2.

*/
// AFW-OEI 06/02/2006:
//	Update creature blueprints
// RPGplayer1 12/20/08 - Changed to match updated Animate Dead spell
// MimiFearthegn 8/11/2020 - Changed to allow scaling past 10th level

#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{

    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables, 
	//counts Spellcaster levels and Palemaster levels

	int iMetaMagic = GetMetaMagicFeat();
	int iCasterlevel = GetWarlockCasterLevel(OBJECT_SELF);
    int iDuration = GetWarlockCasterLevel(OBJECT_SELF);
	
	// Duration 	
	if (iMetaMagic == METAMAGIC_EXTEND)
    {
        iDuration = iDuration * 2;	//Duration is +100%
    }
			
	effect eSummon;	
				
    //Summon the appropriate creature based on the summoner level
    if (iCasterlevel <= 6) {
	
        // Skeleton, Warrior
		eSummon = EffectSummonCreature("ps_sum_animate_3", VFX_FNF_SUMMON_UNDEAD);
		
    } else if (iCasterlevel <= 8) {
	
        // Zombie, Spellstitched  
		eSummon = EffectSummonCreature("ps_sum_animate_4", VFX_FNF_SUMMON_UNDEAD);
		
    } else if (iCasterlevel <= 10) {
	
        // Skeleton, Bonecrusher        
		eSummon = EffectSummonCreature("ps_sum_animate_5", VFX_FNF_SUMMON_UNDEAD);
		
    } else if (iCasterlevel <= 12) {
	
        // Mummy, Warrior       
		eSummon = EffectSummonCreature("ps_sum_createun_6", VFX_FNF_SUMMON_UNDEAD);
		
    } else if (iCasterlevel <= 14) {
	
        // Mummy, Lord     
		eSummon = EffectSummonCreature("ps_sum_createun_7", VFX_FNF_SUMMON_UNDEAD);
		
    } else {
	
        // Blashpheme, Lurking Terror    
		eSummon = EffectSummonCreature("ps_sum_creategun_8", VFX_FNF_SUMMON_UNDEAD);
		
	}
		
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(iDuration));
}