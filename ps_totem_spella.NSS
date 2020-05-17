#include "ps_totem_constants"

void main()
{
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator(OBJECT_SELF);
	int nAoeSpellId = GetAreaOfEffectSpellId(OBJECT_SELF);
	int nSaveDC = GetSpellSaveDC();
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	int nMetaMagic = GetMetaMagicFeat();
	
	switch(nAoeSpellId) {
	// Do not apply these buffs on enter to avoid exploit where players go in and out with WASD
	case SPELL_ID_TOTEM_HEALING:
	case SPELL_ID_TOTEM_UNDEAD_HEALING:
	case SPELL_ID_TOTEM_CLEANSING:
		break;
	default:
		ApplyTotemSpell(oTarget, oCreator, nAoeSpellId, nSaveDC, nCasterLevel, nMetaMagic);
		break;
	}
}