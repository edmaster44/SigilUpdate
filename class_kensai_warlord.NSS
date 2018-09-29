// summons a spirit henchman for kensai

#include "ps_class_inc"

void main()
{
	object oPC = OBJECT_SELF;

	effect eSummon = EffectSummonCreature("ps_summon_kensaiwar", VFX_FNF_SUMMON_CELESTIAL, 1.5);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(1));
}