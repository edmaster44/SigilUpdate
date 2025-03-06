//  Constants
const string XP_DAE_PLUGIN_NAME	= "DAE";

// New EFFECT_TYPE_* constants for use with the EnableGetEffectTypeFix
const int EFFECT_TYPE_SCALE                     = 111;
const int EFFECT_TYPE_KNOCKDOWN                 = 112;
const int EFFECT_TYPE_MODIFY_ATTACKS            = 113;
const int EFFECT_TYPE_DAMAGE                    = 114;
const int EFFECT_TYPE_DEATH                     = 115;



//// Internal helper functions

int check_ushort(int nNumber, string sParamName, string sModule)
{
	// Max range for feat ids.
	if(nNumber < 0 || nNumber > 65535)
	{
		WriteTimestampedLogEntry("Attempted to set " + sParamName + " outside of unsigned short range for " + sModule);
		return FALSE;
	}

	return TRUE;
}

// Converts a CREATURE_SIZE_* to its string representation.
string dae_CreatureSizeToString(int nCreatureSize)
{
	switch(nCreatureSize)
	{
		case 1: return "TINY";
		case 2: return "SMALL";
		case 3: return "MEDIUM";
		case 4: return "LARGE";
		case 5: return "HUGE";
	}
	return "INVALID";
}


////  Character Sheet Functions

// Experimental functions for retrieving some character sheet combat information.
// If a problem happens (INVALID_OBJECT, etc.) these will probably return 0, assuming the whole server doesn't crash.

// Theory: This is AB from all sources except for BAB.  Sources subject to the 20 cap might not be respecting the cap?
// Does this also contain ability score mod and all feat bonuses?
// To get total AB add the built-in function GetBaseAttackBonus(oCreature) to this.
int dae_GetOnHandAttackModifier(object oCreature)
{
	if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return 0;
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetOnHandAttackModifier", "", ObjectToInt(oCreature));
}

// Theory: Same as OnHand except for the offhand.
int dae_GetOffHandAttackModifier(object oCreature)
{
	if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return 0;
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetOffHandAttackModifier", "", ObjectToInt(oCreature));
}

// Theory: Number of attacks the creature has.  Does this include haste and other bonus attacks?
int dae_GetNumAttacks(object oCreature)
{
	if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return 0;
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetNumAttacks", "", ObjectToInt(oCreature));
}

// Theory: Total weapon damage from mainhand?
int dae_GetMainHandDamage(object oCreature)
{
	if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return 0;
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetMainHandDamage", "", ObjectToInt(oCreature));
}

//// UUID Functions


// Retrieves the UUID for an oPC, does not work on other objects.
// Returns an empty string on failure.
string dae_GetUuid(object oPC)
{
	if(!GetIsObjectValid(oPC))
	{
		return "";
	}
	else if(!GetIsPC(oPC))
	{
		return "";
	}

	// UUID is stored on oPC's TemplateResRef field.
	string uuid = GetResRef(oPC);

	// Sanity Check length, should always be 32.
	if(GetStringLength(uuid) != 32)
	{
		return "";
	}

	return uuid;
}


// Returns the number of remaining uses of feat with
// feat.2da row of nFeat (you can also use the FEAT_* 
// constants if one is defined) that oCreature has left.
//
// Returns 0 if oCreature does not have the feat.
//
// Returns 0 if nFeat is negative or greater than 65,535.
// Note: this is because internal to the engine the nFeat 
// int is cast to unsigned short.  
//
int dae_GetRemainingFeatUses(object oCreature, int nFeat)
{
	if( nFeat < 0 || nFeat > 65535
		|| !GetIsObjectValid(oCreature) 
		|| GetObjectType(oCreature) != OBJECT_TYPE_CREATURE
		)
	{ 
		return 0;
	}

	NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nFeat, 0);
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetRemainingFeatUses", "", ObjectToInt(oCreature));
}



//// Resolve Special Attack Bonus functions for use in special script nwnx_dae_rsab.nss

// Gets the object that is performing the special attack.
object rsadb_Attacker()
{
	return IntToObject(NWNXGetInt(XP_DAE_PLUGIN_NAME, "nwnx_dae_rsadb_Attacker", "", 0));
}

