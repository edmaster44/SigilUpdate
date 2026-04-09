//::///////////////////////////////////////////////
//:: [Power Word Stun]
//:: [NW_S0_PWStun.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature is stunned for a certain number of
    rounds depending on its HP.  No save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 4, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.28
- =151HP stunned for 4d4 rounds
- >151HP sometimes stunned for indefinit duration
*/


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
	object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nHP =  GetCurrentHitPoints(oTarget);
    effect eStun = EffectStunned();
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_ENCHANTMENT );
	effect eDur = EffectVisualEffect( VFX_DUR_STUN );
	eStun = EffectLinkEffects( eStun, eDur );
    int nDuration;
    int nMetaMagic = GetMetaMagicFeat();
    int nMeta;
	
	int iTargetMaxHP = GetMaxHitPoints(oTarget);
	int iTargetHPHigh = 151;
	int iTargetHPMed = 101;
	int iTargetHPLow = 51;
	
	if (GetIsPC(oTarget) == FALSE)
	{
		// 50% of max or original value, whichever is higher.
		int iPercentOfMaxHigh = FloatToInt(IntToFloat(iTargetMaxHP) * 0.5);
		if (iPercentOfMaxHigh > iTargetHPHigh)
			iTargetHPHigh = iPercentOfMaxHigh;
		
		// 33% of max or original value, whichever is higher.
		int iPercentOfMaxMed = FloatToInt(IntToFloat(iTargetMaxHP) * 0.33);
		if (iPercentOfMaxMed > iTargetHPMed)
			iTargetHPHigh = iPercentOfMaxHigh;
			
		// 17% of max or original value, whichever is higher.
		int iPercentOfMaxLow = FloatToInt(IntToFloat(iTargetMaxHP) * 0.17);
		if (iPercentOfMaxLow > iTargetHPLow)
			iTargetHPLow = iPercentOfMaxLow;
	}
	
	
    //Determine the number rounds the creature will be stunned
    if (nHP >= iTargetHPHigh)
    {
        nDuration = 0;
        nMeta = 0;
    }
    else if (nHP >= iTargetHPMed && nHP <= iTargetHPHigh)
    {
        nDuration = d4(1);
        nMeta = 4;
    }
    else if (nHP >= iTargetHPLow  && nHP <= iTargetHPMed)
    {
        nDuration = d4(2);
        nMeta = 8;
    }
    else
    {
        nDuration = d4(4);
        nMeta = 16;
    }

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDuration = nMeta;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POWER_WORD_STUN));
        //Make an SR check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            if (nDuration>0)
            {
                //Apply linked effect and the VFX impact
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nDuration));
            }
			else
			{
				SendMessageToPC(oPC, "<COLOR=red>Target has too many HPs to be affected.");
			}
        }
    }
}