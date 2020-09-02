// contains all the constants and a few reusable functions for the Mind
// Blade class. All scripts for the class should include this file
// By Electrohydra
// Last Edited : 14/05/16

const string MINDBLADE_LONGSWORD_TEMPLATE = "mindblade_longsword10";
const string MINDBLADE_SHORTSWORD_TEMPLATE = "mindblade_shortsword10";
const string MINDBLADE_TWOHANDEDSWORD_TEMPLATE = "mindblade_greatsword1";
const string MINDBLADE_DAGGER_TEMPLATE = "mindblade_dagger00";

const string MINDBLADE_TAG = "mindblade";

const string VAR_WINGCLIP = "wingclipon";
const string VAR_PSYCHIC_STRIKE_ON = "psychicstrikeon";
const string VAR_PSYCHIC_STRIKE_DC = "psychicstrikeDC";
const string VAR_KNIFE_TO_THE_SOUL = "knifetothesoul";
const string VAR_MIND_SHIELD = "mindshieldamount";
const string VAR_CUT_COUNT = "cutcount";
const string VAR_MIND_CRUSH = "mindcrush";
const string VAR_REAPERS_BLADE = "reapersbladeapplied";

const int SOULKNIFE_ID = 71;

const int KTTS_OFF = 1;
const int KTTS_INT = 2;
const int KTTS_WIS = 3;
const int KTTS_CHA = 4;

const int FORM_MINDBLADE_TWO_HANDED = 11852;
const int FORM_MINDBLADE_SINGLE = 11853;
const int FORM_MINDBLADE_TWIN = 11854;
const int BURNING_PASSION = 11856;
const int COLD_INTELLECT = 11857;
const int MINDSILVER_BLADE = 11858;
const int PRIMAL_IRON_BLADE = 11859;
const int DUO_DIMENTIONAL_BLADE = 11860;
const int FEVERISH_CORROSION = 11862;
const int ELECTRIC_INSPIRATION = 11863;
const int MORAL_BLADE = 11864;
const int GHOSTTOUCH_BLADE = 11865;
const int MINDVENOM = 11866;
const int STRENGTH_OF_MORALITY = 11868;
const int EDGE_OF_ETHICS = 11869;
const int MIND_DRINKER = 11870;

const int FEAT_DAZZLING_BLADE = 12971;
const int FEAT_IMPROVED_ENHANCEMENT = 12972;
const int FEAT_KNIFE_TO_THE_SOUL = 12973;
const int FEAT_MIND_SHIELD = 12974;
const int FEAT_IMPROVED_MIND_SHIELD = 12975;
const int FEAT_POWERFUL_STRIKES = 12976;
const int FEAT_REAPERS_BLADE = 12977;
const int FEAT_STRENGTH_OF_MY_ENEMY = 12978;
const int FEAT_WING_CLIP = 12979;
const int FEAT_DELIRIUM_STRIKES = 12980;
const int FEAT_EPIC_MIND_SHIELD = 12981;
const int FEAT_EPIC_STRENGTH_OF_MY_ENEMY = 12982;
const int FEAT_MIND_CRUSH = 12983;
const int FEAT_ONE_THOUSAND_CUTS = 12984;
const int FEAT_REVERBERATING_PSYCHE = 12985;
const int FEAT_SPINAL_TAP = 12986;

// Determines if the user is using the two-handed version of the mindblade
int GetIsTwoHanding(object oPC)
{
	if (GetHasFeat(FEAT_MONKEY_GRIP, oPC))
		return FALSE;
		
	int mainWeaponType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
	int userSize = GetCreatureSize(oPC);
	
	if ((mainWeaponType == BASE_ITEM_GREATSWORD && userSize == CREATURE_SIZE_MEDIUM)
		|| (mainWeaponType == BASE_ITEM_LONGSWORD && userSize == CREATURE_SIZE_SMALL))
		return TRUE;
		
	return FALSE;
}

// Determines if the user is using two mindblades
int GetIsTWF(object oPC)
{
	string rightHandTag = GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
	string leftHandTag = GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
	
	if (rightHandTag == MINDBLADE_TAG && leftHandTag == MINDBLADE_TAG)
		return TRUE;
	else
		return FALSE;
}

// Determines if a mind blade is being used.
int GetUsingMindblade(object oPC)
{
	if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == MINDBLADE_TAG)
		return TRUE;
	else
		return FALSE;
}

// Gets the number of dice of Psychic Strike the soulknife has
int GetPsychicStrikeDice(object oPC)
{
	int levels = GetLevelByClass(SOULKNIFE_ID);
	int dice = (levels + 1) / 4;
	if (GetHasFeat(FEAT_POWERFUL_STRIKES, oPC))
		dice = dice + 2;
		
	return dice;
}