// Gets the object that is the target of the special attack.
object rsadb_Target()
{
	return IntToObject(NWNXGetInt(XP_DAE_PLUGIN_NAME, "nwnx_dae_rsadb_Target", "", 0));
}

// Gets the FeatID associated with the special attack.
int rsadb_FeatId()
{
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "nwnx_dae_rsadb_FeatId", "", 0);
}


// Sets the amount of damage that you would like to be added for the special attack.
void rsadb_SetDamage(int nAmount)
{
	NWNXSetInt(XP_DAE_PLUGIN_NAME, "rsadb_SetDamage", "", nAmount, 0);
}

// Make a base item finessable at engine level.
// Optionally, only finessable if they also have nFeatId
// If nFeatId is FEAT_INVALID then only feat id 42 (Weapon Finesse) is required.
//		Sets up rules for baseitems:
//
//		nBaseItem1 ->  (nFeatID1, bIgnoreSize), (nFeatID2, bIgnoreSize), (nFeatID3, bIgnoreSize), ...
//		nBaseItem2 ->  ...
//		nBaseItem3 ->  ...
//		...
//
//		If the creature has the feat and meets the size check (or ignores size check for that feat) for
//		at least one of the entries for the given base item equipped then the item is finessable.
//
//		FEAT_INVALID is a catchall meaning no feat is required, but we still do the size check unless 
//		you've set it to ignore.
void dae_CreateFinesseRule(int nBaseItem, int nFeat=FEAT_INVALID, int bIgnoreSize=FALSE)
{
	if( check_ushort(nFeat, "nFeat", "dae_CreateFinesseRule") )
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nFeat, bIgnoreSize>0);
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "MakeFinessable", "", nBaseItem, 0);
	}
}

// Logs to xp_dae.txt the current mappings made through nwnx_dae_CreateFinesseRule.
void dae_LogFinesseRules()
{
	NWNXGetInt(XP_DAE_PLUGIN_NAME, "LogFinesseRules", "", 0);
}

// Retrieve from engine if finesse conditions for a weapon are currently met.
// Returns:
//  0 --> oWeapon for oTarget of iCreatureSize category is not finessable.
//  1 --> oWeapon for oTarget of iCreatureSize category is finessable.
// -1 --> Bad inputs.  (E.g. invalid object, size, etc.)
// To get unarmed use OBJECT_INVALID for oWeapon.
int dae_GetIsFinessable(object oTarget, object oWeapon, int iCreatureSize)
{
	if( !GetIsObjectValid(oTarget)
		|| GetObjectType(oTarget) != OBJECT_TYPE_CREATURE
		|| iCreatureSize < CREATURE_SIZE_TINY
		|| iCreatureSize > CREATURE_SIZE_HUGE
	  )
	{
		return -1;
	}

	NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", ObjectToInt(oWeapon), iCreatureSize);
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetIsFinessable", "", ObjectToInt(oTarget));
}


void dae_CreateSkillFeat(int nFeat, int nSkill, int nAmount)
{
	string sModule = "dae_CreateSkillFeat";

	if( check_ushort(nFeat, "nFeat", sModule) && 
		check_ushort(nSkill, "nSkill", sModule) &&
		nFeat < GetNum2DARows("feat") &&
		nSkill < GetNum2DARows("skills")
		)
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nSkill, nFeat);
		NWNXGetInt(XP_DAE_PLUGIN_NAME, "CreateSkillFeat", "", nAmount);
	}
}

void dae_CreateSkillSynergy(int nSkill, int nSynergySkill, int nAmount=2, int nThreshold=4)
{
	string sModule = "dae_CreateSkillSynergy";

	if( check_ushort(nSynergySkill, "nSynergySkill", sModule) && 
		check_ushort(nSkill, "nSkill", sModule) &&
		nSkill < GetNum2DARows("skills") &&
		nSynergySkill < GetNum2DARows("skills") &&
		nThreshold <= 33 && nThreshold >= 0 //Threshold shouldn't be some crazy amount of ranks.
		)
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nSkill, nSynergySkill);
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts2", "", nAmount, nThreshold);
		NWNXGetInt(XP_DAE_PLUGIN_NAME, "CreateSkillSynergy", "", 0);
	}
}


