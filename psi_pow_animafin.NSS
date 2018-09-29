/*
   ----------------
   Animal Affinity

   psi_pow_animafin
   ----------------

   3/11/05 by Stratovarius
*/ /** @file

    Animal Affinity

    Psychometabolism
    Level: Egoist 2, psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 3
    Metapsionics: Extend

    You forge a psychometabolic affinity with an idealized animal form, thereby
    boosting one of your ability scores (choose either Strength, Dexterity,
    Constitution, Intelligence, Wisdom, or Charisma). The power grants a +4
    enhancement bonus to the ability score you choose, adding the usual benefits
    provided by a high ability bonus. Because you are emulating the idealized
    form of an animal, you also take on minor aspects of the animal you choose.
    If you choose to increase the ability you use to manifest powers, you do not
    gain the benefit of an increased ability score long enough to gain any bonus
    power points for a high ability score, but the save DCs of your powers
    increase for the duration of this power.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "inc_dynconv"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT);

	int spellID =  GetSpellId();
    if(manif.bCanManifest)
    {
		float fDuration = 60.0 * manif.nManifesterLevel;
		if(manif.bExtend) fDuration *= 2;
	
		effect eAbility;
		effect eAbilitySecondary;
		int nAmount = 4;
		
		if (spellID == 14704) {		//strength / wisdom
			eAbility = EffectAbilityIncrease(0, nAmount);
			if (manif.bAugment)
				eAbilitySecondary = EffectAbilityIncrease(3, nAmount);
		}
		else if (spellID == 14705) {		//dexterity / intelligence 
			eAbility = EffectAbilityIncrease(1, nAmount);
			if (manif.bAugment)
				eAbilitySecondary = EffectAbilityIncrease(4, nAmount);
		}
		else if (spellID == 14706) {		//constitution / charisma 
			eAbility = EffectAbilityIncrease(2, nAmount);
			if (manif.bAugment)
				eAbilitySecondary = EffectAbilityIncrease(5, nAmount);
		}
		else if (spellID == 14707) {		//wisdom / strength 
			eAbility = EffectAbilityIncrease(3, nAmount);
			if (manif.bAugment)
				eAbilitySecondary = EffectAbilityIncrease(0, nAmount);
		}
		else if (spellID == 14708) {		//charisma / constitution 
			eAbility = EffectAbilityIncrease(5, nAmount);
			if (manif.bAugment)
				eAbilitySecondary = EffectAbilityIncrease(2, nAmount);
		}
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbility, oTarget, fDuration);
		if (manif.bAugment)
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbilitySecondary, oTarget, fDuration);
		
    }
}