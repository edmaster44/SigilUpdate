#include "x2_inc_itemprop"

void Enforce(int result, string msg, string file, int line){
	if(!result){
		SendMessageToAllDMs(file + ":" + IntToString(line) + ": Enforce failed: " + msg);
	}
}


// TODO: does not work with ITEM_PROPERTY_DAMAGE_REDUCTION
itemproperty BuildItemProperty(int nType, int nSubType = -1, int nCostValue = -1, int nParam1 = -1){
	switch(nType){
		case ITEM_PROPERTY_ABILITY_BONUS:                            return ItemPropertyAbilityBonus(nSubType, nCostValue);
		case ITEM_PROPERTY_AC_BONUS:                                 return ItemPropertyACBonus(nCostValue);
		case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:              return ItemPropertyACBonusVsAlign(nSubType, nCostValue);
		case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:                  return ItemPropertyACBonusVsDmgType(nSubType, nCostValue);
		case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:                 return ItemPropertyACBonusVsRace(nSubType, nCostValue);
		case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:           return ItemPropertyACBonusVsSAlign(nSubType, nCostValue);
		case ITEM_PROPERTY_ENHANCEMENT_BONUS:                        return ItemPropertyEnhancementBonus(nCostValue);
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:     return ItemPropertyEnhancementBonusVsAlign(nSubType, nCostValue);
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:        return ItemPropertyEnhancementBonusVsRace(nSubType, nCostValue);
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT: return ItemPropertyEnhancementBonusVsSAlign(nSubType, nCostValue);
		case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:           return ItemPropertyEnhancementPenalty(nCostValue);
		case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:               return ItemPropertyWeightReduction(nCostValue);
		case ITEM_PROPERTY_BONUS_FEAT:                               return ItemPropertyBonusFeat(nSubType);
		case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:              return ItemPropertyBonusLevelSpell(nSubType, nCostValue);
		// DELETED
		case ITEM_PROPERTY_CAST_SPELL:                               return ItemPropertyCastSpell(nSubType, nCostValue);
		case ITEM_PROPERTY_DAMAGE_BONUS:                             return ItemPropertyDamageBonus(nSubType, nCostValue);
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:          return ItemPropertyDamageBonusVsAlign(nSubType, nParam1, nCostValue);
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:             return ItemPropertyDamageBonusVsRace(nSubType, nParam1, nCostValue);
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:       return ItemPropertyDamageBonusVsSAlign(nSubType, nParam1, nCostValue);
		case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:                     return ItemPropertyDamageImmunity(nSubType, nCostValue);
		case ITEM_PROPERTY_DECREASED_DAMAGE:                         return ItemPropertyDamagePenalty(nCostValue);
		// DELETED
		case ITEM_PROPERTY_DAMAGE_RESISTANCE:                        return ItemPropertyDamageResistance(nSubType, nCostValue);
		case ITEM_PROPERTY_DAMAGE_VULNERABILITY:                     return ItemPropertyDamageVulnerability(nSubType, nCostValue);
		// DELETED
		case ITEM_PROPERTY_DARKVISION:                               return ItemPropertyDarkvision();
		case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:                  return ItemPropertyDecreaseAbility(nSubType, nCostValue);
		case ITEM_PROPERTY_DECREASED_AC:                             return ItemPropertyDecreaseAC(nSubType, nCostValue);
		case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:                 return ItemPropertyDecreaseSkill(nSubType, nCostValue);
		// DELETED
		// DELETED
		case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:        return ItemPropertyContainerReducedWeight(nCostValue);
		case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:                  return ItemPropertyExtraMeleeDamageType(nSubType);
		case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:                 return ItemPropertyExtraRangeDamageType(nSubType);
		case ITEM_PROPERTY_HASTE:                                    return ItemPropertyHaste();
		case ITEM_PROPERTY_HOLY_AVENGER:                             return ItemPropertyHolyAvenger();
		case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:                   return ItemPropertyImmunityMisc(nSubType);
		case ITEM_PROPERTY_IMPROVED_EVASION:                         return ItemPropertyImprovedEvasion();
		case ITEM_PROPERTY_SPELL_RESISTANCE:                         return ItemPropertyBonusSpellResistance(nCostValue);
		case ITEM_PROPERTY_SAVING_THROW_BONUS:                       return ItemPropertyBonusSavingThrowVsX(nSubType, nCostValue);
		case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:              return ItemPropertyBonusSavingThrow(nSubType, nCostValue);
		// DELETED
		case ITEM_PROPERTY_KEEN:                                     return ItemPropertyKeen();
		case ITEM_PROPERTY_LIGHT:                                    return ItemPropertyLight(nCostValue, nParam1);
		case ITEM_PROPERTY_MIGHTY:                                   return ItemPropertyMaxRangeStrengthMod(nCostValue);
		// DELETED
		case ITEM_PROPERTY_NO_DAMAGE:                                return ItemPropertyNoDamage();
		case ITEM_PROPERTY_ON_HIT_PROPERTIES:                        return ItemPropertyOnHitProps(nSubType, nCostValue, nParam1); // Not sure, needs testing
		case ITEM_PROPERTY_DECREASED_SAVING_THROWS:                  return ItemPropertyReducedSavingThrowVsX(nSubType, nCostValue);
		case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:         return ItemPropertyReducedSavingThrow(nSubType, nCostValue);
		case ITEM_PROPERTY_REGENERATION:                             return ItemPropertyRegeneration(nCostValue);
		case ITEM_PROPERTY_SKILL_BONUS:                              return ItemPropertySkillBonus(nSubType, nCostValue);
		case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:                  return ItemPropertySpellImmunitySpecific(nCostValue);
		case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:                    return ItemPropertySpellImmunitySchool(nSubType);
		case ITEM_PROPERTY_THIEVES_TOOLS:                            return ItemPropertyThievesTools(nCostValue);
		case ITEM_PROPERTY_ATTACK_BONUS:                             return ItemPropertyAttackBonus(nCostValue);
		case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:          return ItemPropertyAttackBonusVsAlign(nSubType, nCostValue);
		case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:             return ItemPropertyAttackBonusVsRace(nSubType, nCostValue);
		case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:       return ItemPropertyAttackBonusVsSAlign(nSubType, nCostValue);
		case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:                return ItemPropertyAttackPenalty(nCostValue);
		case ITEM_PROPERTY_UNLIMITED_AMMUNITION:                     return ItemPropertyUnlimitedAmmo(nCostValue); // Warning: There is a subtype value for arrow/bolt/bullet
		case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:           return ItemPropertyLimitUseByAlign(nSubType);
		case ITEM_PROPERTY_USE_LIMITATION_CLASS:                     return ItemPropertyLimitUseByClass(nSubType);
		case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:               return ItemPropertyLimitUseByRace(nSubType);
		case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:        return ItemPropertyLimitUseBySAlign(nSubType);
		case ITEM_PROPERTY_BONUS_HITPOINTS:                          return ItemPropertyBonusHitpoints(nCostValue);
		case ITEM_PROPERTY_REGENERATION_VAMPIRIC:                    return ItemPropertyVampiricRegeneration(nCostValue);
		// DELETED
		// DELETED
		case ITEM_PROPERTY_TRAP:                                     return ItemPropertyTrap(nSubType, nCostValue);
		case ITEM_PROPERTY_TRUE_SEEING:                              return ItemPropertyTrueSeeing();
		case ITEM_PROPERTY_ON_MONSTER_HIT:                           return ItemPropertyOnMonsterHitProperties(nSubType, nParam1); // Not sure, needs testing
		case ITEM_PROPERTY_TURN_RESISTANCE:                          return ItemPropertyTurnResistance(nCostValue);
		case ITEM_PROPERTY_MASSIVE_CRITICALS:                        return ItemPropertyMassiveCritical(nCostValue);
		case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:                      return ItemPropertyFreeAction();
		// DELETED
		case ITEM_PROPERTY_MONSTER_DAMAGE:                           return ItemPropertyMonsterDamage(nCostValue);
		case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:                 return ItemPropertyImmunityToSpellLevel(nCostValue);
		case ITEM_PROPERTY_SPECIAL_WALK:                             return ItemPropertySpecialWalk(nSubType);
		case ITEM_PROPERTY_HEALERS_KIT:                              return ItemPropertyHealersKit(nCostValue);
		case ITEM_PROPERTY_WEIGHT_INCREASE:                          return ItemPropertyWeightIncrease(nParam1);
		case ITEM_PROPERTY_ONHITCASTSPELL:                           return ItemPropertyOnHitCastSpell(nSubType, nCostValue);
		case ITEM_PROPERTY_VISUALEFFECT:                             return ItemPropertyVisualEffect(nSubType);
		case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:                     return ItemPropertyArcaneSpellFailure(nCostValue);
		// DELETED
		// DELETED
		// DELETED
		// DELETED
		// DELETED
		// case ITEM_PROPERTY_DAMAGE_REDUCTION: return ItemPropertyDamageReduction(nSubType, int nDRSubType, int nLimit=0, int nDRType=DR_TYPE_MAGICBONUS);
	}
	itemproperty ip;
	return ip;
}

