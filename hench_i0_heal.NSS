

/*

    Companion and Monster AI

    This file contains routines that are used for healing and curing conditions. Note that the
    cure/inflict and heal/harm are part of the attack spells since they are dual use. Uses defines
    and functions in hench_i0_spells and is called by hench_i0_itemsp.

*/

#include "hench_i0_spells"


// void main() {    }

// find best healing kit in inventory
object GetBestHealingKit();

// check regeneration spells (can't target an enemy)
void HenchCheckRegeneration();

// check healing only spells (can't target an enemy), special purpose
void HenchCheckHealSpecial();

// test raise or resurrect spell weight
void HenchRaiseDead();

// test cure condition spell weight, allies and self
void HenchCheckCureCondition();


object GetBestHealingKit()
{
    object oKit = OBJECT_INVALID;
    int iRunningValue = 0;
    int iItemValue, iStackSize;
    
    object oItem = GetFirstItemInInventory();
    while(GetIsObjectValid(oItem))
    {
        // skip past any items in a container
        if (GetHasInventory(oItem))
        {
            object oContainer = oItem;
            object oSubItem = GetFirstItemInInventory(oContainer);
            oItem = GetNextItemInInventory();
            while (GetIsObjectValid(oSubItem))
            {
                oItem = GetNextItemInInventory();
                oSubItem = GetNextItemInInventory(oContainer);
            }
            continue;
        }
        if (GetBaseItemType(oItem) == BASE_ITEM_HEALERSKIT)
        {
            iItemValue = GetGoldPieceValue(oItem);
            iStackSize = GetNumStackedItems(oItem);
            // Stacked kits be worth what they should be separately.
            iItemValue = iItemValue/iStackSize;
            if(iItemValue > iRunningValue)
            {
                iRunningValue = iItemValue;
                oKit = oItem;
            }
        }
        oItem = GetNextItemInInventory();
    }
    return oKit;
}