// Logs to xp_dae.txt the current mapping of nSkills to (nfeat, nAmount).
// This shows what you've added with nwnx_dae_CreateSkillFeat.
void dae_LogSkillFeats()
{
	NWNXGetInt(XP_DAE_PLUGIN_NAME, "LogSkillFeats", "", 0);
}

// Logs to xp_dae.txt the current mapping of nSkills to (nfeat, nAmount).
// This shows what you've added with nwnx_dae_CreateSkillFeat.
void dae_LogSkillSynergies()
{
	NWNXGetInt(XP_DAE_PLUGIN_NAME, "LogSkillSynergies", "", 0);
}



// Add a base item to the monk validity list.
void dae_AddMonkWeapon(int nBaseItem)
{
	if( check_ushort(nBaseItem, "nBaseItem", "dae_AddMonkWeapon") )
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddMonkWeapon", "", nBaseItem, 0);
	}
}

// AC_TYPE_*
const int AC_TYPE_TOTAL = 0;
const int AC_TYPE_NATURAL_BASE = 1;
const int AC_TYPE_ARMOR_BASE = 2;
const int AC_TYPE_SHIELD_BASE = 3;
const int AC_TYPE_ARMOR_MOD = 4;
const int AC_TYPE_ARMOR_NEG = 5;
const int AC_TYPE_DEFLECTION_MOD = 6;
const int AC_TYPE_DEFLECTION_NEG = 7;
const int AC_TYPE_SHIELD_MOD = 8;
const int AC_TYPE_SHIELD_NEG = 9;
const int AC_TYPE_NATURAL_MOD = 10;
const int AC_TYPE_NATURAL_NEG = 11;
const int AC_TYPE_DODGE_MOD = 12;
const int AC_TYPE_DODGE_NEG = 13;
const int AC_TYPE_INNATE = 14;

// Obtains information about the AC component of oCreature.
// These only consider AC that would add all up on the sheet.
// Not "versus AC" which takes into account other combat/racial rules
// against a target during a combat round.
// 
// Use the AC_TYPE_* constants defined above to get different 
// AC "categories".
int dae_GetAC(object oCreature, int AC_TYPE)
{
	if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return 0;

	NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", AC_TYPE, 0);
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetAC", "", ObjectToInt(oCreature));
}

// Assign nFeatId as giving nValue amount of innate AC (always as long as creature has feat).
// All such feats stack together.
// Default feats in plug-in: {FEAT_LUCK_OF_HEROES, 1}, {FEAT_CONSTRUCT_UPGRADE_AC, 3}
void dae_AddInnateACFeat(int nFeatId, int nValue)
{
	if(check_ushort(nFeatId, "nFeat", "dae_AddInnateACFeat"))
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddInnateACFeat", "", nFeatId, nValue);
	}
}

// Assign nFeatId as giving nValue amount of base natural AC (always as long as creature has feat).
// All such feats stack together.
// Default feats in plug-in: {FEAT_EPIC_ARMOR_SKIN, 1}, {FEAT_HAGSPAWN_NATURAL_ARMOR, 2}, {FEAT_RACIAL_NATURAL_ARMOR, 1}
void dae_AddBaseNAACFeat(int nFeatId, int nValue)
{
	if(check_ushort(nFeatId, "nFeat", "dae_AddBaseNAACFeat"))
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddBaseACFeat", "", nFeatId, nValue);
	}
}

int dae_LogEffects(object oCreature)
{
	if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return 0;

	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "LogEffects", "", ObjectToInt(oCreature));
}


const int CATEGORY_ENHANCEMENT = -1; // The default category.
const int CATEGORY_RAGE = 0; // Barbarian Rage category, any rage effects you want to take the highest of add to category 0
// Create as many categories as you want, but they must be positive integers.
// You don't need consts for them, but it's a good idea to keep track of them.
// E.g. CATEGORY_FOO = 2; CATEGORY_BAR = 3; etc.
// You can register spells to categories with dae_AddSpellAbilityCategory.
// An example, if I want to make spell id 2021 belong to category 7, I would call:
// dae_AddSpellAbilityCategory(2021, 7); within the on module load.
// Now any ability increase or decrease effects that are tied to spell id 2021 will belong to category 7.
const int CATEGORY_SACRED = 1; // Typically provided by good spell effects.
const int CATEGORY_FRENZY = 2; // Separate from Rage, as Frenzy stacks with Rage.
const int CATEGORY_MORALE = 3; // Morale includes effects like the Rage and Heroism spells.
const int CATEGORY_LUCK = 4;
const int CATEGORY_INSIGHT = 5;
const int CATEGORY_ALCHEMICAL = 6; // Provided by alchemical items, like Antidote.
const int CATEGORY_COMPETENCE = 7; // As provided by abilities like a bard's Inspire Competence.
const int CATEGORY_PROFANE = 8; // Typically provided by evil spell effects.
const int CATEGORY_RESISTANCE = 9; // Virtually all saving throw bonuses are Resistance.