string IprpImmuCostToString(int nImmuCost, int bRaiseBug = TRUE){
	return Get2DAString("iprp_immuncost", "Value", nImmuCost);
}
int IprpImmuCostToInt(int nImmuCost, int bRaiseBug = TRUE){
	return StringToInt(IprpImmuCostToString(nImmuCost, bRaiseBug));
}
// iprp_immuncost.2da
int StringToIprpImmuCost(string sImmuCost, int bRaiseBug = TRUE){
	if     (sImmuCost == "5")   return IP_CONST_DAMAGEIMMUNITY_5_PERCENT;
	else if(sImmuCost == "10")  return IP_CONST_DAMAGEIMMUNITY_10_PERCENT;
	else if(sImmuCost == "25")  return IP_CONST_DAMAGEIMMUNITY_25_PERCENT;
	else if(sImmuCost == "50")  return IP_CONST_DAMAGEIMMUNITY_50_PERCENT;
	else if(sImmuCost == "75")  return IP_CONST_DAMAGEIMMUNITY_75_PERCENT;
	else if(sImmuCost == "90")  return IP_CONST_DAMAGEIMMUNITY_90_PERCENT;
	else if(sImmuCost == "100") return IP_CONST_DAMAGEIMMUNITY_100_PERCENT;
	else if(sImmuCost == "15")  return 8;
	else if(sImmuCost == "20")  return 9;
	else if(sImmuCost == "30")  return 10;
	return -1;
}