void HenchCheckRegeneration()
{
//		Jug_Debug(GetName(OBJECT_SELF) + " check healing " + IntToString(gsCurrentspInfo.spellID));	
	CheckHealingListInit();
	object oFriend = OBJECT_SELF;
	int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 10;
	int curLoopCount = 1;
	
	float maxEffectWeight;
	object oBestTarget;
	object oTestTarget = OBJECT_SELF;		
	int bIsAreaSpell = gsCurrentspInfo.shape != HENCH_SHAPE_NONE;
	float fRange;
	string sTargetList;	
	if (bIsAreaSpell)
	{
		fRange = bgMeleeAttackers ? gsCurrentspInfo.range : 20.0;
		sTargetList = sAllyLineOfSight;
	}
	else
	{
		fRange = bgMeleeAttackers ? fAllyMeleeTouchRange : 20.0;
		sTargetList = sAllySeen;
	}
	
	int spellID = gsCurrentspInfo.spellID;
	
	int regenerateAmount;
	int numRegenerateRounds;
	if (spellID == SPELLABILITY_FIENDISH_RESILIENCE)
	{
	    if (GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_25, OBJECT_SELF, TRUE))
	    {
	        regenerateAmount = 25;
	    }
	    else if (GetHasFeat(FEAT_FIENDISH_RESILIENCE_5, OBJECT_SELF, TRUE))
	    {
	        regenerateAmount = 5;
	    }
	    else if (GetHasFeat(FEAT_FIENDISH_RESILIENCE_2, OBJECT_SELF, TRUE))
	    {
	        regenerateAmount = 2;
	    }
	    else
	    {
	        regenerateAmount = 1;
	    }
		regenerateAmount *= regenerateRateRounds;
		numRegenerateRounds = 20;
	}
	else if (spellID == SPELLABILITY_SONG_INSPIRE_REGENERATION)
	{
		if (GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_REGENERATION, OBJECT_SELF))
		{
			return;
		}
			// regenerate 1, 2, 3 every other round x/2
        int nLevel = GetBardicClassLevel(OBJECT_SELF);
        if(nLevel >= 12)
		{
			regenerateAmount = 1 + ((nLevel - 7) / 5);
		}
        else
		{
			regenerateAmount = 1;
		}
		regenerateAmount *= regenerateRateRounds / 2;
		numRegenerateRounds = 100;
	}
	else if (spellID == SPELL_REGENERATE)
	{	
		numRegenerateRounds = 10;	
	}
	else
	{	
	    int nCasterLevel = (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ? (gsCurrentspInfo.spellLevel * 2) - 1 : nMySpellCasterLevel;
		if (spellID == SPELL_VIGOR)
		{
			regenerateAmount = 2 * regenerateRateRounds;
			if (nCasterLevel < 15)
			{
				numRegenerateRounds = nCasterLevel + 10;
			}
			else
			{
				numRegenerateRounds = 25;
			}
		}
		else if (spellID == SPELL_LESSER_VIGOR)
		{
			regenerateAmount = regenerateRateRounds;
			if (nCasterLevel < 5)
			{
				numRegenerateRounds = nCasterLevel + 10;
			}
			else
			{
				numRegenerateRounds = 15;
			}
		}
		else if (spellID == SPELL_MASS_LESSER_VIGOR)
		{
			regenerateAmount = regenerateRateRounds;
			if (nCasterLevel < 15)
			{
				numRegenerateRounds = nCasterLevel + 10;
			}
			else
			{
				numRegenerateRounds = 25;
			}
		}
		else if (spellID == SPELL_VIGOROUS_CYCLE)
		{
			regenerateAmount = 3 * regenerateRateRounds;
			if (nCasterLevel < 30)
			{
				numRegenerateRounds = nCasterLevel + 10;
			}
			else
			{
				numRegenerateRounds = 40;
			}
		}
	}
	
	int iHealAmount;
	if (bgAnyValidTarget)
	{
		iHealAmount = regenerateAmount / regenerateRateRounds;	
	}
	else
	{
		iHealAmount = regenerateAmount * numRegenerateRounds / regenerateRateRounds;	
	}
			
	while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
	{	
//		Jug_Debug(GetName(OBJECT_SELF) + " check healing for " + GetName(oFriend));
		int iCurrent = GetLocalInt(oFriend, sHealingCurrentInfo);
		if ((iCurrent != iHealingNotNeeded) && (GetDistanceBetween(oTestTarget, oFriend) <= fRange))
		{
			int iBase = GetMaxHitPoints(oFriend);
			if (spellID == SPELL_REGENERATE)
			{
				regenerateAmount = iBase * regenerateRateRounds / 10; 
				if (bgAnyValidTarget)
				{
					iHealAmount = regenerateAmount * 2 / regenerateRateRounds;	
				}
				else
				{
					iHealAmount = iBase;	
				}
			}
			
	//		SpawnScriptDebugger();
					
	//		Jug_Debug(GetName(OBJECT_SELF) + " health ratio " + FloatToString(healthRatio) + " healing thres " + FloatToString(gfHealingThreshold) + " threshold damage limit " + FloatToString(IntToFloat(iBase / (bgMeleeAttackers ?  8 : 15))));
			if ((spellID == SPELLABILITY_SONG_INSPIRE_REGENERATION) &&
				((GetRacialType(oFriend) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oFriend) == RACIAL_TYPE_UNDEAD) ||
				(GetLocalInt(oFriend, curNegativeEffectsStr) & HENCH_EFFECT_DYING_OR_DEAF)))
			{
				// has no effect
			}
			else
			{		
				int posEffects = GetLocalInt(oFriend, curPostiveEffectsStr);
				int currentRegenerateAmount = GetLocalInt(oFriend, regenerationRateStr);
			
				if (iHealAmount >= (iBase / giHealingDivisor))
				{
					if ((currentRegenerateAmount < regenerateAmount) || ((currentRegenerateAmount == regenerateAmount) &&
						!(posEffects & HENCH_EFFECT_TYPE_REGENERATE)))
					{
						float curTargetWeight = iHealAmount / IntToFloat(iBase - iCurrent);
						if (curTargetWeight > 1.0)
						{
							curTargetWeight = 1.0;
						}
						curTargetWeight *= GetThreatRating(oFriend);
						if (gbDisableNonHealorCure || oFriend == OBJECT_SELF)
						{
							// make sure to heal self
							curTargetWeight *= gfHealSelfWeightAdjustment;
						}
						else
						{
							curTargetWeight *= gfHealOthersWeightAdjustment;
						}
						curTargetWeight *= (1.0 - (IntToFloat(iCurrent) / IntToFloat(iBase)));
						if (gbDisableNonHealorCure || (GetLocalInt(oFriend, HENCH_HEAL_SELF_STATE) <= HENCH_HEAL_SELF_CANT) || GetIsPC(oFriend))
						{						
							if (bIsAreaSpell)
							{
			                    if (!GetIsObjectValid(oBestTarget))
			                    {
			                        oBestTarget = oFriend;
									oTestTarget = oFriend; 
									fRange = gsCurrentspInfo.radius;
			                    }
								maxEffectWeight += curTargetWeight;
							}
							else if (curTargetWeight > maxEffectWeight)
							{
								maxEffectWeight = curTargetWeight;
								oBestTarget = oFriend;
							}
						}
					}
					else
					{
						if ((oFriend == OBJECT_SELF) && (iHealAmount >= (iBase / giHealingDivisor)))
						{
							SetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_WAIT);
						}
					}
				}
			}
		}
	
		oFriend = GetLocalObject(oFriend, sTargetList);
		curLoopCount ++;
	}
    
    if (maxEffectWeight > 0.0)
	{		
        HenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestTarget);
    }
}


