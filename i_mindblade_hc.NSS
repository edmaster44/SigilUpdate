// On-hit special property for Mind Blades
// Psychic Strike and almost all Blade Skills are applied here
// By Electrohydra
// Last Edited : 30/11/16

#include "class_soulknife_global"

int GetPsychicStrikeDice(object oPC);
int ApplyPsychicStrike(object oPC, object oTarget);
void DoPsychicStrikeEffects(object oPC, object oTarget, int dice);
int ApplyKTTS(object oPC, object oTarget, int dice);
void AttemptRecharge(object oPC);
void CheckReapersBlade(object oPC, object oTarget);

void main()
{
	object mindBlade = GetSpellCastItem();
	if (!GetIsObjectValid(mindBlade)) return;
	
	object oTarget = GetSpellTargetObject();
	object oPC = GetItemPossessor(mindBlade);
	
	// The Mind Blade only works on creatures
	if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) return;
	
	int CHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int levels = GetLevelByClass(SOULKNIFE_ID, oPC);
	
	// Apply Psychic Strike
	if (GetLocalInt(oPC, VAR_PSYCHIC_STRIKE_ON) && !GetIsDead(oTarget))
	{
		if (ApplyPsychicStrike(oPC, oTarget))
		{
			SetLocalInt(oPC, VAR_PSYCHIC_STRIKE_ON, FALSE);
			int DC = GetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC);
			if (DC == 20)
				DelayCommand(5.99f, AttemptRecharge(oPC));
		}
	}
	
	// Apply Wing Clip
	if (GetLocalInt(oPC, VAR_WINGCLIP))
	{
		if (!FortitudeSave(oTarget, (10 + ((levels + 1) / 2) + 2 * CHA)))
		{
			effect entangle = EffectEntangle();
			effect vfx = EffectVisualEffect(VFX_DUR_ENTANGLE);
			effect link = ExtraordinaryEffect(EffectLinkEffects(entangle, vfx));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, link, oTarget, RoundsToSeconds(2)); 
		}
		else
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectMovementSpeedDecrease(50)), oTarget, RoundsToSeconds(1));
		}
		
		SetLocalInt(oPC, VAR_WINGCLIP, FALSE);
	}
	
	// Apply Reaper's Blade
	// The Soulknife is considered to have killed the target if
	// the target is dead 0.01 seconds after the strike
	if (GetHasFeat(FEAT_REAPERS_BLADE, oPC))
	{
		DelayCommand(0.01f, CheckReapersBlade(oPC, oTarget));
	}
	
	// Apply (epic) Strength of my Enemy
	if (GetHasFeat(FEAT_STRENGTH_OF_MY_ENEMY, oPC) || GetHasFeat(FEAT_EPIC_STRENGTH_OF_MY_ENEMY, oPC))
	{
		int STR = GetAbilityScore(oTarget, ABILITY_STRENGTH) - GetAbilityScore(oPC, ABILITY_STRENGTH);
		if (STR < 0)
			STR = 0;
		else if (GetHasFeat(FEAT_EPIC_STRENGTH_OF_MY_ENEMY, oPC) && STR > 9)
			STR = 9;
		else if (!GetHasFeat(FEAT_EPIC_STRENGTH_OF_MY_ENEMY, oPC) && STR > 5)
			STR = 5;
			
		effect bonus = ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_STRENGTH, STR));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, bonus, oPC, RoundsToSeconds(10));
	}
	
	// Apply One Thousand Cuts
	if (GetHasFeat(FEAT_ONE_THOUSAND_CUTS, oPC))
	{
		int cuts = GetLocalInt(oTarget, VAR_CUT_COUNT) + 1;
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(cuts / 2, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE), oTarget, 0.0f);
		SetLocalInt(oTarget, VAR_CUT_COUNT, cuts);
	}
	
	// Apply Delirium Strikes
	if (GetHasFeat(FEAT_DELIRIUM_STRIKES, oPC))
	{
		int DC = 10 + levels + CHA;
		if (!WillSave(oTarget, DC))
		{
			int missChance = FloatToInt((1 - pow(0.95, IntToFloat(CHA))) * 100);
			// DEBUG
			// SendMessageToPC(oPC, "Delerium Strikes applied : " + IntToString(missChance) + "%");
			effect penalty = ExtraordinaryEffect(EffectMissChance(missChance));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, penalty, oTarget, RoundsToSeconds(3));
		}
	}
	
	// Apply Mind Crush
	if (GetHasFeat(FEAT_MIND_CRUSH, oPC) && GetLocalInt(oTarget, VAR_MIND_CRUSH) != TRUE)
	{
		int DC = 10 + ((levels + 1) / 2) + CHA;
		if (GetIsTwoHanding(oPC))
			DC = DC + CHA;
		
		if (!ReflexSave(oTarget, DC))
		{
			effect knockdown = EffectKnockdown();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, knockdown, oTarget, RoundsToSeconds(1));
		}
			
		SetLocalInt(oTarget, VAR_MIND_CRUSH, TRUE);
		DelayCommand(RoundsToSeconds(10), SetLocalInt(oTarget, VAR_MIND_CRUSH, FALSE));
	}
}