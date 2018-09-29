//::///////////////////////////////////////////////
//:: Planar Binding
//:: NW_S0_Planar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment, or
    holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = GetCasterLevel(OBJECT_SELF);
	int nSaveDC = GetSpellSaveDC();
	int nHD = 12 + nCasterLevel/2;
	int nLawChaos = GetAlignmentLawChaos(OBJECT_SELF);
	int nGoodEvil = GetAlignmentGoodEvil(OBJECT_SELF);
    effect eSummon;
    //effect eGate;
    effect eDur = EffectVisualEffect( VFX_DUR_PARALYZED );
    //effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    //effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eLink = EffectLinkEffects(eDur, EffectCutsceneDominated());
    //eLink = EffectLinkEffects(eLink, eDur2);
    //eLink = EffectLinkEffects(eLink, eDur3);

    object oTarget = GetSpellTargetObject();
    int nRacial = GetRacialType(oTarget);
	int nLawChaosT = GetAlignmentLawChaos(oTarget);
	int nGoodEvilT = GetAlignmentGoodEvil(oTarget);
	
	//Determine DC Adjustments
	if(nLawChaos == nLawChaosT)
	{
		nSaveDC = nSaveDC + 4;
	}
	if(nGoodEvil == nGoodEvilT)
	{
		nSaveDC = nSaveDC + 4;
	}
	if(nLawChaos == ALIGNMENT_CHAOTIC && nLawChaosT == ALIGNMENT_LAWFUL || nLawChaos == ALIGNMENT_LAWFUL && nLawChaosT == ALIGNMENT_CHAOTIC)
	{
		nSaveDC = nSaveDC - 4;
		if(nGoodEvil == ALIGNMENT_NEUTRAL && nGoodEvilT == ALIGNMENT_NEUTRAL)
		{
			nSaveDC = nSaveDC - 4;
		}
	}
	if(nGoodEvil == ALIGNMENT_EVIL && nGoodEvilT == ALIGNMENT_GOOD || nGoodEvil == ALIGNMENT_GOOD && nGoodEvilT == ALIGNMENT_EVIL)
	{
		nSaveDC = nSaveDC - 4;
	}
	
    if(nDuration == 0)
    {
        nDuration = 1;
    }

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
    //Check to see if the target is valid
    if (GetIsObjectValid(oTarget))
    {
    	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_PLANAR_BINDING));
            //Check to make sure the target is an outsider
            if(nRacial == RACIAL_TYPE_OUTSIDER || nRacial == RACIAL_TYPE_ELEMENTAL)
            {
				//Max HD possible
				if(GetHitDice(oTarget) <= nHD)
				{
                //Make a will save
	                if(!WillSave(oTarget, nSaveDC))
	                {
						if (GetIsPC(oTarget))
							ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration/4));
						else
						{
	                    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration/2));
						}
	                }
				}
				else
				{
					SendMessageToPC(OBJECT_SELF, "Target Hit Dice exceeds your maximum!");
				}
            }
        }
    }
}