void HenchCheckHealSpecial()
{
//	Jug_Debug(GetName(OBJECT_SELF) + " check heal special " + IntToString(gsCurrentspInfo.spellID));
	
	CheckHealingListInit();
	object oFriend = OBJECT_SELF;
	int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 10;;
	int curLoopCount = 1;
	
	int spellID = gsCurrentspInfo.spellID;
	float fRange = bgMeleeAttackers ? fAllyMeleeTouchRange : 20.0;

	int iHealAmount;
	if (spellID == SPELL_REJUVENATION_COCOON)
	{
		int nCasterLevel = (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ? 9 : nMySpellCasterLevel;
		if (nCasterLevel > 15)
		{
			nCasterLevel = 15;
		}
		iHealAmount = 6 * nCasterLevel;
	}
	else if (spellID == SPELLABILITY_WHOLENESS_OF_BODY)
	{		
		iHealAmount = GetLevelByClass(CLASS_TYPE_MONK, OBJECT_SELF) * 2;
	}
	else if (spellID == HENCH_HEALING_KIT_ID)
	{
		iHealAmount = 11 + GetSkillRank(SKILL_HEAL) + IPGetWeaponEnhancementBonus(goHealingKit);
		if (!bgMeleeAttackers)
		{
			// take 20
			iHealAmount += 9;
		}		
	}
	else if (spellID == SPELL_HEAL_ANIMAL_COMPANION)
	{	
		oFriend = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
	    if (!GetIsObjectValid(oFriend) || !HenchCheckDruidAnimalTarget(oFriend) ||
	        GetHasSpellEffect(spellID, oFriend) || !GetObjectSeen(oFriend) ||
	        (GetDistanceToObject(oFriend) > (bgMeleeAttackers ? 5.0 : 20.0)))
	    {
	        return;
	    }
		iLoopLimit = 1;
	    int nCasterLevel = (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ? (gsCurrentspInfo.spellLevel * 2) - 1 : nMySpellCasterLevel;
		if (nCasterLevel > 15)
		{
			iHealAmount = 150;
		}
		else
		{
			iHealAmount = nCasterLevel * 10;
		}
	}
	else if (spellID == 1773)	/* Blood of the Martyr */
	{
		if (!bgAnyValidTarget || (GetCurrentHitPoints() < 50))
		{
			return;
		}	
		oFriend = GetLocalObject(OBJECT_SELF, sAllySeen);
	}
			
	float maxEffectWeight;
	object oBestTarget;
	while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
	{	
		int iCurrent = GetLocalInt(oFriend, sHealingCurrentInfo);
		if ((iCurrent != iHealingNotNeeded) && (GetDistanceToObject(oFriend) <= fRange))
		{	
	//		Jug_Debug(GetName(OBJECT_SELF) + " check healing for " + GetName(oFriend));				
		    int iBase = GetMaxHitPoints(oFriend);
					
	//		SpawnScriptDebugger();					
	//		Jug_Debug(GetName(OBJECT_SELF) + " health ratio " + FloatToString(healthRatio) + " healing thres " + FloatToString(gfHealingThreshold) + " threshold damage limit " + FloatToString(IntToFloat(iBase / (bgMeleeAttackers ?  8 : 15))));
	
			if (iHealAmount >= (iBase / giHealingDivisor))
			{
				float curTargetWeight = iHealAmount / IntToFloat(iBase - iCurrent);
				if (curTargetWeight > 1.0)
				{
					curTargetWeight = 1.0;
				}
				curTargetWeight *= GetThreatRating(oFriend);
				if (gbDisableNonHealorCure || oFriend == OBJECT_SELF)
				{
					// make sure to heal self
					curTargetWeight *= gfHealSelfWeightAdjustment;
				}
				else
				{
					curTargetWeight *= gfHealOthersWeightAdjustment;
				}
				curTargetWeight *= (1.0 - (IntToFloat(iCurrent) / IntToFloat(iBase)));
				if ((curTargetWeight > maxEffectWeight) &&
					(gbDisableNonHealorCure || (GetLocalInt(oFriend, HENCH_HEAL_SELF_STATE) <= HENCH_HEAL_SELF_CANT)) || GetIsPC(oFriend))
				{
					maxEffectWeight = curTargetWeight;
					oBestTarget = oFriend;
				}
			}
			else
			{
				if ((oFriend == OBJECT_SELF) && (iHealAmount >= (iBase / giHealingDivisor)))
				{
					SetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_WAIT);
				}
			}
		}
	
		oFriend = GetLocalObject(oFriend, sAllySeen);
		curLoopCount ++;
	}
	
	if (spellID == 1773)	/* Blood of the Martyr */
	{
		// reduce weight due to damage to self
		int currentRegenerateAmount = GetLocalInt(OBJECT_SELF, regenerationRateStr);
		int currentDamageAmount = 20 - currentRegenerateAmount * giRegenHealScaleAmount;
		if (currentDamageAmount > 0)
		{
			maxEffectWeight	-= GetThreatRating(OBJECT_SELF) * CalculateDamageWeight(IntToFloat(currentDamageAmount), OBJECT_SELF);
		}
	}
    
    if (maxEffectWeight > 0.0)
	{		
        HenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestTarget);
    }
}


