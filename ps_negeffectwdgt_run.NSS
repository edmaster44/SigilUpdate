// ps_negeffectwdgt
#include "ps_inc_functions"

void  main (int effectid, int duration)
{
	object oPC = GetPCSpeaker();
	
	int durType;
	if (duration == 0)
	{
		durType = DURATION_TYPE_PERMANENT;
	}
	else
	{
		durType = DURATION_TYPE_TEMPORARY;
	}
	
	float theDuration = IntToFloat(duration);
	
	effect theEffect;
	
	switch(effectid)
	{
	case 0:
		theEffect = EffectNewBlindness();
		break;
	case 1:
		theEffect = EffectDeaf();
		break;
	case 2:
		theEffect = EffectSleep();
		break;
	case 3:
		theEffect = EffectNegativeLevel(1);
		break;
		
		// diseases
	case 101:
		theEffect = EffectDisease(DISEASE_BURROW_MAGGOTS);
		break;
		
		// poisons
	case 201:
		theEffect = EffectPoison(POISON_ARSENIC);
		break;
		
		// ability scores
	case 1001:
		theEffect = EffectAbilityDecrease(ABILITY_STRENGTH, 1);
		break;
	case 1002:
		theEffect = EffectAbilityDecrease(ABILITY_DEXTERITY, 1);
		break;
	case 1003:
		theEffect = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);
		break;
	case 1004:
		theEffect = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1);
		break;
	case 1005:
		theEffect = EffectAbilityDecrease(ABILITY_WISDOM, 1);
		break;
	case 1006:
		theEffect = EffectAbilityDecrease(ABILITY_CHARISMA, 1);
		break;
		
	default:
		break;
	}

	effect eLinkedEffect = ExtraordinaryEffect(theEffect);
	ApplyEffectToObject (durType, eLinkedEffect, oPC, theDuration);
}


