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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Do metamagic extend check
	if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration *= 2;	//Duration is +100%
    }
    effect eAC = EffectACIncrease(8, AC_NATURAL_BONUS);
	effect eImmuneSA = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	effect eImmuneCH = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect ePromo = EffectNWN2SpecialEffectFile("ps_epic_sight.sef");
	effect eRegen = EffectRegenerate(5, 8.0);

    //Link major effects
    effect eLink = EffectLinkEffects(eRegen, eAC);
    eLink = EffectLinkEffects(eLink, ePromo);
    eLink = EffectLinkEffects(eLink, eImmuneSA);
	eLink = EffectLinkEffects(eLink, eImmuneCH);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
}