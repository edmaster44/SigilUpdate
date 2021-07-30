  /** @file psi_pow_wepnrg

    Weapon of Energy

    Psychokinesis [see text]
    Level: Psychic warrior 4
    Range: Touch
    Target: Weapon touched
    Duration: 1 round/level
    Power Points: 7
    Metapsionics: Extend

    You can use this power to energize a weapon. That weapon deals an extra 1d8
    points of Energy Damage(Magical) (as chosen by you at the time of
    manifestation) on a successful hit.

    If this power is manifested on a already benefiting from the effect of the
    power, the newer manifestation supersedes the older manifestation, even if
    both manifestations are of different energy types.

    This power’s subtype is the same as the type of energy infused in the
    touched weapon.

    @author Stratovarius
    @date   Created: Nov 5, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"


/*void ApplyWeaponProperty(object oTarget, float fDuration)
{
int	nDamage = IP_CONST_DAMAGEBONUS_1d8;
int DamageType = IP_CONST_DAMAGETYPE_POSITIVE;
itemproperty ipWoE = ItemPropertyDamageBonus(DamageType,nDamage);
IPSafeAddItemProperty(oTarget,ipWoE, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
return;


}

void ApplyWeaponPropertyAugmented(object oTarget, float fDuration)
{
int	nDamage = IP_CONST_DAMAGEBONUS_1d10;
int DamageType = IP_CONST_DAMAGETYPE_POSITIVE;
itemproperty ipWoE = ItemPropertyDamageBonus(DamageType,nDamage);
IPSafeAddItemProperty(oTarget,ipWoE, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
return;

}

*/


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
int	nDamage = IP_CONST_DAMAGEBONUS_1d8;
int DamageType = IP_CONST_DAMAGETYPE_POSITIVE;
itemproperty ipWoE = ItemPropertyDamageBonus(DamageType,nDamage);
    object oTarget     = IPGetTargetedOrEquippedMeleeWeapon();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND||METAPSIONIC_AUGMENT
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

        if(manif.bAugment)
		{nDamage = IP_CONST_DAMAGEBONUS_1d10;}
		else 
           
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipWoE, oTarget, fDuration);}
        }
    }