// Tie the Ability Score increase/decrease for nSpellId to nCategory.
// The highest bonus/decrease from each nCategory is used for the final
// total bonus.
void dae_AddSpellAbilityCategory(int nSpellId, int nCategory)
{
	if( check_ushort(nSpellId, "nFeat", "dae_AddSpellAbilityCategory") )
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddSpellIdAbilityCategory", "", nCategory, nSpellId);
	}
}

// Tie the Skill increase/decrease for nSpellId to nCategory.
// The highest bonus/decrease from each nCategory is used for the final
// total bonus.
void dae_AddSpellSkillCategory(int nSpellId, int nCategory)
{
	if( check_ushort(nSpellId, "nSpellId", "dae_AddSpellSkillCategory") )
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddSpellIdSkillCategory", "", nCategory, nSpellId);
	}
}

// dae_AddExtraUsesFeat
//
// Registers a feat to an extra uses feat with a number of extra uses.
// nTargetFeat is the feat that will be granted extra uses.
// nExtraUsesFeat is the feat that will grant the extra uses.
// nNumberExtraUses is the number of extra uses granted.
// 
// Recommend calling this only once per feat pair on module load.
//
void dae_AddExtraUsesFeat(int nTargetFeat, int nExtraUsesFeat, int nNumberExtraUses)
{
	if( check_ushort(nTargetFeat, "nTargetFeat", "dae_AddExtraUsesFeat") &&
		check_ushort(nExtraUsesFeat, "nExtraUsesFeat", "dae_AddExtraUsesFeat") &&
		nNumberExtraUses > 0 && nNumberExtraUses <= 100)
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nTargetFeat, nExtraUsesFeat);
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddExtraUsesFeat", "", 0, nNumberExtraUses);
	}
}


// Requires SneakAttackMod to be enabled.
// Example usage:
// dae_InitializeSneak2das("sneakgroups.2da", "sneakfeats.2da")
// This sets up sneak attack feat rules for the plug-in to use based on the 2da input.
// This is intended be called once per module restart. Such as in module on load event.
// Returns the total number of feats loaded.
int dae_InitializeSneak2das(string sSneakGroups2daFile, string sSneakFeats2daFile)
{
	int nMaxRows = GetNum2DARows(sSneakGroups2daFile);
	int row = 0;
	for (; row < nMaxRows; row++)
	{
		// A group has: {id (2da row), class, prereqsonly, noflank}
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", row, StringToInt(Get2DAString(sSneakGroups2daFile, "class", row)));
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddSneakGroup", "", StringToInt(Get2DAString(sSneakGroups2daFile, "prereqsonly", row)), StringToInt(Get2DAString(sSneakGroups2daFile, "noflank", row)));
	}

	nMaxRows = GetNum2DARows(sSneakFeats2daFile);
	for (row = 0; row < nMaxRows; row++)
	{
		// A feat has: {featid, groupid, rank, dice} the 2da row is unimportant
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", StringToInt(Get2DAString(sSneakFeats2daFile, "featid", row)), StringToInt(Get2DAString(sSneakFeats2daFile, "groupid", row)));
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddSneakFeat", "", StringToInt(Get2DAString(sSneakFeats2daFile, "rank", row)), StringToInt(Get2DAString(sSneakFeats2daFile, "dice", row)));
	}

	// Returns the total number of feats loaded.
	return row;
}

