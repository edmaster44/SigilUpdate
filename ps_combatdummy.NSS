#include "ps_inc_functions"

// constants
const string combatdummyVariable = "CombatDummyXp";
const int maxXpPerDay = 200;
const int minRollForXp = 18;

// code
int GetOrCreateCurrentXp(object targetObject)
{
 	int xp = GetLocalInt(targetObject, combatdummyVariable);
	return xp;
}

void SetCurrentXp(object targetObject, int xp)
{
	SetLocalInt(targetObject, combatdummyVariable, xp);
}

void main()
{
	object oPC = GetLastDamager();

	// heal the dummy
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(9999), OBJECT_SELF);

	// already exceeded xp for the day? if yes, exit
	int currentXp = GetOrCreateCurrentXp(oPC);
	int maxXp = FloatToInt(maxXpPerDay*PS_GetXPModifier(PS_GetEssenceECL(oPC)));
	
//	SpeakString(IntToString(maxXp),TALKVOLUME_SHOUT);
	
	if (currentXp >= maxXp)
		return;
	
	// give xp for this hit?
	int d20Roll = d20();
	int pcBab = GetTRUEBaseAttackBonus(oPC);
	int xpRoll = d20Roll + pcBab;
	
	if (xpRoll >= minRollForXp)
	{
		// rolled high enough for xp
		
		// compute the xp to give
		int pcLevels = PS_GetLevel(oPC);
		if (pcLevels == 0)
			return; // error check
		float fractionalGiveXp = 30.0 / IntToFloat(pcLevels);
		int giveXp;
		if (fractionalGiveXp < 1.0)
			giveXp = 1;
		else
			giveXp = FloatToInt(fractionalGiveXp);
	
		int newXp = currentXp + giveXp;
		if (newXp <= maxXpPerDay)
		{
			// give some xp
			SetCurrentXp(oPC, newXp);
			PS_GiveXPReward(oPC, giveXp);
		}
		else
		{
			// already gave all the earnable xp today
		}
	}
	else
	{
		// did not roll high enough to get xp
	}
}