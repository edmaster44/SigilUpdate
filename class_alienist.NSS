#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "x2_inc_toollib"
#include "nwn2_inc_metmag"
#include "ps_inc_advscript"

void PS_Alien_Blessing(object oPC, int nSpell)
{
   	if(GetHasFeat(FEAT_ALIENIST_ALIEN_BLESSING, oPC) && (GetLocalInt(oPC,"FEAT_ALIENIST_ALIEN_BLESSING") < 1))
      	SetLocalInt(oPC,"FEAT_ALIENIST_ALIEN_BLESSING", 1);
   
	effect eEff = EffectAbilityDecrease(ABILITY_WISDOM, 2);

   	eEff = SupernaturalEffect(eEff);
   	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}

void PS_Mad_Certainty(object oPC, int nSpell)
{
   	if(GetHasFeat(FEAT_ALIENIST_MAD_CERTAINTY, oPC) && (GetLocalInt(oPC,"FEAT_ALIENIST_MAD_CERTAINTY") < 1))
      	SetLocalInt(oPC,"FEAT_ALIENIST_MAD_CERTAINTY", 1);
   
	effect Stat1 = EffectSkillDecrease(SKILL_DIPLOMACY, 4);
	effect Stat2 = EffectSkillDecrease(SKILL_BLUFF, 4);
	effect eEff = EffectLinkEffects(Stat1, Stat2);

   	eEff = SupernaturalEffect(eEff);
   	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}

void PS_Insane_Certainty(object oPC, int nSpell)
{
   	if(GetHasFeat(FEAT_ALIENIST_INSANE_CERTAINTY, oPC) && (GetLocalInt(oPC,"FEAT_ALIENIST_INSANE_CERTAINTY") < 1))
      	SetLocalInt(oPC,"FEAT_ALIENIST_INSANE_CERTAINTY", 1);
   
	effect Stat1 = EffectSkillDecrease(SKILL_DIPLOMACY, 6);
	effect Stat2 = EffectSkillDecrease(SKILL_BLUFF, 6);
	effect eEff = EffectLinkEffects(Stat1, Stat2);

   	eEff = SupernaturalEffect(eEff);
   	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}