// Requires SneakAttackMod to be enabled.
// Retreives the total number of sneak dice.
// oCreature -> Creature to check
// bIgnorePrereqOnlyFeats
// 	TRUE -> ignores counting sneak dice for feats which do not grant sneak dice but count as
//			sneak dice for purposes of class and feat prereqs.  (e.g. Invisible Blade's Bleeding Wound)
// 	FALSE -> Counts all sneak dice including prereq only feats.
// bSendDebugMessage will call SendMessageToPC on oCreature if set to TRUE.
int dae_GetSneakDice(object oCreature, int bIgnorePrereqOnlyFeats = TRUE, int bSendDebugMessage = FALSE)
{

	if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return 0;

	NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", bIgnorePrereqOnlyFeats > 0, 0);
	int nDice = NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetSneakDice", "", ObjectToInt(oCreature));
	if(bSendDebugMessage > 0)
	{
		SendMessageToPC(oCreature, (bIgnorePrereqOnlyFeats ? "Sneak Damage Dice: " : "Sneak Prereq Dice: ") + IntToString(nDice));
	}
	return nDice;
}

// Requires CustomUnarmedTable mod to be enabled.
// Example Call:	dae_InitializeUnarmed2da("unarmed.2da")
// Returns number of 2da rows processed.
int dae_IntializeUnarmedDamage2da(string sUnarmedDamage2daFile)
{
	// The unarmed 2da is setup so that:
	// Rows:
	// Row 0 --> This is unarmed damage for someone with no monk unarmed scaling.	
	// Rows 1-30 -->  This is unarmed damage for monk scaling one row per level up to 30 levels.
	// Columns:
	// TINY_NUM   TINY_DIE   SMALL_NUM   SMALL_DIE   MEDIUM_NUM   MEDIUM_DIE   LARGE_NUM   LARGE_DIE   HUGE_NUM   HUGE_DIE
	// The columns are setup so that race of SIZE rolls (NUM)d(DIE).
	// For example, a MEDIUM creature with no monk progression obtains (MEDIUM_NUM)d(MEDIUM_DIE) from row 0.

	int nMaxRows = GetNum2DARows(sUnarmedDamage2daFile);
	int row;
	for (row = 0; row < nMaxRows; row++)
	{
		// We need to pass in {row, nSize, size_num, size_die}
		// There are 5 sizes
		int nSize;
		for (nSize = CREATURE_SIZE_TINY; nSize < CREATURE_SIZE_HUGE; nSize++)
		{
			string sSize = dae_CreatureSizeToString(nSize);

		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", row, nSize);
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddUnarmedDmgRule", "", 
			StringToInt(Get2DAString(sUnarmedDamage2daFile, sSize+"_NUM", row)), 
			StringToInt(Get2DAString(sUnarmedDamage2daFile, sSize+"_DIE", row)));
		}
	}

	return row;
}

// nClassType is row from classes.2da
// Scaling will be equal to (num levels in nClassType)/(nDivisor)
// Classes which scale one per level should use nDivisor = 1
void dae_AddUnarmedDamageScalingClass(int nClassType, int nDivisor = 1)
{
	// nClassType should be [0, max rows in classes.2da]
	// nDivisor should be [1, 30]
	if(nClassType >= 0 && nClassType < GetNum2DARows("classes") 
		&& nDivisor > 0 && nDivisor <= 30)
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddUnarmedDmgCls", "", nClassType, nDivisor);
	}

}


// Add a new feat that will give the Spell Knowledge bonus of nAmount (stacks with all other such feats).
// From nwn2 wiki: Specifics: At 2nd Level, the Arcane Scholar and any party members gain 
// a +1 bonus to their saves versus spells. This bonus increases to +2 at 8th level.
void dae_AddSpellKnowledgeFeat(int nFeatId, int nAmount=1)
{
	if(check_ushort(nFeatId, "nFeat", "dae_AddSpellKnowledgeFeat"))
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddSpellKnowledgeFeat", "", nFeatId, nAmount);
	}
}


// Add a new feat that will add an additional +1 to the total Specialist Defense bonus.
// This is intended to allow support of one of the epic Red Wizard features.
// Base Game Specialist Defense feats are already accounted for.  Only add new ones
// if desired.
void dae_AddSpecialistDefenseFeat(int nFeatId)
{
	if(check_ushort(nFeatId, "nFeat", "dae_AddSpecialistDefenseFeat"))
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddSpDefenseFeat", "", nFeatId, 0);
	}
}


