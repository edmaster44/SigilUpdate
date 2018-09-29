// vampire gaze dominate ability - by Agony_Aunt for SCoD.

#include "x0_i0_spells"
#include "NW_I0_SPELLS"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int iTargetRace = GetRacialType(oTarget);
	int iTargetHD = GetHitDice(oTarget);
	int iLevel = GetTotalLevels(oPC, TRUE);
	int iDC = 10 + iLevel / 2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	effect eDom = SupernaturalEffect(EffectDominated());
	effect eVFX = EffectVisualEffect(VFX_IMP_DOMINATE_S);
	int iResult = FALSE;
	float fDur = RoundsToSeconds(iLevel * 10);
	int iWillRoll;
	
	if (!MyResistSpell(oPC, oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
		{
			if ((!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC) && !GetIsImmune(oTarget, IMMUNITY_TYPE_DOMINATE, oPC)) || iTargetRace == IP_CONST_RACIALTYPE_UNDEAD)
			{
				if (iTargetRace == IP_CONST_RACIALTYPE_UNDEAD)
				{
					if (iTargetHD >= iLevel)
					{
						SendMessageToPC(oPC, GetName(oTarget) + " is a more powerful undead than you are and will not bend its knee to you.");
					}
					else
					{
						// can't use WillSave() as it will probably be immune, so let's make it a manual calculation.
						iWillRoll = GetWillSavingThrow(oTarget) + d20(1);
						
						if (iWillRoll == 1 || iWillRoll < iDC)
						{
							SendMessageToPC(oPC, "You bend " + GetName(oTarget) + " to your will.");
							iResult = TRUE;
						}
						else
						{
							SendMessageToPC(oPC, "Despite being a weaker undead than you " + GetName(oTarget) + " resists your will.");
						}
					}
				}
				else
				{
					if (!WillSave(oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC))
					{
						SendMessageToPC(oPC, GetName(oTarget) + " falls under your influence.");
						iResult = TRUE;
					}
					else
					{
						SendMessageToPC(oPC, GetName(oTarget) + " resists your gaze.");
					}
				}
				
				if (iResult == TRUE)
				{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDom, oTarget, fDur);
				}
			} 
		}
	}
}