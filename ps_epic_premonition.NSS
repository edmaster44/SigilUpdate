#include "x2_inc_spellhook" 

void main(){

	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode())return;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
	int nDuration = 24;
    //Do metamagic extend check
	if (GetMetaMagicFeat() == METAMAGIC_EXTEND)
		nDuration *= 2;

    effect eAC = EffectACIncrease(8, AC_DEFLECTION_BONUS);
	effect eImmuneSA = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	effect eImmuneCH = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect ePromo = EffectNWN2SpecialEffectFile("ps_epic_sight.sef");


    //Link major effects
    effect eLink = EffectLinkEffects(eImmuneSA, eAC);
    eLink = EffectLinkEffects(eImmuneCH, eLink);
    eLink = EffectLinkEffects(ePromo, eLink);
	eLink = SetEffectSpellId(eLink, EPIC_SPELL_EPIC_FORESIGHT);
	
	// does not stack with Epic Mage Armor
	if (GetHasSpellEffect(EPIC_SPELL_EPIC_MAGE_ARMOR, oTarget)){
		SendMessageToPC(oTarget, "Epic Foresight does not stack with Epic Mage Armor.\nRemoving Epic Mage Armor.");
		PS_RemoveEffects(oTarget, EPIC_SPELL_EPIC_MAGE_ARMOR);
	}

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
}