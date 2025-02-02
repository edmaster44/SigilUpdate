/*

    Companion and Monster AI

    This file contains routines that are used casting dispel and breach type spells.

*/

#include "hench_i0_spells"
#include "ps_inc_functions"

struct sEnhancementLevel
{
	float breach;
	float dispel;
};


// gets the chance an effect can be dispelled
float GetDispelChance(object oCreator);

// determines if target has an enhancement that should be
// dispelled or breached
struct sEnhancementLevel Jug_GetHasBeneficialEnhancement(object oTarget);

// determine if creatures is in a harmful AOE spell
object HenchGetAOEProblem(int currentNegEffects, int currentPosEffects);

// test dispel and breach spell weight
void HenchCheckDispel();

// find best location for area of effect dispel spell, usually against hostile persistent area of effects
// if object specified, make sure in range of dispel
// try to minimize friendly targets in dispel area
location FindBestDispelLocation(object oAOEProblem = OBJECT_INVALID);

// determine target that should be have dispel or breach used on them
void HenchGetBestDispelTarget();


int giBestDispelCastingLevel;
int giBestSpellResistanceReduction;

struct sSpellInformation gsBestDispel;
struct sSpellInformation gsBestBreach;
struct sSpellInformation gsGustOfWind;
struct sSpellInformation gsSpellResistanceReduction;


float GetDispelChance(object oCreator)
{
	if (GetIsObjectValid(oCreator))
	{
		int nCasterLevel = PS_GetCasterLevel(oCreator);	// this isn't always accurate (reset every spell)	
		if (nCasterLevel <= 0)
		{
			nCasterLevel = GetHitDice(oCreator);
		}	
		return Getd20Chance(giBestDispelCastingLevel - nCasterLevel - 11);
	}
	return Getd20Chance(giBestDispelCastingLevel - 21 /* 10 - 11 */);
}


const float fMaxEnhancementWeight = 0.5;

// Jugalator Script Additions
// Return 1 if target is enhanced with a beneficial
// spell that can be dispelled (= from a spell script), 2 if the
// effects can be breached, 0 otherwise.
// TK changed to not look for magical effects only
struct sEnhancementLevel Jug_GetHasBeneficialEnhancement(object oTarget)
{
	struct sEnhancementLevel result;
    effect eCheck = GetFirstEffect(oTarget);
	int lastSpellId = -1;
	int bCheckDispel = gsBestDispel.spellID > 0;
	int bCheckBreach = gsBestBreach.spellID > 0;
	