void HenchRaiseDead()
{    
    if (!GetIsObjectValid(ogDeadFriend))
    {
        return;
    }
	// don't raise dead near enemies
	if (gsCurrentspInfo.spellID != SPELL_RESURRECTION)
	{
		object oNearestEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
            ogDeadFriend, 1, CREATURE_TYPE_IS_ALIVE, TRUE);
		if (GetIsObjectValid(oNearestEnemy) && (GetDistanceBetween(ogDeadFriend, oNearestEnemy) < 10.0))
		{
			return;
		}	
	}
	
    float curEffectWeight = GetThreatRating(ogDeadFriend) * GetCurrentSpellEffectWeight() *
        gfHealOthersWeightAdjustment;
        
    HenchCheckIfLowestSpellLevelToCast(curEffectWeight, ogDeadFriend);
}


void HenchCheckCureCondition()
{
	int cureMask = GetCurrentSpellEffectTypes();
	int saveType = GetCurrentSpellSaveType();
	int immunity1;
    if (!(gbDisableNonHealorCure ||
		(gbDisableNonUnlimitedOrHealOrCure && !(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_UNLIMITED_FLAG))))
    {
        immunity1 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK) >> 6;
        if (immunity1 && !HenchUseSpellProtections())
        {
            immunity1 = 0;
        }
    }

