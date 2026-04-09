//::///////////////////////////////////////////////
//:: Blindness and Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"    
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


    //Declare major varibles
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eBlind =  EffectNewBlindness();
    effect eDeaf = EffectDeaf();
    effect eLink = EffectVisualEffect(VFX_DUR_SPELL_BLIND_DEAF);
	
	int bImmuneBlind = GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS, OBJECT_SELF);
	int bImmuneDeaf = GetIsImmune(oTarget, IMMUNITY_TYPE_DEAFNESS, OBJECT_SELF);
	if (bImmuneBlind && bImmuneDeaf){
		FloatingTextStringOnCreature("Target Immune", oTarget);
		return;
	}
	if (!bImmuneBlind)
		eLink = EffectLinkEffects(eBlind, eLink);
	if (!bImmuneDeaf)
		eLink = EffectLinkEffects(eDeaf, eLink);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		if( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
		{
			FloatingTextStrRefOnCreature(40105, OBJECT_SELF, FALSE);
			return;
		}
        //Fire cast spell at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDNESS_AND_DEAFNESS));
        //Do SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // Make Fortitude save to negate
            if (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
            {
                //Metamagic check for duration
                if (nMetaMagic == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration * 2;
                }
                //Apply visual and effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            }
        }
    }
}