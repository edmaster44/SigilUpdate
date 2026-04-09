// Vampire bite script, created for SCoD by Agony_Aunt

#include "NW_I0_SPELLS"

void main()
{
	object oTarget = GetSpellTargetObject();
	object oPC = OBJECT_SELF;
	int iLevels = GetTotalLevels(oPC, TRUE);
	int iAmount = iLevels/5 + 1;
	
	// is it a valid target? Bonus if one of the core humanoid types (elf, human, dwarf, etc), and cannot be undead/construct/plant.
	int iRaceType = GetRacialType(oTarget);
	int iVictim = 0; // 0 = not viable, 1 = possible, 2 = possible with bonus.
	
	switch (iRaceType)
	{	
		case RACIAL_TYPE_UNDEAD:
		case RACIAL_TYPE_CONSTRUCT:
		case 22: //plant
		case RACIAL_TYPE_INCORPOREAL:
		case RACIAL_TYPE_OOZE:
		case RACIAL_TYPE_ELEMENTAL:
			iVictim = 0; break;
		default:
			iVictim = 1; break;
	}
	
	if (iVictim > 0)
	{
		PlayCustomAnimation(oPC, "flirt", FALSE);
		if (TouchAttackMelee(oTarget, FALSE) > 0)
		{
			SendMessageToPC(oPC, "<c=red>Your teeth sink into the target's veins, draining them and restoring your health.");
			effect eDam = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, iAmount));
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget);
			effect eHeal = EffectHeal(d20(iAmount));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
		}
		else
		{
			SendMessageToPC(oPC, "<c=red>You missed your mark...");
		}
	}
	else
	{
		SendMessageToPC(oPC, "<c=red>Target does not have blood, you're not going to get anything out if it by biting it");
		PlayCustomAnimation(oPC, "crying", FALSE);
	}
}