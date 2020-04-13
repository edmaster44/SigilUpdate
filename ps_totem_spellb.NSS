#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_totem_constants"

void main()
{
	object oCreator = GetAreaOfEffectCreator();
	object oTarget = GetExitingObject();
	effect eAOE = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eAOE)) {
		if (GetEffectCreator(eAOE) == oCreator) {
			int spellId = GetEffectSpellId(eAOE);
			switch(spellId) {
			case SPELL_ID_TOTEM_RESISTANCE:
			case SPELL_ID_TOTEM_BLINDING:
			case SPELL_ID_TOTEM_DESPAIR:
			case SPELL_ID_TOTEM_SHELTERING:
			case SPELL_ID_TOTEM_HARDINESS:
			case SPELL_ID_TOTEM_SLOWING:
			case SPELL_ID_TOTEM_NAUSEA:
			case SPELL_ID_TOTEM_SWIFTNESS:
			case SPELL_ID_TOTEM_SERENITY:
				RemoveEffect(oTarget, eAOE);
				break;
			}
		}
		eAOE = GetNextEffect(oTarget);
	}
}