    while (GetIsEffectValid(eCheck))
    {
		int iType = GetEffectType(eCheck);
		if ((iType != EFFECT_TYPE_VISUALEFFECT) && (GetEffectSubType(eCheck) == SUBTYPE_MAGICAL))
		{
			if (bCheckBreach)
			{
		        int iSpell = GetEffectSpellId(eCheck);
		        if (iSpell != lastSpellId)
		        {
					lastSpellId = iSpell;
		            switch(iSpell)
		            {
						case SPELL_ETHEREALNESS: // greater sanctuary
						case SPELL_GREATER_SPELL_MANTLE:
						case SPELL_SPELL_MANTLE:
						case SPELL_PREMONITION:
						case SPELL_SHADOW_SHIELD:
						case SPELL_GREATER_STONESKIN:
						case SPELL_STONESKIN:
						case SPELL_ETHEREAL_VISAGE:
//						case SPELL_MESTILS_ACID_SHEATH:
						case SPELL_LEAST_SPELL_MANTLE:
						case SPELL_MIND_BLANK:
						case SPELL_LESSER_MIND_BLANK:
						case SPELL_PROTECTION_FROM_SPELLS:
							result.breach = fMaxEnhancementWeight;
							bCheckBreach = FALSE;
							break;
						case SPELL_GLOBE_OF_INVULNERABILITY:
						case SPELL_ENERGY_BUFFER:
						case SPELL_LESSER_GLOBE_OF_INVULNERABILITY:
						case SPELL_SPELL_RESISTANCE:
						case SPELL_LESSER_SPELL_MANTLE:
						case SPELL_ELEMENTAL_SHIELD:
						case SPELL_PROTECTION_FROM_ENERGY:
						case SPELL_RESIST_ENERGY:
						case SPELL_DEATH_ARMOR:
							result.breach += 0.2;
							if (result.breach >= fMaxEnhancementWeight)
							{
								result.breach = fMaxEnhancementWeight;
								bCheckBreach = FALSE;
							}
							break;
						case SPELL_GHOSTLY_VISAGE:
						case SPELL_ENDURE_ELEMENTS:
						case SPELL_SHADOW_CONJURATION_MAGE_ARMOR:
						case SPELL_SANCTUARY:
						case SPELL_MAGE_ARMOR:
						case SPELL_SHIELD:
						case SPELL_SHIELD_OF_FAITH:
						case SPELL_RESISTANCE:
							result.breach += 0.1;
							if (result.breach >= fMaxEnhancementWeight)
							{
								result.breach = fMaxEnhancementWeight;
								bCheckBreach = FALSE;
							}
							break;
		            }
				}
			}
			
			if (bCheckDispel)
			{
	            // Found an effect applied by a spell script - check the effect type
	            switch(iType)
	            {
				case EFFECT_TYPE_VISUALEFFECT:	// this effect is very common, don't check everything
					break;
	            case EFFECT_TYPE_REGENERATE:
	            case EFFECT_TYPE_SANCTUARY:
	            case EFFECT_TYPE_IMMUNITY:
	            case EFFECT_TYPE_INVULNERABLE:
	            case EFFECT_TYPE_HASTE:
	            case EFFECT_TYPE_ELEMENTALSHIELD:
	            case EFFECT_TYPE_SPELL_IMMUNITY:
	            case EFFECT_TYPE_SPELLLEVELABSORPTION:
	            case EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE:
	            case EFFECT_TYPE_DAMAGE_INCREASE:
	            case EFFECT_TYPE_DAMAGE_REDUCTION:
	            case EFFECT_TYPE_DAMAGE_RESISTANCE:
	            case EFFECT_TYPE_POLYMORPH:
	            case EFFECT_TYPE_ETHEREAL:
	            case EFFECT_TYPE_INVISIBILITY:
				case EFFECT_TYPE_ABSORBDAMAGE:
					if (result.dispel < fMaxEnhancementWeight)
					{
						result.dispel += 0.5 * GetDispelChance(GetEffectCreator(eCheck));
						if (result.dispel >= fMaxEnhancementWeight)
						{
							result.dispel = fMaxEnhancementWeight;
							bCheckDispel = FALSE;
						}
					}
	                break;
	            case EFFECT_TYPE_ABILITY_INCREASE:
	            case EFFECT_TYPE_AC_INCREASE:
	            case EFFECT_TYPE_ATTACK_INCREASE:
	            case EFFECT_TYPE_CONCEALMENT:
	            case EFFECT_TYPE_ENEMY_ATTACK_BONUS:
	            case EFFECT_TYPE_MOVEMENT_SPEED_INCREASE:
	            case EFFECT_TYPE_SAVING_THROW_INCREASE:
	            case EFFECT_TYPE_SEEINVISIBLE:
	            case EFFECT_TYPE_SKILL_INCREASE:
	            case EFFECT_TYPE_SPELL_RESISTANCE_INCREASE:
	            case EFFECT_TYPE_TEMPORARY_HITPOINTS:
	            case EFFECT_TYPE_TRUESEEING:
	            case EFFECT_TYPE_ULTRAVISION:
				case EFFECT_TYPE_MAX_DAMAGE:
				case EFFECT_TYPE_BONUS_HITPOINTS:
					if (result.dispel < fMaxEnhancementWeight)
					{
						result.dispel += 0.1 * GetDispelChance(GetEffectCreator(eCheck));
						if (result.dispel >= fMaxEnhancementWeight)
						{
							result.dispel = fMaxEnhancementWeight;
							bCheckDispel = FALSE;
						}
					}
	                break;
/*	            case EFFECT_TYPE_PARALYZE:
	            case EFFECT_TYPE_STUNNED:
	            case EFFECT_TYPE_FRIGHTENED:
	            case EFFECT_TYPE_SLEEP:
	            case EFFECT_TYPE_DAZED:
	            case EFFECT_TYPE_CONFUSED:
	            case EFFECT_TYPE_TURNED:
	            case EFFECT_TYPE_PETRIFY:
	            case EFFECT_TYPE_CUTSCENEIMMOBILIZE:
				case EFFECT_TYPE_MESMERIZE:
					{
	               		// if disabled don't dispel
						struct sEnhancementLevel noResult;
						return noResult;
					} */
	            }
			}
		}
        eCheck = GetNextEffect(oTarget);
    }
	
