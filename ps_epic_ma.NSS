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
    int nDuration = 24;
	if (GetMetaMagicFeat() == METAMAGIC_EXTEND)
		nDuration *= 2;
    effect eStone = EffectDamageReduction(20, GMATERIAL_METAL_MITHRAL, 0, DR_TYPE_GMATERIAL );
    effect eAC = EffectACIncrease(8, AC_ARMOUR_ENCHANTMENT_BONUS );
    effect ePromo = EffectNWN2SpecialEffectFile("ps_epic_mage_armor.sef", oTarget); 
    effect eDisplace = EffectConcealment(15);

    //Link major effects
    effect eLink = EffectLinkEffects(eStone, eAC);
    eLink = EffectLinkEffects(eLink, ePromo);
    eLink = EffectLinkEffects(eLink, eDisplace);
	eLink = SetEffectSpellId(eLink, EPIC_SPELL_EPIC_MAGE_ARMOR);
	
	// does not stack with Epic Foresight
	if (GetHasSpellEffect(EPIC_SPELL_EPIC_FORESIGHT, oTarget)){
		SendMessageToPC(oTarget, "Epic Mage Armor does not stack with Epic Foresight.\nRemoving Epic Foresight.");
		PS_RemoveEffects(oTarget, EPIC_SPELL_EPIC_FORESIGHT);
	}

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
}