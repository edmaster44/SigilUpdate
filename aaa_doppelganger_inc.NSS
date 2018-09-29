#include "nwn2_inc_spells"
#include "x2_inc_spellhook" 

//This stuff can go to aaa_constants or remain here
//################################################
const int FEAT_DP_ALTERNATE_FORM = 5022;
const int FEAT_DP_CHANGE_SELF = 5023;
const int FEAT_DP_MENTAL_ACUITY = 5024;
const int FEAT_DP_MENTAL_ACUITY_IMP = 5025;
const int FEAT_DP_BLUFF = 5026;
const int FEAT_INFILTRATOR_ARMOR = 5027;
const int SPELL_FEAT_DP_ALTERNATE_FORM = 4019;
const int SPELL_FEAT_DP_CHANGE_SELF = 4020;
const int SPELL_FEAT_DP_MENTAL_ACUITY = 4021;
const int SPELL_FEAT_DP_MENTAL_ACUITY_IMP = 4022;
const int SPELL_FEAT_DP_BLUFF = 4023;
const int SPELL_FEAT_INFILTRATOR_ARMOR = 4024;
const int CLASS_TYPE_INFILTR = 212;
//################################################
object oSelf = OBJECT_SELF;

void StripSpellEffect(int SpellID1 = -1, int SpellID2 = -1)
{
	effect eEffect = GetFirstEffect(oSelf);
	while(GetIsEffectValid(eEffect))
	{
		if (GetEffectSpellId(eEffect) == SpellID1 | GetEffectSpellId(eEffect) == SpellID2)
		{
			RemoveEffect(oSelf, eEffect);
		}
		eEffect = GetNextEffect(oSelf);
	}
}

void AlternateForm()
{
	ActionStartConversation(oSelf, "aaa_conv_mq_altform", TRUE, FALSE);
}

void ChangeSelf()
{
	ActionStartConversation(oSelf, "aaa_conv_changeself", TRUE, FALSE);
}

void MentalAcuity()
{
	effect eSavingThrowInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_MIND_SPELLS);
	eSavingThrowInc = SupernaturalEffect(eSavingThrowInc);
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSavingThrowInc, oSelf));
}

void MentalAcuityImp()
{
	effect eImmunity1 = EffectImmunity(IMMUNITY_TYPE_CHARM);
	effect eImmunity2 = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect eSavingThrowInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_MIND_SPELLS);
	effect eLink = EffectLinkEffects(eImmunity1, eImmunity2);
	effect eLink2 = EffectLinkEffects(eLink, eSavingThrowInc);
	eLink2 = SupernaturalEffect(eLink2);
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oSelf));
}

void DPBluff()
{
	effect eSkillInc = EffectSkillIncrease(SKILL_BLUFF, 4);
	eSkillInc = SupernaturalEffect(eSkillInc);
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSkillInc, oSelf));
}

void InfiltratorArmor()
{
	int nInfiltrLevel = GetLevelByClass(CLASS_TYPE_INFILTR);
	int nAC;
	if (nInfiltrLevel == 5) nAC = 3;
	else nAC = 1;
    effect eDodge = EffectACIncrease(nAC, AC_DODGE_BONUS);
	eDodge = SupernaturalEffect(eDodge);
//	SendMessageToPC(oSelf, "ExpectedACBonus: "+IntToString(nAC));
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDodge, oSelf));			
}