	float targetWeight = GetThreatRating(oTarget);
	result.breach *= targetWeight;	
	result.dispel *= targetWeight;	
	
	if (bCheckDispel)
	{
	        // check if target has summons
	    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oTarget);
	    if (GetIsObjectValid(oSummon))
	    {
	    //    if (GetTag(oSummon) != "X2_S_DRGRED001" && GetTag(oSummon) != "X2_S_MUMMYWARR")
	        {
				result.dispel += GetDispelChance(oTarget) * GetThreatRating(oSummon);
				if (result.dispel >= fMaxEnhancementWeight * targetWeight)
				{
					result.dispel = fMaxEnhancementWeight * targetWeight;
				}
	        }
	    }
	}
	return result;
}


object HenchGetAOEProblem(int currentNegEffects, int currentPosEffects)
{
	int bCheckFriendsAOE = GetGameDifficulty() >= GAME_DIFFICULTY_CORE_RULES;
	object oArea = GetArea(OBJECT_SELF);
	if (oArea == OBJECT_INVALID)
	{
		//
		// The game server does not correctly handle the case where an invalid
		// area is passed to GetFirstSubArea or GetNextSubArea, so we have to
		// check for this here ourselves.
		//

		return OBJECT_INVALID;
	}
	object oAOE = GetFirstSubArea(oArea,  GetPosition(OBJECT_SELF)); 
    int curLoopCount;

