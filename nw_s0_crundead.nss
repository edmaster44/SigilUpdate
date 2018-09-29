//::///////////////////////////////////////////////
//:: Create Undead
//:: NW_S0_CrUndead.nss
//:: Copyright (c) 2005 Obsidian Entertainment
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Update By: Alersia
//:: Update On: 28/02/16
//:: Changed summoned creatures
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{
    if (!X2PreSpellCastCode())
    {       return;    }

    //Declare major variables, 

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
    if (iCasterlevel <= 12)
    {
        // Mummy
		eSummon = EffectSummonCreature("ps_sum_createun_6", VFX_FNF_SUMMON_UNDEAD);
    }
    else
    {
        // Mummy Cleric      
		eSummon = EffectSummonCreature("ps_sum_createun_7", VFX_FNF_SUMMON_UNDEAD);
    }   
		
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(iDuration));
}


/*
void main()
{

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	
    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel;
	int nRoll = d3();
    //nDuration = 24;
    effect eSummon;

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
    //Set the summoned undead to the appropriate template based on the caster level
    if (nCasterLevel <= 11)
    {
        eSummon = EffectSummonCreature("c_ghoul",VFX_HIT_SPELL_SUMMON_CREATURE);
    }
    else if ((nCasterLevel >= 12) && (nCasterLevel <= 13))
    {
        eSummon = EffectSummonCreature("c_ghast",VFX_HIT_SPELL_SUMMON_CREATURE);
    }
    else if ((nCasterLevel >= 14) && (nCasterLevel <= 15))
    {
        eSummon = EffectSummonCreature("c_mummy",VFX_HIT_SPELL_SUMMON_CREATURE); 
    }
    else if ((nCasterLevel >= 16))
    {
        eSummon = EffectSummonCreature("c_mummylord",VFX_HIT_SPELL_SUMMON_CREATURE);
    }*/

	/*switch (nRoll)
	{
		case 1:
			eSummon = EffectSummonCreature("c_s_mummy", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;
		case 2:
			eSummon = EffectSummonCreature("ps_crundead_wraith", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;
		case 3:
			eSummon = EffectSummonCreature("c_s_ghast", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;
        default: 
			eSummon = EffectSummonCreature("c_s_mummy", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;
	}
	
    //Apply VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
}
*/