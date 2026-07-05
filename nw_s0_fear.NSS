//::///////////////////////////////////////////////
//:: [Fear]
//:: [NW_S0_Fear.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes an area of fear that reduces Will Saves
//:: and applies the frightened effect.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 23, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
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
	int nSaveDC, nCasterLevel;
	if (GetHasFeat(3051,oPC) && GetLocalInt(oPC, "HUCASTING")){
		int nHUlvl = GetLevelByClass(CLASS_TYPE_HALF_UNDEAD, oPC);
		int nHD = PS_GetLevel(oPC);
		nCasterLevel = nHUlvl + ((nHD - nHUlvl) / 2);
		nSaveDC = 10 + (nHD / 2) + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	} else {
		nSaveDC = GetSpellSaveDC();
		nCasterLevel = GetCasterLevel(oPC);
	}
    int nMetaMagic = GetMetaMagicFeat();
    float fDuration = RoundsToSeconds(nCasterLevel);
    int nDamage;
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	// NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_FEAR );	// NWN2 VFX
    effect eFear = EffectFrightened();
	eFear = EffectLinkEffects( eFear, eVis );
    float fDelay;

    object oTarget;
    //Check for metamagic extend
	if (nMetaMagic == METAMAGIC_EXTEND)
	{
		fDuration = fDuration * 2.0;	//Duration is +100%
	}
    //Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_NON_ALLIED, oPC))
    	{
            fDelay = GetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_FEAR));
            //Make SR Check
            if(!MyResistSpell(oPC, oTarget, fDelay))
            {
                //Make a will save
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_FEAR, oPC, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDuration));
					//DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));	// NWN1 VFX
                }
            }
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    }
}