//	Jug_Debug(GetName(OBJECT_SELF) + " checking cure " + IntToString(gsCurrentspInfo.spellID) + " cure mask " + IntToString(cureMask) + " immunity " + IntToString(immunity1));
		
	float maxEffectWeight;
	object oBestTarget;
	object oTestTarget = OBJECT_SELF;		
	int bIsAreaSpell = gsCurrentspInfo.shape != HENCH_SHAPE_NONE;
	float fRange;
	string sTargetList;	
	if (bIsAreaSpell)
	{
		fRange = bgMeleeAttackers ? gsCurrentspInfo.range : 20.0;
		sTargetList = sAllyLineOfSight;
	}
	else
	{
		fRange = bgMeleeAttackers ? fAllyMeleeTouchRange : 20.0;
		sTargetList = sAllySeen;
	}

	object oFriend = OBJECT_SELF;
	if (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG)
	{
//	Jug_Debug(GetName(OBJECT_SELF) + " not self");	
		oFriend = GetLocalObject(OBJECT_SELF, sTargetList);
	}
	
	int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 10;
	int curLoopCount = 1;
	while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
	{
//		Jug_Debug("%%" + GetName(OBJECT_SELF) + " testing cure target " + GetName(oFriend) + " spell " + IntToString(gsCurrentspInfo.spellID));
		if (GetDistanceBetween(oTestTarget, oFriend) <= fRange)
		{		
			int curNegEffects = GetLocalInt(oFriend, curNegativeEffectsStr) & cureMask;
			if ((curNegEffects != 0) || immunity1)
			{
				float curEffectWeight = GetThreatRating(oFriend);
			
				if (curNegEffects & HENCH_EFFECT_DISABLED)
				{
					gbDisabledAllyFound = TRUE;
				}
				else if (curNegEffects & HENCH_EFFECT_IMPAIRED)
				{
					curEffectWeight *= 0.3;
				}
				else if (immunity1 && !GetIsImmune(oFriend, immunity1))
				{
					curEffectWeight *= 0.2;
				}
				else if (curNegEffects)
				{
					curEffectWeight *= 0.05;
				}
	            else
	            {
					curEffectWeight = 0.0;
	            }
	            if (curEffectWeight > 0.0)
	            {           		
	    			if (oFriend != OBJECT_SELF)
	    			{
	    				// adjust for compassion
	    				curEffectWeight *= gfBuffOthersWeight;			
	    			}
					if (bIsAreaSpell)
	                {
	                    if (!GetIsObjectValid(oBestTarget))
	                    {
	                        oBestTarget = oFriend;
							oTestTarget = oFriend; 
							fRange = gsCurrentspInfo.radius;
	                    }
	                    maxEffectWeight += curEffectWeight;
	                }
					else
	                {
	    			    if (curEffectWeight > maxEffectWeight)
	        			{
	//                        Jug_Debug(GetName(OBJECT_SELF) + " found cure target " + IntToString(curNegEffects));	
	        				maxEffectWeight = curEffectWeight;
	        				oBestTarget = oFriend;
	        			}
	                }
	            }
	        }
		}
		oFriend = GetLocalObject(oFriend, sTargetList);
		curLoopCount ++;
	}
	
	if (!gbDisableNonHealorCure)
	{
		if (cureMask & HENCH_EFFECT_TYPE_DOMINATED)
		{
			iLoopLimit = 10;
			int curLoopCount = 1;
			oFriend = GetLocalObject(OBJECT_SELF, sEnemySeen);
			while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
			{
				int curNegEffects = GetCreatureNegEffects(oFriend) & cureMask;
				if (curNegEffects & HENCH_EFFECT_TYPE_DOMINATED)
				{			
					gbDisabledAllyFound = TRUE;
					float curEffectWeight = GetThreatRating(oFriend) * 2.0;
					if (curEffectWeight > maxEffectWeight)
					{
						maxEffectWeight = curEffectWeight;
						oBestTarget = oFriend;
					}
				} 
				oFriend = GetLocalObject(oFriend, sEnemySeen);
			}	
		}
		if ((cureMask & HENCH_EFFECT_TYPE_CHARMED) && GetIsObjectValid(ogCharmedAlly))
		{
			gbDisabledAllyFound = TRUE;
			float curEffectWeight = GetThreatRating(oFriend);
			if (curEffectWeight > maxEffectWeight)
			{
				maxEffectWeight = curEffectWeight;
				oBestTarget = oFriend;
			}
		}
	}
       
    if (maxEffectWeight > 0.0)
	{		
//        Jug_Debug(GetName(OBJECT_SELF) + " found cure target " + GetName(oBestTarget));	
        HenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestTarget);
    }
}