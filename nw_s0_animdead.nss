//::///////////////////////////////////////////////
//:: Animate Dead
//:: NW_S0_AnimDead.nss
//:: Copyright (c) 2001 Bioware Corp.
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
    if (iCasterlevel <= 6)
    {
        // Skeleton, Warrior
		eSummon = EffectSummonCreature("ps_sum_animate_3", VFX_FNF_SUMMON_UNDEAD);
    }
    else if ((iCasterlevel >= 7) && (iCasterlevel <= 8))
    {
        // Zombie, Spellstitched  
		eSummon = EffectSummonCreature("ps_sum_animate_4", VFX_FNF_SUMMON_UNDEAD);
    }
    else
    {
        // Skeleton, Bonecrusher        
		eSummon = EffectSummonCreature("ps_sum_animate_5", VFX_FNF_SUMMON_UNDEAD);
    }   
		
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(iDuration));
}

/*
void main()


{
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  


    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    int nDuration = PS_GetCasterLevel(OBJECT_SELF);
	int nRoll = d2();
    //nDuration = 24;	// AFW-OEI 06/02/2006: No longer lasts 24 hours.
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon;
    //Metamagic extension if needed
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;	//Duration is +100%
    }
    //Summon the appropriate creature based on the summoner level
    /*if (nCasterLevel <= 5)
    {
        // Skeleton
		eSummon = EffectSummonCreature("c_skeleton", VFX_FNF_SUMMON_UNDEAD);
    }
    else if ((nCasterLevel >= 6) && (nCasterLevel <= 9))
    {
        // Zombie
		eSummon = EffectSummonCreature("c_zombie", VFX_FNF_SUMMON_UNDEAD);
    }
    else
    {
        // Skeleton Warrior
		eSummon = EffectSummonCreature("c_skeletonwarrior", VFX_FNF_SUMMON_UNDEAD);
    }
		
    switch (nCasterLevel)
	{
		case 7: case 8:
		{
			eSummon = EffectSummonCreature("ps_animate_dead_7", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;
		}
		case 9: case 10:
		{	eSummon = EffectSummonCreature("ps_animate_dead_9", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 11: case 12:
		{	eSummon = EffectSummonCreature("ps_animate_dead_11", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 13: case 14:
		{	eSummon = EffectSummonCreature("ps_animate_dead_13", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 15: case 16:
		{	eSummon = EffectSummonCreature("ps_animate_dead_15", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 17: case 18:
		{	eSummon = EffectSummonCreature("ps_animate_dead_17", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 19: case 20:
		{	eSummon = EffectSummonCreature("ps_animate_dead_19", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 21: case 22:
		{	eSummon = EffectSummonCreature("ps_animate_dead_21", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 23: case 24:
		{	eSummon = EffectSummonCreature("ps_animate_dead_23", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 25: case 26:
		{	eSummon = EffectSummonCreature("ps_animate_dead_25", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 27: case 28:
		{	eSummon = EffectSummonCreature("ps_animate_dead_27", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 29: case 30:
		{	eSummon = EffectSummonCreature("ps_animate_dead_29", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 31: case 32:
		{	eSummon = EffectSummonCreature("ps_animate_dead_31", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 33: case 34:
		{	eSummon = EffectSummonCreature("ps_animate_dead_33", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 35: case 36:
		{	eSummon = EffectSummonCreature("ps_animate_dead_35", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 37: case 38:
		{	eSummon = EffectSummonCreature("ps_animate_dead_37", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
		case 39: case 40:
		{	eSummon = EffectSummonCreature("ps_animate_dead_39", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
	    default: 
		{	eSummon = EffectSummonCreature("ps_animate_dead_5", VFX_HIT_SPELL_SUMMON_CREATURE);
			break;}
	}
		
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
}


/*