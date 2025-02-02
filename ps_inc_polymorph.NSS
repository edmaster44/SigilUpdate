/*#include "x0_i0_position"
#include "aaa_constants"
#include "ps_inc_advscript"
#include "x0_i0_match"
#include "x0_i0_petrify"
#include "ps_inc_functions"


void PS_RemovePolymorphBonus(object oPC, object oEssence);

void PS_ApplyPolymorphBonus(object oPC, object oEssence);

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

void PS_RemovePolymorphBonus(object oPC, object oEssence)
{
    int iWisToRemove	= GetLocalInt(oEssence, "WildWis");
	int iIntToRemove	= GetLocalInt(oEssence, "WildInt");
	int iChaToRemove	= GetLocalInt(oEssence, "WildCha");
	effect eWisRemove	= EffectAbilityDecrease(ABILITY_WISDOM, iWisToRemove);
		eWisRemove		= ExtraordinaryEffect(eWisRemove);
	effect eIntRemove	= EffectAbilityDecrease(ABILITY_INTELLIGENCE, iIntToRemove);
		eIntRemove		= ExtraordinaryEffect(eIntRemove);
	effect eChaRemove	= EffectAbilityDecrease(ABILITY_CHARISMA, iChaToRemove);
		eChaRemove		= ExtraordinaryEffect(eChaRemove);
	
	if(!GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
    {	DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWisRemove, oPC));
        DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIntRemove, oPC));
        DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eChaRemove, oPC));
		SetLocalInt(oEssence, "WildWis", 0);
		SetLocalInt(oEssence, "WildInt", 0);
		SetLocalInt(oEssence, "WildCha", 0);
        SendMessageToPC(oPC, "Racial bonuses to polymorph removed.");	}
    else
	{	DelayCommand(6.0f, PS_RemovePolymorphBonus(oPC, oEssence));	}
}

void PS_ApplyPolymorphBonus(object oPC, object oEssence)
{
	int iWisBonus			= GetAbilityRacialBonus(oPC, ABILITY_WISDOM);
	int iIntBonus			= GetAbilityRacialBonus(oPC, ABILITY_INTELLIGENCE);
	int iChaBonus			= GetAbilityRacialBonus(oPC, ABILITY_CHARISMA);
	
	if(iWisBonus > 0)
	{	effect eWisRacial	= EffectAbilityIncrease(ABILITY_WISDOM, iWisBonus);
			eWisRacial		= ExtraordinaryEffect(eWisRacial);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWisRacial, oPC);
		SendMessageToPC(oPC, "WIS bonus to polymorph: +" + IntToString(iWisBonus));
		SetLocalInt(oEssence, "WildWis", iWisBonus);
		SendMessageToPC(oPC, "WIS bonus applied.");	}
	if(iIntBonus > 0)
	{	effect eIntRacial	= EffectAbilityIncrease(ABILITY_INTELLIGENCE, iIntBonus);
			eIntRacial		= ExtraordinaryEffect(eIntRacial);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIntRacial, oPC);
		SendMessageToPC(oPC, "INT bonus to polymorph: +" + IntToString(iIntBonus));
		SetLocalInt(oEssence, "WildInt", iIntBonus);
		SendMessageToPC(oPC, "INT bonus applied.");	}
	if(iChaBonus > 0)
	{	effect eChaRacial	= EffectAbilityIncrease(ABILITY_CHARISMA, iChaBonus);
			eChaRacial		= ExtraordinaryEffect(eChaRacial);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eChaRacial, oPC);
		SendMessageToPC(oPC, "CHA bonus to polymorph: +" + IntToString(iChaBonus));
		SetLocalInt(oEssence, "WildCha", iChaBonus);
		SendMessageToPC(oPC, "CHA bonus applied.");	}
	SendMessageToPC(oPC, "Racial bonuses to mental abilities *if any* applied to polymorph shape.");
}* Disabled by edmaster44, not working */ 