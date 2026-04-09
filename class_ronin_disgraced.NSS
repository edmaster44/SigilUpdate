// disgraced effect for Ronin

#include "ps_class_inc"

void main()
{
	object oPC = OBJECT_SELF;
		
	if (!GetHasSpellEffect(SPELL_ID_DISGRACED, oPC))
	{
		effect eDip = SupernaturalEffect(EffectSkillDecrease(SKILL_DIPLOMACY, 5));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDip, oPC);
	}
}