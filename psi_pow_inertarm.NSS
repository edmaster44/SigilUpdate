/*
   ----------------
   Inertial Armour

   psi_pow_inertarm
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Inertial Armour

    Psychokinesis
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Power Points: 1
    Metapsionics: Extend

    Your mind generates a tangible field of force that provides a +4 armor bonus
    to Armor Class. Unlike mundane armor, inertial armor entails no armor check
    penalty or speed reduction.

    The armor bonus provided by inertial armor does not stack with bonuses
    provided by armor enhancements.

    Augment: For every 2 additional power points you spend, the armor bonus to
             Armor Class increases by 1.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_alterations"

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

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
	int nId = GetSpellId();
	
    struct manifestation manif = EvaluateManifestationNew(oManifester, oTarget, nId, 
			METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND );

    if(!manif.bCanManifest) return;
	
	int nBonus = 6;
	
	effect eLink = EffectACIncrease(nBonus, AC_ARMOUR_ENCHANTMENT_BONUS);
	eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_GLOBE_MINOR), eLink);
	
	int bIsGith = (GetSubRace(oManifester) == 57 || GetSubRace(oManifester) == 58);
	
	if ((manif.bAugment && !bIsGith) || (!manif.bAugment && bIsGith)){
		eLink = EffectLinkEffects(EffectConcealment(20), eLink);
	} else if (manif.bAugment && bIsGith){
		eLink = EffectLinkEffects(EffectConcealment(25), eLink);
	}
	
	float fDuration = HoursToSeconds(manif.nManifesterLevel);
	if(manif.bExtend) fDuration *= 2;
	
	SignalEvent(oTarget, EventSpellCastAt(oManifester, nId, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    
}