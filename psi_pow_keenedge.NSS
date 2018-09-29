/*
   ----------------
   Keen Edge, Psionic

   psi_pow_keenedge
   ----------------

   17/2/05 by Stratovarius
*/ /** @file

    Keen Edge, Psionic

    Metacreativity
    Level: Psion/wilder 3, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Targets: One weapon or a stack projectiles
    Duration: 10 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 5
    Metapsionics: Extend

    You mentally sharpen the edge of your weapon, granting it the keen property.
    This only works on piercing or slashing weapons.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"

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
    object oTarget     = IPGetTargetedOrEquippedMeleeWeapon();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );
							  

    // Validity check
    if(!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oManifester, "Target must be a weapon or creature holding a weapon!"); // Item must be weapon or creature holding a weapon
    	return;
    }

    if(manif.bCanManifest)
    {
        int nDamageType = GetWeaponType(oTarget);
        effect eVis     = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        if(nDamageType == DAMAGE_TYPE_PIERCING ||
           nDamageType == DAMAGE_TYPE_SLASHING
           )
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
            IPSafeAddItemProperty(oTarget, ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
        }
    }
}