// Consts for internal usage.
const int SR_TYPE_CLASS  = 0;
const int SR_TYPE_FEAT   = 1;
const int SR_TYPE_RACIAL = 2;
// Internal function for handling the other Add SR functions.
void dae_internal_AddSRFeat(int nFeatId, int nAmountOrClass, int nSpellResistanceType = SR_TYPE_FEAT)
{
	if(check_ushort(nFeatId, "nFeat", "dae_AddSRFeat"))
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nFeatId, nAmountOrClass);
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddSRFeat", "", nSpellResistanceType, 0);
	}
}

// Maps an SR feat as belonging to a class.  You may map the same feat to multiple classes.
// The total levels in each class the feat is mapped to plus 10 are used.  Negative levels are considered.
// For example, if you map FEAT_DIAMOND_SOUL to monk and also fighter,
// then the total SR granted from the feat will be the sum of monk and fighter levels plus 10.
// You can create all new feats for individual classes also.
// Note: Class SR and Racial SR do not stack, only the highest of each is taken.
// Note: A feat maps to one or more classes, and the total bonus is 10 + sum of classes mapped to.
// If a character has multiple such feats, they do not stack, only the highest feat applies.
//
// nFeatId -> row of feat from feats.2da or FEAT_*
// nClass -> row of class from classes.2da or CLASS_TYPE_*
void dae_AddClassSRFeat(int nFeatId, int nClass)
{
	dae_internal_AddSRFeat(nFeatId, nClass, SR_TYPE_CLASS);
}

// Adds a new racial SR feat.  The game doesn't actually check if the possessor of the feat
// is that race.  All the character needs is the feat to be granted the SR.
// So this feature may not have a lot of use.
// Note: Class SR and Racial SR do not stack, only the highest of each is taken.
//
// The following racial feats are already available by default from base game:
// FEAT_DROW_RESISTANCE with 11 base
// FEAT_SVIRFNEBLIN_RESISTANCE with 11 base
// FEAT_GITH_RESISTANCE with 5 base
// FEAT_HAGSPAWN_RESISTANCE with 11 base
// FEAT_RACIAL_SPELL_RESISTANCE_10 with 10 base
// FEAT_SPELL_RESISTANCE with 11 base
//
// nFeatId -> row of feat from feats.2da or FEAT_*
// nBaseAmount -> base amount which is added to total character level to compute final SR.  Negative levels are considered.
void dae_AddRacialSRFeat(int nFeatId, int nBaseAmount)
{
	dae_internal_AddSRFeat(nFeatId, nBaseAmount, SR_TYPE_RACIAL);
}


// Adds to the list of feats which grant nAmount bonus to the highest of racial or class SR.
// By default mod accounts only for the Improved SR 1 through 10 feat line in base game.
// Here you may add additional feats.
// nFeatId -> row of feat from feats.2da or FEAT_*
// nAmount -> amount the feat will grant.
void dae_AddStackingSRFeat(int nFeatId, int nAmount)
{
	dae_internal_AddSRFeat(nFeatId, nAmount, SR_TYPE_FEAT);
}

// Retrieves the Faction ID that oCreature belongs to.
// If oCreature is not valid will return -1.
int dae_GetFactionId(object oCreature)
{
	if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return -1; // Invalid creature, unknown faction.

	return  NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetFactionId", "", ObjectToInt(oCreature));
}

// Adds a new class that will be summed with monk levels for purposes of:
// 1. Ki Strike Damage Power (Engine only counted this feat if you had at least 1 monk level by default.)
// 2. Monk Speed Bonus (Engine only summed Monk and Sacred fist by default.)
// 3. Can Use Monk Abilities (Engine uses this to determine if the character is able to use other monk abilities and would require monk or sf levels.)
// For Spell Resistance customization see dae_AddClassSRFeat
// For Unarmed progression see dae_AddUnarmedDamageScalingClass
void dae_AddMonkClass(int nClassType) {
	// nClassType should be [0, max rows in classes.2da]
	if(nClassType >= 0 && nClassType < GetNum2DARows("classes"))
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddMonkClass", "", nClassType, 0);
	}
}