    while (GetIsObjectValid(oAOE) && (curLoopCount <= 10))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " found sub area " + GetTag(oAOE));			
		if (GetObjectType(oAOE) == OBJECT_TYPE_AREA_OF_EFFECT)
		{
			curLoopCount ++;
	        object oAOECreator = GetAreaOfEffectCreator(oAOE);
	        int bFriendsAOE;
	        if (GetObjectType(oAOECreator) != OBJECT_TYPE_CREATURE)
	        {
	            oAOECreator = OBJECT_INVALID;
	        }
	        else
	        {
	            bFriendsAOE = GetFactionEqual(oAOECreator) || GetIsFriend(oAOECreator);
	        }
			if (bCheckFriendsAOE || !bFriendsAOE)
			{
//				Jug_Debug(GetName(OBJECT_SELF) + " check AoE " + GetTag(oAOE));			
				int persistSpellFlags = HenchGetAoESpellInfo(oAOE);
				if ((persistSpellFlags & HENCH_PERSIST_HARMFUL) &&
					(!bFriendsAOE || (bCheckFriendsAOE && (persistSpellFlags & HENCH_PERSIST_UNFRIENDLY))) &&
					(persistSpellFlags & (HENCH_PERSIST_CAN_DISPEL | HENCH_PERSIST_MOVE_AWAY)))
				{
					int nSpellID = persistSpellFlags & HENCH_PERSIST_SPELL_MASK;					
					// check damage				
					int nSpellInformation = GetSpellInformation(nSpellID);
				    int damageInfo = GetCurrentSpellDamageInfo() & HENCH_SPELL_INFO_DAMAGE_TYPE_MASK;				
//					Jug_Debug(GetName(OBJECT_SELF) + " check AoE " + GetTag(oAOE) + " damage " + IntToHexString(damageInfo));
					if (damageInfo)
					{
						struct sDamageInformation spellDamage = GetCurrentSpellDamage(GetCasterLevel(oAOECreator), FALSE);					
						float currentDamageAmount = spellDamage.amount;
//						Jug_Debug(GetName(OBJECT_SELF) + " start damage amount " + FloatToString(currentDamageAmount) + " caster level " + IntToString(GetCasterLevel(oAOECreator)));
						if (spellDamage.numberOfDamageTypes == 1)
						{								
							currentDamageAmount = GetDamageResistImmunityAdjustment(OBJECT_SELF, currentDamageAmount, spellDamage.damageType1, spellDamage.count);					
						}
						else
						{							
							currentDamageAmount = GetDamageResistImmunityAdjustment(OBJECT_SELF, currentDamageAmount / 2, spellDamage.damageType1, spellDamage.count) +
								GetDamageResistImmunityAdjustment(OBJECT_SELF, currentDamageAmount / 2, spellDamage.damageType2, spellDamage.count);					
						}					
//						Jug_Debug(GetName(OBJECT_SELF) + " est damage amount " + FloatToString(currentDamageAmount));					
		                if (CalculateDamageWeight(currentDamageAmount, OBJECT_SELF) > 0.33)
		                {
//							Jug_Debug(GetName(OBJECT_SELF) + " check AoE do have damage");
							return oAOE;
		                }
					}					
					// check negative effects
					int effectTypes = GetCurrentSpellEffectTypes();					
					if (effectTypes & HENCH_EFFECT_TYPE_SILENCE)
					{
						if (GetLevelByClass(CLASS_TYPE_WIZARD) > 3 || GetLevelByClass(CLASS_TYPE_SORCERER) > 4 || GetLevelByClass(CLASS_TYPE_WARLOCK) > 3)
		                {
		                    return oAOE;
		                }
					}
					else if (effectTypes)
					{
						if ((nSpellID == SPELL_CLOUDKILL) && (GetHitDice(OBJECT_SELF) < 7))
						{						
							effectTypes = HENCH_EFFECT_TYPE_DEATH;
						}
						if ((effectTypes & ~HENCH_EFFECT_IMPAIRED) == 0)
						{
			                if (currentNegEffects & effectTypes)
			                {
//								Jug_Debug(GetName(OBJECT_SELF) + " check AoE am impared");
								return oAOE;
			                }
						}
						else
						{					
							int saveType = GetCurrentSpellSaveType();
							int immunity1 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK) >> 6;
							int immunity2 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY2_MASK) >> 12;
							int immunityMind = saveType & HENCH_SPELL_SAVE_TYPE_MIND_SPELL_FLAG;
							
							if ((nSpellID == SPELL_CLOUDKILL) && (GetHitDice(OBJECT_SELF) < 7))
							{						
								immunity2 = IMMUNITY_TYPE_DEATH;
							}
							int bDoAction;
							
							if (immunityMind && GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_MIND_SPELLS, oAOECreator))
							{
							}
							else if (immunity2)
							{
								if (!GetIsImmune(OBJECT_SELF, immunity1, oAOECreator) ||
									!GetIsImmune(OBJECT_SELF, immunity2, oAOECreator))
								{
									bDoAction = TRUE;
								}
							}
							else if (immunity1)
							{					
								if (!GetIsImmune(OBJECT_SELF, immunity1, oAOECreator))
								{
									bDoAction = TRUE;
								}
							}
							else
							{
								bDoAction = TRUE;
							}
							if (bDoAction)
							{
//								Jug_Debug(GetName(OBJECT_SELF) + " check AoE immunity");					
								return oAOE;					
							}
						}
					}
				}
	        }
		}
		oAOE = GetNextSubArea(oArea); 
    }

	return OBJECT_INVALID;
}


const int HENCH_SPELL_INFO_DAMAGE_BREACH	= 0x1;
const int HENCH_SPELL_INFO_DAMAGE_DISPEL	= 0x2;
const int HENCH_SPELL_INFO_DAMAGE_RESIST	= 0x4;


