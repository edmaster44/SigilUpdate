// include file for race related functions

#include "nwn2_inc_spells"

const int SPELL_UNEARTHLY_GRACE = 1367;
const int FEAT_UNEARTHLY_GRACE = 2367;

void CheckUnearthlyGrace(object oPC)
{
	int iArmourRank = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
	int iHasEffect = GetHasSpellEffect(SPELL_UNEARTHLY_GRACE, oPC);
	
	if (iHasEffect == TRUE && iArmourRank > ARMOR_RANK_LIGHT)
	{
		SendMessageToPC(oPC, "<color=red>Unearthly Grace will not work when wearing armour greater than light");
		RemoveAnySpellEffects(SPELL_UNEARTHLY_GRACE, oPC);
	}
	else if (iHasEffect == FALSE && iArmourRank <= ARMOR_RANK_LIGHT)
	{
		SendMessageToPC(oPC, "<color=red>You feel nimble and graceful ((Unearthly Grace Activated))");
		ActionCastSpellAtObject(SPELL_UNEARTHLY_GRACE, oPC, METAMAGIC_NONE, TRUE, 1, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}
	// else nothing, everything is already right, ie: doesn't have effect but has heavier armour or does and has lighter armour or none.
	
}