// Converts an index in iprp_srcost.2da into the numerical value
int IprpSRValueToInt(int nIprpSRValue, int bRaiseBug = TRUE){
	switch(nIprpSRValue){
		case 0:  return 10;
		case 1:  return 12;
		case 2:  return 14;
		case 3:  return 16;
		case 4:  return 18;
		case 5:  return 20;
		case 6:  return 22;
		case 7:  return 24;
		case 8:  return 26;
		case 9:  return 28;
		case 10: return 30;
		case 11: return 32;
		case 12: return 34;
		case 13: return 36;
		case 14: return 38;
		case 15: return 40;
		case 16: return 19;
		default: break;
	}
	return -1;
}
// Converts a numerical value to the associated index in iprp_srcost.2da. If
// the nValue does not match any 2da entry (ex. with an odd value), the lower
// value is returned.
int IntToIprpSRValue(int nValue, int bRaiseBug = TRUE){
	while(nValue > 0){
		switch(nValue){
			case 10: return 0;
			case 12: return 1;
			case 14: return 2;
			case 16: return 3;
			case 18: return 4;
			case 20: return 5;
			case 22: return 6;
			case 24: return 7;
			case 26: return 8;
			case 28: return 9;
			case 30: return 10;
			case 32: return 11;
			case 34: return 12;
			case 36: return 13;
			case 38: return 14;
			case 40: return 15;
			case 19: return 16;
			default: break;
		}
		nValue--;
	}
	return -1;
}
int StringToIprpSpellFailure(string sSpellFailure, int bRaiseBug = TRUE){
	if     (sSpellFailure == "-50") return 0;
	else if(sSpellFailure == "-45") return 1;
	else if(sSpellFailure == "-40") return 2;
	else if(sSpellFailure == "-35") return 3;
	else if(sSpellFailure == "-30") return 4;
	else if(sSpellFailure == "-25") return 5;
	else if(sSpellFailure == "-20") return 6;
	else if(sSpellFailure == "-15") return 7;
	else if(sSpellFailure == "-10") return 8;
	else if(sSpellFailure == "-5")  return 9;
	else if(sSpellFailure == "5")   return 10;
	else if(sSpellFailure == "10")  return 11;
	else if(sSpellFailure == "15")  return 12;
	else if(sSpellFailure == "20")  return 13;
	else if(sSpellFailure == "25")  return 14;
	else if(sSpellFailure == "30")  return 15;
	else if(sSpellFailure == "35")  return 16;
	else if(sSpellFailure == "40")  return 17;
	else if(sSpellFailure == "45")  return 18;
	else if(sSpellFailure == "50")  return 19;
	return -1;
}
string ItempropertyToString(itemproperty ip){
	return "(" + IntToString(GetItemPropertyType(ip)) + "," + IntToString(GetItemPropertySubType(ip)) + "," + IntToString(GetItemPropertyCostTableValue(ip)) + "," + IntToString(GetItemPropertyParam1Value(ip)) + ")";
}