void HenchCheckDispel()
{
	int damageInfo = GetCurrentSpellDamageInfo();
	if (damageInfo & HENCH_SPELL_INFO_DAMAGE_BREACH)
	{
//	Jug_Debug("^^^^" + GetName(OBJECT_SELF) + " put in breach");
		if ((gsCurrentspInfo.spellLevel > gsBestBreach.spellLevel) || 
			((gsCurrentspInfo.spellLevel == gsBestBreach.spellLevel) &&
			(gsBestBreach.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) &&
			!(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG)))
		{
			gsBestBreach = gsCurrentspInfo;		
		}	
	}	
	if (damageInfo & HENCH_SPELL_INFO_DAMAGE_DISPEL)
	{
//	Jug_Debug("^^^^" + GetName(OBJECT_SELF) + " put in dispel");
		if ((gsCurrentspInfo.spellLevel > gsBestDispel.spellLevel) || 
			((gsCurrentspInfo.spellLevel == gsBestDispel.spellLevel) &&
			(gsBestDispel.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) &&
			!(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG)))
		{
			gsBestDispel = gsCurrentspInfo;
			if (gsBestDispel.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG)
			{
				giBestDispelCastingLevel = gsBestDispel.spellLevel * 2 - 1;
			}
			else
			{			
				int maxCasterLevel = (HENCH_SPELL_INFO_DAMAGE_LEVEL_LIMIT_MASK & damageInfo) >> 20;
				if (maxCasterLevel > 0)
				{
					maxCasterLevel *= 5;
					if (nMySpellCasterLevel > maxCasterLevel)
					{
						giBestDispelCastingLevel = maxCasterLevel;
					}	
					else
					{
						giBestDispelCastingLevel =	nMySpellCasterLevel;
					}
				}
				else
				{
					giBestDispelCastingLevel =	nMySpellCasterLevel;
				}
			}				 		
//			Jug_Debug("^^^^" + GetName(OBJECT_SELF) + " adding dispel, caster level " + IntToString(giBestDispelCastingLevel));
		}	
	}
	if (damageInfo & HENCH_SPELL_INFO_DAMAGE_RESIST)
	{
		int reductionLevel = (HENCH_SPELL_INFO_DAMAGE_AMOUNT_MASK & damageInfo) >> 12;

		if ((reductionLevel > giBestSpellResistanceReduction) ||
			((reductionLevel == giBestSpellResistanceReduction) && (gsCurrentspInfo.spellLevel > gsSpellResistanceReduction.spellLevel)))
		{
			giBestSpellResistanceReduction = reductionLevel;
			gsSpellResistanceReduction = gsCurrentspInfo;
		}	
//		Jug_Debug("^^^^" + GetName(OBJECT_SELF) + " using spell resistance reduction of " + IntToString(giBestSpellResistanceReduction) + " for spell " + Get2DAString("spells", "Label", gsSpellResistanceReduction.spellID));
	}	
}


// if object specified, make sure in range of dispel
// try to minimize friendly targets in dispel area
int globalBestEnemyCount;
location FindBestDispelLocation(object oAOEProblem = OBJECT_INVALID)
{
    location testTargetLoc;
    int curLoopCount = 1;
    object oTestTarget;
    int extraEnemyCount;
    object oResultTarget = OBJECT_INVALID;
    globalBestEnemyCount = -100;
    int bFoundTargetObject;
    int bHasAOEProblem = GetIsObjectValid(oAOEProblem);
    int bFoundAnyTarget;

    object oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, 1);
    while (GetIsObjectValid(oTarget) && curLoopCount <= 10 && GetDistanceToObject(oTarget) <= 9.0)
    {
        testTargetLoc = GetLocation(oTarget);
        extraEnemyCount = 0;
        bFoundTargetObject = FALSE;
        bFoundAnyTarget = FALSE;

        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        oTestTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTestTarget))
        {
            if (GetObjectType(oTestTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                if (oTestTarget == oAOEProblem)
                {
                    bFoundTargetObject = TRUE;
                }
                if (GetStringLeft(GetTag(oTestTarget), 8) == "VFX_PER_")
                {
                    if (GetIsEnemy(GetAreaOfEffectCreator(oTestTarget)))
                    {
                        bFoundAnyTarget = TRUE;
                        extraEnemyCount ++;
                    }
                    else if (GetFactionEqual(GetAreaOfEffectCreator(oTestTarget)) || GetIsFriend(GetAreaOfEffectCreator(oTestTarget)))
                    {
                        if (!bHasAOEProblem)
                        {
                            extraEnemyCount = -100;
                            break;
                        }
                        extraEnemyCount --;
                    }
                }
            }
            else
            {
                    // TODO Jug_GetHasBeneficialEnhancement removed because too many instruction error
                if (GetIsEnemy(oTestTarget) /* && Jug_GetHasBeneficialEnhancement(oTestTarget) */)
                {
                    extraEnemyCount ++;
                }
                else if (GetFactionEqual(oTestTarget) || GetIsFriend(oTestTarget) /* && Jug_GetHasBeneficialEnhancement(oTestTarget) */)
                {
                    extraEnemyCount --;
                }
            }
            //Select the next target within the spell shape.
            oTestTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
        }
        if (bFoundTargetObject || (!bHasAOEProblem && bFoundAnyTarget))
        {
            if (extraEnemyCount > globalBestEnemyCount)
            {
                globalBestEnemyCount = extraEnemyCount;
                oResultTarget = oTarget;
            }
        }
        curLoopCount ++;
        oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, curLoopCount);
    }
    if (globalBestEnemyCount < 0)
    {
        return GetLocation(oAOEProblem);
    }
    return GetLocation(oResultTarget);
}


