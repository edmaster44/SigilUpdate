//::///////////////////////////////////////////////
//:: Finger of Death
//:: NW_S0_FingDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You can slay any one living creature within range.
// The victim is entitled to a Fortitude saving throw to
// survive the attack. If he succeeds, he instead
// sustains 3d6 points of damage +1 point per caster
// level.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 17, 2000
//:://////////////////////////////////////////////
//:: Updated By: Georg Z, On: Aug 21, 2003 - no longer affects placeables
// BMA-OEI 11/9/06: Allow casting on neutral creatures
	
#include "x0_I0_SPELLS"
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
	int PML = GetPureMageLevels(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FINGER_OF_DEATH);
	int DC = GetSpellSaveDC();
	
	int DCbonus_2 = GetLocalInt(OBJECT_SELF, "FingerDCBonus_2");
	if (DCbonus_2 > 0)
	{
		SetLocalInt(OBJECT_SELF, "FingerDCBonus_2", DCbonus_2 - 1);
		DC = DC + 2;
	}

	// BMA-OEI 11/9/06: Allow casting on neutral creatures
    //if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE,OBJECT_SELF))
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF))
    {
        //GZ: I still signal this event for scripting purposes, even if a placeable
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FINGER_OF_DEATH));
         if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {

            //Make SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget))
               {
                 //Make Forttude save
                 if (!MySavingThrow(SAVING_THROW_FORT, oTarget, DC, SAVING_THROW_TYPE_DEATH))
                 {
                    //Apply the death effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                 }
                 else
                 {
                    //Roll damage
                    nDamage = d3(nCasterLevel*2) + d3((2*PML)/3);
					if (nCasterLevel < 20 && !GetIsObjectValid(GetSpellCastItem())){
					nDamage = d3(40) + d3((2*PML)/3);
					} 
                    //Make metamagic checks
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = nDamage + ((3*nDamage)/4);
                    }
                    if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                        nDamage = nDamage + (nDamage/2);
                    }
                    //Set damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    //Apply damage effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);		// play the impact effect regardless of save
            }
        }
    }
}