itemproperty GetSimilarItemProperty(object oItem, itemproperty ipSimilar, int bIgnoreSubType = FALSE);


struct EnhanceItemPropertyCostValueRet {
	int act;// 0: impossible, 1: add, 2: replace, 3: remove,
	itemproperty ip_res;// IP result
	itemproperty ip_diff;// what the player payed for
};

// Combine two item properties together
struct EnhanceItemPropertyCostValueRet EnhanceItemPropertyCostValue(int nBaseItemType, itemproperty ipCurrent, int nCostValueBonus)
{
	struct EnhanceItemPropertyCostValueRet ret;

	int nType = GetItemPropertyType(ipCurrent);
	int nSubType = GetItemPropertySubType(ipCurrent);
	int nCostValue = GetItemPropertyCostTableValue(ipCurrent);

	// Hitpoint bonus can be added multiple times
	switch(nType){
		case ITEM_PROPERTY_DAMAGE_BONUS:
		case ITEM_PROPERTY_BONUS_HITPOINTS:
			ret.act = 1;
			ret.ip_res = BuildItemProperty(nType, nSubType, nCostValueBonus);
			ret.ip_diff = ret.ip_res;
			return ret;
		default: break;
	}

	switch(GetItemPropertyCostTable(ipCurrent))
	{
		case 1: // IPRP_BONUSCOST
			// From 1 to 12
			if(nCostValue + nCostValueBonus <= 12){
				ret.act = 2;
				ret.ip_res = BuildItemProperty(nType, nSubType, nCostValue + nCostValueBonus);
				ret.ip_diff = BuildItemProperty(nType, nSubType, nCostValueBonus);
			}
			else if(nCostValue < 12){
				ret.act = 2;
				ret.ip_res = BuildItemProperty(nType, nSubType, 12);
				ret.ip_diff = BuildItemProperty(nType, nSubType, 12 - nCostValue);
			}
			break;

		case 2: // IPRP_MELEECOST
			{
				// From 1 to 20
				if(nCostValue + nCostValueBonus <= 20){
					ret.act = 2;
					ret.ip_res = BuildItemProperty(nType, nSubType, nCostValue + nCostValueBonus);
					ret.ip_diff = BuildItemProperty(nType, nSubType, nCostValueBonus);
				}
				else if(nCostValue < 20){
					ret.act = 2;
					ret.ip_res = BuildItemProperty(nType, nSubType, 20);
					ret.ip_diff = BuildItemProperty(nType, nSubType, 20 - nCostValue);
				}
			}
			break;

		case 5: // IPRP_IMMUNCOST
			{
				int nCurrValue = IprpImmuCostToInt(nCostValue);
				int nBonusValue = IprpImmuCostToInt(nCostValueBonus);
				int nMax = 5;
				switch(nBaseItemType){
					case BASE_ITEM_ARMOR:
					case BASE_ITEM_HELMET:
					case BASE_ITEM_BELT:
						nMax = 10;
						break;
					default: break;
				}
				if(nCurrValue + nBonusValue <= nMax){
					int nNewCostValue = StringToIprpImmuCost(IntToString(nCurrValue + nBonusValue), FALSE);
					if(nNewCostValue > 0){
						ret.act = 2;
						ret.ip_res = BuildItemProperty(nType, nSubType, nNewCostValue);
						ret.ip_diff = BuildItemProperty(nType, nSubType, nCostValueBonus);
					}
				}
				else if(nCurrValue < nMax){
					int nDiffCostValue = StringToIprpImmuCost(IntToString(nMax - nCurrValue), FALSE);
					if(nDiffCostValue > 0){
						int nNewCostValue = StringToIprpImmuCost(IntToString(nMax));
						ret.act = 2;
						ret.ip_res = BuildItemProperty(nType, nSubType, nNewCostValue);
						ret.ip_diff = BuildItemProperty(nType, nSubType, nDiffCostValue);
					}
				}
			}
			break;

		case 7: // IPRP_RESISTCOST
			// resistance = costValue * 5
			// From id 1 to id 10
			if(nCostValue + nCostValueBonus <= 10){
				ret.act = 2;
				ret.ip_res = BuildItemProperty(nType, nSubType, nCostValue + nCostValueBonus);
				ret.ip_diff = BuildItemProperty(nType, nSubType, nCostValueBonus);
			}
			else if(nCostValue < 10){
				ret.act = 2;
				ret.ip_res = BuildItemProperty(nType, nSubType, 10);
				ret.ip_diff = BuildItemProperty(nType, nSubType, 10 - nCostValue);
			}
			break;

		case 11: // IPRP_SRCOST
			{
				int nCurrValue = IprpSRValueToInt(nCostValue);
				int nBonusValue = IprpSRValueToInt(nCostValueBonus);
				if(nCurrValue + nBonusValue <= 40){
					int nNewCostValue = IntToIprpSRValue(nCurrValue + nBonusValue);
					if(nNewCostValue >= 0){
						ret.act = 2;
						ret.ip_res = BuildItemProperty(nType, nSubType, nNewCostValue);
						ret.ip_diff = BuildItemProperty(nType, nSubType, nCostValue);
					}
				}
				else if(nCurrValue < 40){
					int nDiffCostValue = IntToIprpSRValue(40 - nCurrValue);
					if(nDiffCostValue > 0){
						ret.act = 2;
						ret.ip_res = BuildItemProperty(nType, nSubType, 15);//Bonus_40
						ret.ip_diff = BuildItemProperty(nType, nSubType, nDiffCostValue);
					}
				}
			}
			break;

		case 25: // IPRP_SKILLCOST
			// From 1 to 50
			if(nCostValue + nCostValueBonus <= 50){
				ret.act = 2;
				ret.ip_res = BuildItemProperty(nType, nSubType, nCostValue + nCostValueBonus);
				ret.ip_diff = BuildItemProperty(nType, nSubType, nCostValueBonus);
			}
			else if(nCostValue < 50){
				ret.act = 2;
				ret.ip_res = BuildItemProperty(nType, nSubType, 50);
				ret.ip_diff = BuildItemProperty(nType, nSubType, 50 - nCostValue);
			}
			break;

		case 27: // IPRP_ARCSPELL
			{
				int nCurrValue = StringToInt(Get2DAString("IPRP_ARCSPELL", "Value", nCostValue));
				int nBonusValue = StringToInt(Get2DAString("IPRP_ARCSPELL", "Value", nCostValueBonus));
				int nResValue = nCurrValue + nBonusValue;
				if(nResValue == 0){
					// The iprp should be removed
					ret.act = 3;
					ret.ip_res = BuildItemProperty(nType, nSubType, nCostValue);
					ret.ip_diff = ret.ip_res;
				}
				else{
					if(nResValue >= -50 && nResValue <= 50){
						int nNewCostValue = StringToIprpSpellFailure(IntToString(nResValue), FALSE);
						if(nNewCostValue >= 0){
							ret.act = 2;
							ret.ip_res = BuildItemProperty(nType, nSubType, nNewCostValue);
							ret.ip_diff = BuildItemProperty(nType, nSubType, nCostValue);
						}
					}
					else if(nCurrValue < 50 && nBonusValue > 0){
						int nDiffCostValue = StringToIprpSpellFailure(IntToString(50 - nCurrValue));
						if(nDiffCostValue > 0){
							ret.act = 2;
							ret.ip_res = BuildItemProperty(nType, nSubType, IP_CONST_ARCANE_SPELL_FAILURE_PLUS_50_PERCENT);
							ret.ip_diff = BuildItemProperty(nType, nSubType, nDiffCostValue);
						}
					}
					else if(nCurrValue > -50 && nBonusValue < 0){
						int nDiffCostValue = StringToIprpSpellFailure(IntToString(-50 - nCurrValue));
						if(nDiffCostValue > 0){
							ret.act = 2;
							ret.ip_res = BuildItemProperty(nType, nSubType, IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT);
							ret.ip_diff = BuildItemProperty(nType, nSubType, nDiffCostValue);
						}

					}
				}
			}
			break;
		default:
			Enforce(FALSE, "Unhandled cost table " + IntToString(GetItemPropertyCostTable(ipCurrent)) + " for IPRP " + ItempropertyToString(ipCurrent), __FILE__, __LINE__);
	}

