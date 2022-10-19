// Nymph Kiss script, created for SCoD by Agony_Aunt

#include "NW_I0_SPELLS"

void main()
{
	object oTarget = GetSpellTargetObject();
	object oPC = OBJECT_SELF;
	int iLevels = GetTotalLevels(oPC, TRUE);

	
	int iDC;
	int iTouchBonus=0;
	int iResult;
	
	// is it a valid target? Bonus if one of the core humanoid types (elf, human, dwarf, etc), and cannot be undead/construct/plant.
	int iRaceType = GetRacialType(oTarget);
	int iVictim = 0; // 0 = not viable, 1 = possible, 2 = possible with bonus.
	
	switch (iRaceType)
	{	
		case RACIAL_TYPE_ANIMAL:
		case RACIAL_TYPE_BEAST:
		case RACIAL_TYPE_DRAGON:
		case RACIAL_TYPE_FEY:
		case RACIAL_TYPE_HUMANOID_MONSTROUS:
		case RACIAL_TYPE_HUMANOID_REPTILIAN:
		case RACIAL_TYPE_OUTSIDER:
		case RACIAL_TYPE_YUANTI:
		case RACIAL_TYPE_SHAPECHANGER:
			iVictim = 1;
			break;
		case RACIAL_TYPE_DWARF:
		case RACIAL_TYPE_ELF:
		case RACIAL_TYPE_GIANT:
		case RACIAL_TYPE_GNOME:
		case RACIAL_TYPE_HALFELF:
		case RACIAL_TYPE_GRAYORC:
		case RACIAL_TYPE_HALFLING:
		case RACIAL_TYPE_HALFORC:
		case RACIAL_TYPE_HUMAN:
		case RACIAL_TYPE_HUMANOID_GOBLINOID:
		case RACIAL_TYPE_HUMANOID_ORC:
		case 21: // planetouched
			iVictim = 2;
			break;
		default:
			iVictim = 0;
			break;
	}
	
	if (iVictim > 0)
	{
		PlayCustomAnimation(oPC, "flirt", FALSE);
		
		if (iVictim == 2)
		{
			iDC = 10 + iLevels + GetAbilityModifier(ABILITY_CHARISMA, oPC);
			iTouchBonus = 4;
			// adds +4 to AB for one second (for the touch attack)
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(iTouchBonus, ATTACK_BONUS_MISC), oPC, 1.0f);
		}
		else 
		{
			iDC = 10 + iLevels/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
		}
		
		iResult = TouchAttackMelee(oTarget, TRUE);
		
		if (iResult > 0)
		{
			iResult = WillSave(oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC);
			
			if (iResult == 0)
			{
				if (GetSubRace(oPC) == 132) // if succubus, the kiss's effects are enhanced! -Electrohydra
				{
					if (iLevels + 10 >= GetHitDice(oTarget) && !GetIsPC(oTarget))
					{
						// long duration dominate
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDominated(), oTarget, HoursToSeconds(iLevels));
						SendMessageToPC(oPC, "The target falls deeply under your influence.");
					}
					else // short duration dominate
					{
						// dominate
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDominated(), oTarget, RoundsToSeconds(iLevels));
						SendMessageToPC(oPC, "The target falls under your control, but it's too strong to remain under for long.");
					}
				}
			
				// effect depends on relative level of target.
				else if (iLevels > GetHitDice(oTarget))
				{
					// dominate
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDominated(), oTarget, RoundsToSeconds(d6(iLevels)));
					SendMessageToPC(oPC, "The target falls under your complete control");
				}
				else
				{
					// charm
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCharmed(), oTarget, RoundsToSeconds(d6(iLevels)));
					SendMessageToPC(oPC, "The target is too strong for you to control, but it now no longer wants to hurt you as long as you take no action against it.");
				}
			}
			else
			{
				SendMessageToPC(oPC, "The target fails to fall under your influence");
			}
		}
		else
		{
			SendMessageToPC(oPC, "You failed to plant a kiss on the target.");
		}
	}
	else
	{
		SendMessageToPC(oPC, "You're not going to kiss <i>that!!!</i>");
		PlayCustomAnimation(oPC, "crying", FALSE);
	}
}