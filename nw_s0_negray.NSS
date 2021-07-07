//::///////////////////////////////////////////////
//:: Negative Energy Ray
//:: NW_S0_NegRay
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a bolt of negative energy at the target
    doing 1d6 damage.  Does an additional 1d6
    damage for 2 levels after level 1 (3,5,7,9) to
    a maximum of 5d6 at level 9.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 13, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "ps_inc_functions"

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
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
	int PML = GetPureMageLevels(OBJECT_SELF);

    if(nCasterLevel > 12)
    {
        nCasterLevel = 12;
    }

    int nDamage = d4(nCasterLevel) + (nCasterLevel) + d2(PML/3);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
    	nDamage =  nDamage*2;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
    	nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
    }
	
	// If applicable adds any sneak damage to total to be inflicted and reports the damage.
	int nDamageSneak = PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_NEGATIVE);
				
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eDam = EffectDamage(nDamage + nDamageSneak, DAMAGE_TYPE_NEGATIVE);
    effect eHeal = EffectHeal(nDamage);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eRay;
    if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY));
            eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Make a saving throw check
                if(/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
                {
                    nDamage /= 2;
                }
                //Apply the VFX impact and effects
                //DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY, FALSE));
        eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}