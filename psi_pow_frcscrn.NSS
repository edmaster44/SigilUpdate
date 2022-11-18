/*
   ----------------
   Force Screen

   psi_pow_frcscrn
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Force Screen

    Psychokinesis [Force]
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 1
    Metapsionics: Extend

    You create an invisible mobile disk of force that hovers in front of you.
    The force screen provides a +4 shield bonus to Armor Class. Since it hovers
    in front of you, the effect has no armor check penalty associated with it.

    Augment: For every 4 additional power points you spend, the shield bonus to
             Armor Class improves by 1.
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
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
	int nLevel = GetManifesterLevel(OBJECT_SELF);
	
	
        int nAC;
		if (nLevel < 3)
		nAC = 1;
		else if (nLevel > 5)
		nAC = 2;
		else if (nLevel > 8)
		nAC = 3;
		else if (nLevel > 11)
		nAC = 4; 
		else if (nLevel > 14)
		nAC = 5;
		if (manif.bAugment)
			nAC += 1;
        effect eLink    =                          EffectACIncrease(nAC, AC_SHIELD_ENCHANTMENT_BONUS);
               eLink    = EffectLinkEffects(eLink, EffectNWN2SpecialEffectFile("psi_forcescreen.sef"));
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }// end if - Successfull manifestation
}