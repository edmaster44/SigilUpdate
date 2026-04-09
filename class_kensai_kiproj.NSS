// persistent effect providing bonuses to convo based skills and taunt.

#include "ps_class_inc"

void main()
{
	SendMessageToPC(OBJECT_SELF, "Activating Ki Pjojection.");
	int iID = GetSpellId();
	SendMessageToPC(OBJECT_SELF, "ID: " + IntToString(iID));
	object oPC = OBJECT_SELF;
	int iInc = GetLevelByClass(CLASS_TYPE_KENSAI, oPC);
	SendMessageToPC(OBJECT_SELF, "Levels: " + IntToString(iInc));
	effect eSkill;
	
	if (!GetHasSpellEffect(iID, oPC))
	{
		eSkill = EffectSkillIncrease(SKILL_BLUFF, iInc);
		eSkill = EffectLinkEffects(eSkill, EffectSkillIncrease(SKILL_DIPLOMACY, iInc));
		eSkill = EffectLinkEffects(eSkill, EffectSkillIncrease(SKILL_INTIMIDATE, iInc));
		eSkill = EffectLinkEffects(eSkill, EffectSkillIncrease(SKILL_TAUNT, iInc));
		eSkill = ExtraordinaryEffect(eSkill);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSkill, oPC);
		SendMessageToPC(OBJECT_SELF, "Activated successfully");
	}
	else
	{
		SendMessageToPC(OBJECT_SELF, "Did not activate. Already in effect.");
	}
}