void HenchGetBestDispelTarget()
{
	if ((gsBestBreach.spellID <= 0) && (gsBestDispel.spellID <= 0))
	{
		return;
	}
	
	float fMaxWeight;
	object oBestTarget;
	int bUseBreach;
	
    if ((gsBestDispel.spellID > 0) && !gbDisabledAllyFound && !PS_GetLocalInt(OBJECT_SELF, sHenchDontDispel))
    {
//	Jug_Debug(GetName(OBJECT_SELF) + " checking dispel");
		object oFriend;
		int iLoopLimit;

		if (!gbDisableNonHealorCure)
		{
			iLoopLimit = 10;
			int curLoopCount = 1;
			oFriend = PS_GetLocalObject(OBJECT_SELF, sEnemySeen);
			while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
			{
				if (GetCreatureNegEffects(oFriend) & HENCH_EFFECT_TYPE_DOMINATED)
				{
					int bFound;
                    effect eEffect = GetFirstEffect(oFriend);
                    while (GetIsEffectValid(eEffect))
                    {
                        if (GetEffectType(eEffect) == EFFECT_TYPE_DOMINATED)
                        {
                            if (GetEffectSubType(eEffect) == SUBTYPE_MAGICAL)
                            {
                                bFound = TRUE;
                            }
                            break;
                        }
                        eEffect = GetNextEffect(oFriend);
                    }
					if (bFound)
					{
						fMaxWeight = GetThreatRating(oFriend) * 2.0 * GetDispelChance(GetEffectCreator(eEffect));
						oBestTarget = oFriend;
					}
				} 
				oFriend = PS_GetLocalObject(oFriend, sEnemySeen);	
			}
			if (GetIsObjectValid(ogCharmedAlly))
			{			
				int bFound;
				effect eEffect = GetFirstEffect(ogCharmedAlly);
				while (GetIsEffectValid(eEffect))
				{
					if (GetEffectType(eEffect) == EFFECT_TYPE_CHARMED)
					{
						if (GetEffectSubType(eEffect) == SUBTYPE_MAGICAL)
						{
							bFound = TRUE;
						}
						break;
					}
					eEffect = GetNextEffect(ogCharmedAlly);
				}
				if (bFound)
				{
					float fCurWeight = GetThreatRating(ogCharmedAlly) * GetDispelChance(GetEffectCreator(eEffect));
					if (fCurWeight > fMaxWeight)
					{
						fMaxWeight = fCurWeight;
						oBestTarget = ogCharmedAlly;
					}
				}
			}
		}
		
        oFriend = OBJECT_SELF;
        iLoopLimit = gsBestDispel.range == 0.0 ? 1 : 10;
		int curLoopCount = 1;
		while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
		{
//			Jug_Debug("%%" + GetName(OBJECT_SELF) + " testing cure target " + GetName(oFriend) + " spell " + IntToString(gsBestDispel.spellID)); 		
			if (PS_GetLocalInt(oFriend, curNegativeEffectsStr) & HENCH_EFFECT_DISABLED_NO_PETRIFY)
			{
                effect eEffect = GetFirstEffect(oFriend);
				int bFound;
                while (GetIsEffectValid(eEffect))
                {
                    if (GetEffectSubType(eEffect) == SUBTYPE_MAGICAL)
                    {
	                    switch (GetEffectType(eEffect))
						{
						case EFFECT_TYPE_VISUALEFFECT:	// this effect is very common, don't check everything
							break;
						case EFFECT_TYPE_PARALYZE:
						case EFFECT_TYPE_STUNNED:
						case EFFECT_TYPE_FRIGHTENED:
						case EFFECT_TYPE_SLEEP:
						case EFFECT_TYPE_DAZED:
						case EFFECT_TYPE_CONFUSED:
                            bFound = TRUE;
							break;
                        }
                    }
                    eEffect = GetNextEffect(oFriend);
                }
				if (bFound)
				{
					float curEffectWeight = GetThreatRating(oFriend) * GetDispelChance(GetEffectCreator(eEffect));
					if (curEffectWeight > fMaxWeight)
					{
						// Jug_Debug("%%" + GetName(OBJECT_SELF) + " targeting cure target " + GetName(oFriend) + " spell " + IntToString(gsBestDispel.spellID)); 		
						fMaxWeight = curEffectWeight;
						oBestTarget = oFriend;
					}
					break;
				}		
	        }
			oFriend = PS_GetLocalObject(oFriend, sAllySeen);
			curLoopCount ++;
		}
	}
	
	if (!gbDisableNonHealorCure)
	{
	        // try to limit the casting of dispel/breach in case it fails
	    int combatRoundCount = PS_GetLocalInt(OBJECT_SELF, henchCombatRoundStr);
	    int lastDispel = PS_GetLocalInt(OBJECT_SELF, henchLastDispelStr);
	    if ((lastDispel == 0) || (lastDispel < combatRoundCount - 5))
	    {			
			object oTarget = PS_GetLocalObject(OBJECT_SELF, sEnemyLineOfSight);
			while (GetIsObjectValid(oTarget))
			{
				if ((GetDistanceToObject(oTarget) <= 20.0) && !(GetCreatureNegEffects(oTarget) & HENCH_EFFECT_DISABLED_OR_IMMOBILE))
				{				
					struct sEnhancementLevel enhanceLevel = Jug_GetHasBeneficialEnhancement(oTarget);
					// Jug_Debug(" **** " + GetName(OBJECT_SELF) + " checking dispel for " + GetName(oTarget));
					if (enhanceLevel.breach > fMaxWeight)
					{
						// Jug_Debug(" **** " + GetName(OBJECT_SELF) + " using breach for " + GetName(oTarget));
						oBestTarget = oTarget;
						fMaxWeight = enhanceLevel.breach;
						bUseBreach = TRUE;
					}
					if (enhanceLevel.dispel > fMaxWeight)
					{
						// Jug_Debug(" **** " + GetName(OBJECT_SELF) + " using dispel for " + GetName(oTarget));
						oBestTarget = oTarget;
						fMaxWeight = enhanceLevel.dispel;
						bUseBreach = FALSE;
					}
				}
				oTarget = PS_GetLocalObject(oTarget, sEnemyLineOfSight);
		    }			
		    // TODO removed for now
		/*
		    location dispLoc = FindBestDispelLocation();
		    if ((nBenTargetEffect == 0 && globalBestEnemyCount > 0) ||
		        (nBenTargetEffect > 0 && globalBestEnemyCount > 2))
		    {
		        areaSpellTargetLoc = dispLoc;
		        nAreaSpellExtraTargets = globalBestEnemyCount;
		        iGlobalTargetType = TARGET_SPELL_AT_LOCATION;
		        iGlobalSpell = iBestDispel;
		        return TRUE;
		    } */
	    }
	}
	
	if (fMaxWeight > 0.0)
	{
		if (bUseBreach)
		{
			fMaxWeight *= GetConcetrationWeightAdjustment(gsBestBreach.spellInfo, gsBestBreach.spellLevel);		
			if (fMaxWeight >= gfAttackTargetWeight)
			{
//				Jug_Debug("&&&&" + GetName(OBJECT_SELF) + " putting breach spell in weight " + FloatToString(fMaxWeight));						
				gfAttackTargetWeight = fMaxWeight;		
				gsAttackTargetInfo = gsBestBreach;			
				gsAttackTargetInfo.oTarget = oBestTarget;
			}
		}
		else
		{
			fMaxWeight *= GetConcetrationWeightAdjustment(gsBestDispel.spellInfo, gsBestDispel.spellLevel);		
			if (fMaxWeight >= gfAttackTargetWeight)
			{
//				Jug_Debug("&&&&" + GetName(OBJECT_SELF) + " putting dispel spell in weight " + FloatToString(fMaxWeight));						
				gfAttackTargetWeight = fMaxWeight;		
				gsAttackTargetInfo = gsBestDispel;			
				gsAttackTargetInfo.oTarget = oBestTarget;
			}
		}	
	}
}