	return ret;
}

struct EnhanceItemPropertyCostValueRet GetItemEnhancedItemProperty(object oItem, itemproperty ipToAdd){
	struct EnhanceItemPropertyCostValueRet ret;
	itemproperty ipExisting = GetSimilarItemProperty(oItem, ipToAdd);
	if(GetIsItemPropertyValid(ipExisting))
	{
		int nCostTable = StringToInt(Get2DAString("itempropdef", "CostTableResRef", GetItemPropertyType(ipExisting)));
		if(nCostTable > 0){
			// Replace with similar property with higher cost value
			ret = EnhanceItemPropertyCostValue(
				GetBaseItemType(oItem),
				ipExisting,
				GetItemPropertyCostTableValue(ipToAdd)
			);
		}
	}
	else{
		ret.act = 1;
		ret.ip_res = ipToAdd;
		ret.ip_diff = ipToAdd;
	}
	return ret;
}


itemproperty GetSimilarItemProperty(object oItem, itemproperty ipSimilar, int bIgnoreSubType = FALSE)
{
	int nType = GetItemPropertyType(ipSimilar);
	int nSubType = GetItemPropertySubType(ipSimilar);
	switch(nType)
	{
		case ITEM_PROPERTY_AC_BONUS:
		case ITEM_PROPERTY_ENHANCEMENT_BONUS:
		case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
		case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
		case ITEM_PROPERTY_DECREASED_DAMAGE:
		case ITEM_PROPERTY_DARKVISION:
		case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
		case ITEM_PROPERTY_HASTE:
		case ITEM_PROPERTY_HOLY_AVENGER:
		case ITEM_PROPERTY_IMPROVED_EVASION:
		case ITEM_PROPERTY_SPELL_RESISTANCE:
		case ITEM_PROPERTY_KEEN:
		case ITEM_PROPERTY_LIGHT:
		case ITEM_PROPERTY_MIGHTY:
		case ITEM_PROPERTY_NO_DAMAGE:
		case ITEM_PROPERTY_REGENERATION:
		case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
		case ITEM_PROPERTY_THIEVES_TOOLS:
		case ITEM_PROPERTY_ATTACK_BONUS:
		case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
		case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
		case ITEM_PROPERTY_BONUS_HITPOINTS:
		case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
		case ITEM_PROPERTY_TRUE_SEEING:
		case ITEM_PROPERTY_TURN_RESISTANCE:
		case ITEM_PROPERTY_MASSIVE_CRITICALS:
		case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
		case ITEM_PROPERTY_MONSTER_DAMAGE:
		case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
		case ITEM_PROPERTY_HEALERS_KIT:
		case ITEM_PROPERTY_WEIGHT_INCREASE:
		case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:
			bIgnoreSubType = TRUE;
			break;
		default: break;
	}

	itemproperty ip = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(ip))
	{
		if(GetItemPropertyType(ip) == nType)
		{
			if(bIgnoreSubType || GetItemPropertySubType(ip) == nSubType)
			{
				return ip;
			}
		}
		ip = GetNextItemProperty(oItem);
	}
	return ip;
}


