#include "ps_totem_constants"

void main()
{
	object oCreator = GetAreaOfEffectCreator(OBJECT_SELF);
	int nAoeSpellId = GetAreaOfEffectSpellId(OBJECT_SELF);
	int nSaveDC = GetSpellSaveDC();
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	int nMetaMagic = GetMetaMagicFeat();

	object oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget)) {
		ApplyTotemSpell(oTarget, oCreator, nAoeSpellId, nSaveDC, nCasterLevel, nMetaMagic);
		oTarget = GetNextInPersistentObject();
	}

}