// Applies Knife to the Soul on target. Returns FALSE if knife to the soul was not applied
int ApplyKTTS(object oPC, object oTarget, int dice)
{
	int kkts = GetLocalInt(oPC, VAR_KNIFE_TO_THE_SOUL);
	int ability = 0;
	int dice =  GetPsychicStrikeDice(oPC);
	switch (kkts)
	{
		case KTTS_INT :
			ability = ABILITY_INTELLIGENCE;
			break;
		case KTTS_WIS :
			ability = ABILITY_WISDOM;
			break;
		case KTTS_CHA :
			ability = ABILITY_CHARISMA;
			break;
		default :
			return FALSE;
	}
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAbilityDecrease(ability, ((dice + 1) / 2) + (GetAbilityScore(oTarget, ability, TRUE) - GetAbilityScore(oTarget, ability, FALSE))), oTarget);
	if (GetAbilityScore(oTarget, ability, FALSE) <= 0) // Kills the target if it brings a score to 0
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, TRUE, TRUE, TRUE), oTarget);
		
	return TRUE;
}

// Applies the actual effects of the strike to the target, after immunities are done.
void DoPsychicStrikeEffects(object oPC, object oTarget, int dice)
{
	// Apply Reverberating Psyche
	if (GetHasFeat(FEAT_REVERBERATING_PSYCHE, oPC) && dice >= 2)
	{
		DelayCommand(RoundsToSeconds(1), DoPsychicStrikeEffects(oPC, oTarget, dice / 2));
	}
	
	// Applies KTTS
	int kkts = ApplyKTTS(oPC, oTarget, dice);
	if (kkts)
		dice = dice / 2; // Half the damage was converted to KKTS damage
		
	// Do the actual magical damage
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d8(dice), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE), oTarget, 0.0f);
}

// Applies Psychic Strike on the target. Returns FALSE if psychic strike was not applied
int ApplyPsychicStrike(object oPC, object oTarget)
{
	int mindSpellImmunity = GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC);
	int dice =  GetPsychicStrikeDice(oPC);
	if (mindSpellImmunity)
	{
		if (GetHasFeat(FEAT_SPINAL_TAP, oPC))
			dice = (dice);
		else
			return FALSE;
	}
	
	DoPsychicStrikeEffects(oPC, oTarget, dice);
	
	return TRUE;
}

// Attempts to recharge the Soulknife's psychic strike. Uses 5.99 second "rounds" to make sure
// the recharge attempt is made BEFORE the attack comming 6 seconds latter.
void AttemptRecharge(object oPC)
{
	int DC = GetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC);

	// If a recharge is not needed
	if (GetLocalInt(oPC, VAR_PSYCHIC_STRIKE_ON) == TRUE)
	{
		if (DC > 20)
		{
			SetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC, DC - 5);
			DelayCommand(5.99f, AttemptRecharge(oPC));
		}
	}
	else
	{
		if (GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, DC, FALSE)) // Set to TRUE to see skill roll
		{
			SetLocalInt(oPC, VAR_PSYCHIC_STRIKE_ON, TRUE);
			SetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC, DC + 10);
			DelayCommand(5.99f, AttemptRecharge(oPC));
		}
		else
		{
			if (DC > 20)
				SetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC, DC - 5);		
			
			DelayCommand(5.99f, AttemptRecharge(oPC));
		}
	}
}

// Checks if the target is dead, if so, apply Reaper's Blade
void CheckReapersBlade(object oPC, object oTarget)
{
	if (GetIsDead(oTarget) && GetLocalInt(oTarget, VAR_REAPERS_BLADE) != TRUE)
	{
		SetLocalInt(oTarget, VAR_REAPERS_BLADE, TRUE);	
	
		SetLocalInt(oPC, VAR_PSYCHIC_STRIKE_ON, TRUE);
		
		int DC = GetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC) - 10;
		if (DC < 20)
			DC = 20;
			
		SetLocalInt(oPC, VAR_PSYCHIC_STRIKE_DC, DC);
		// DEBUG!!!!
		// SendMessageToPC(oPC, "Reaper's Blade Applied");
	}
}

// Restarts the Strike if the DC hasn't changed since last round.
void RestartPsychicStrike(int DC)
{
	if (DC == GetLocalInt(OBJECT_SELF, VAR_PSYCHIC_STRIKE_DC))
		AttemptRecharge(OBJECT_SELF);
}

// Restarts Psychic Strike if was stopped when it shouldn't.
void DebugPsychicStrike(int DC, int PsychicStrikeOn)
{
	if (DC != 20 || PsychicStrikeOn == FALSE)
		DelayCommand(6.0f,RestartPsychicStrike(DC));
}