int EnchantItem(object oItem, itemproperty iprp, int nCost)
{
	// Remove temporary properties
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_TEMPORARY);

	int nIprpType = GetItemPropertyType(iprp);
	int nIprpSubType = GetItemPropertySubType(iprp);

	struct EnhanceItemPropertyCostValueRet ipToAdd = GetItemEnhancedItemProperty(oItem, iprp);

	if(ipToAdd.act == 0)
		return FALSE;
	else if(ipToAdd.act == 1){// add
		Enforce(GetIsItemPropertyValid(ipToAdd.ip_res), "Invalid IPRP to add: " + ItempropertyToString(ipToAdd.ip_res), __FILE__, __LINE__);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipToAdd.ip_res, oItem);
	}
	else if(ipToAdd.act == 2){// replace
		Enforce(GetIsItemPropertyValid(ipToAdd.ip_res), "Invalid IPRP to replace: " + ItempropertyToString(ipToAdd.ip_res), __FILE__, __LINE__);
		IPSafeAddItemProperty(oItem, ipToAdd.ip_res, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	}
	else if(ipToAdd.act == 3){// remove
		Enforce(GetIsItemPropertyValid(ipToAdd.ip_res), "Invalid IPRP to remove: " + ItempropertyToString(ipToAdd.ip_res), __FILE__, __LINE__);
		RemoveItemProperty(oItem, ipToAdd.ip_res);
	}

	SetLocalInt(oItem, "hagbe_ench", TRUE);
	SetLocalInt(oItem, "hagbe_iprp_t", GetItemPropertyType(ipToAdd.ip_diff));
	SetLocalInt(oItem, "hagbe_iprp_st", GetItemPropertySubType(ipToAdd.ip_diff));
	SetLocalInt(oItem, "hagbe_iprp_c", GetItemPropertyCostTableValue(ipToAdd.ip_diff));
	SetLocalInt(oItem, "hagbe_iprp_p1", GetItemPropertyParam1Value(ipToAdd.ip_diff));
	SetLocalInt(oItem, "hagbe_cost", nCost);
	SetFirstName(oItem, GetName(oItem) + " <c=#9257FF>*</c>");
	return TRUE;
}




int GetIsItemEnchanted(object oItem)
{
	return GetLocalInt(oItem, "hagbe_ench");
}

