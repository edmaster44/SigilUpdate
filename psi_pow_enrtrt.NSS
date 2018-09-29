/*
   ----------------
   Energy Retort

   psi_pow_enrtrt
   ----------------

   11/12/04 by Stratovarius
*/ /** @file

    Energy Retort

    Psychokinesis [see text]
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: Personal and close (25 ft. + 5 ft./2 levels); see text
    Targets: You and creature or object attacking you; see text
    Duration: 1 min./level
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Chain, Empower, Extend, Maximize

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You weave a field of potential energy of the chosen type around your body.
    The first successful attack made against you in each round during the
    power�s duration prompts a response from the field without any effort on
    your part. The attack may be physical, the effect of a power, or the effect
    of a spell (including spell-like, supernatural, and extraordinary
    abilities). An �ectoburst� discharges from the field, targeting the source
    of the attack and dealing 4d6 points of damage of the chosen energy type.
    To be affected, a target must be within close range. The ectoburst is a
    ranged touch attack.

    Cold: A field of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold retort is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a field of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A field of this energy type deals +1 point of damage per die.
    Sonic: A field of this energy type deals -1 point of damage per die and
           ignores an object�s hardness.

    This power�s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power�s duration
             increases by 1 minute.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_enrgypow"

void main()
{

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_EXTEND | METAPSIONIC_MAXIMIZE
                                      );

    if(manif.bCanManifest)
    {
    	int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        effect eDur       = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
        float fDuration   = 60.0f * manif.nManifesterLevel;
		if (manif.bAugment)
			fDuration += 240.0f;
        if(manif.bExtend) fDuration *= 2;
        object oTarget              = GetSpellTargetObject();
        struct energy_adjustments enAdj =
                EvaluateEnergy(manif.nSpellID, 14477, 14478, 14479, 14480,
                               VFX_DUR_AURA_COLD, VFX_DUR_AURA_SILENCE, VFX_DUR_AURA_FIRE, VFX_DUR_AURA_ODD);
							  
	   int nDamage = d6(4)+(enAdj.nBonusPerDie*4);
	   if (manif.bMaximize)
	   	nDamage = 24+(enAdj.nBonusPerDie*4);
	   if (manif.bEmpower)
	   	nDamage = FloatToInt(IntToFloat(nDamage)*1.5f);
	   effect eVis;
	   
	   if(manif.nSpellID == 14477)
		{
			eVis = EffectNWN2SpecialEffectFile("psi_energyretort_ice.sef", oManifester);
			
		}
		else if(manif.nSpellID == 14478)
		{
			eVis = EffectNWN2SpecialEffectFile("psi_energyretort_elec.sef", oManifester);
			
			
		}
		else if(manif.nSpellID == 14479)
		{
			eVis = EffectNWN2SpecialEffectFile("psi_energyretort_fire.sef", oManifester);
			
		}
		else
		{
			eVis = EffectNWN2SpecialEffectFile("psi_energyretort_sonic.sef", oManifester);
			
		}
		
	   effect eShield = EffectDamageShield(nDamage, DAMAGE_BONUS_1, enAdj.nDamageType);
	   		  eShield = EffectLinkEffects(eShield, eVis);
	   if (GetHasSpellEffect(14477, oTarget) || GetHasSpellEffect(14478, oTarget) || GetHasSpellEffect(14479, oTarget) || GetHasSpellEffect(14480, oTarget))
	   {
	   		FloatingTextStringOnCreature("This power does not stack with other instances of itself.",OBJECT_SELF, FALSE);
	   		return;
	   }
	   else
	   {
	   		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oTarget, fDuration);
	   }
	   
    }// end else - Running OnHit event
}