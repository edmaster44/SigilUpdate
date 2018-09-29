// Unearthly grace feat for Nymphs. CHA bonus to Saves and Dodge AC.

//#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    object oTarget = GetSpellTargetObject();

	int iBonus = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
	
	if (iBonus < 1) return;
	
	if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget)) > ARMOR_RANK_LIGHT)
	{
		SendMessageToPC(oTarget, "<color=red>Unearthly Grace will not work when wearing armour greater than light");
	}
	else if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus, SAVING_THROW_TYPE_ALL);
		effect eAC = EffectACIncrease(iBonus, AC_DEFLECTION_BONUS);
		effect eLink = EffectLinkEffects(eSaves, eAC);
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}	
}