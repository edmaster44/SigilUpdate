// Script created by comeandsee 11/1/2016
// Converted for SCoD by Ceremorph 11/6/2016
// Note: A complete list of animations for use in this script can be found at
// nwn2.wikia.com/wiki/PlayCustomAnimation:_List_of_animations


#include "nwnx_sql"


void PS_CustomAnimation(object oObject, string sAnimationName, int nLooping, float fSpeed = 1.0f)
{
	PlayCustomAnimation(oObject, sAnimationName, nLooping, fSpeed);
}

int GetAttackBonusTotal(object oPC)
{
	int AB = GetTRUEBaseAttackBonus(oPC);
	int STR = (GetAbilityScore(oPC,ABILITY_STRENGTH) - 10) / 2;
	int DEX = (GetAbilityScore(oPC,ABILITY_DEXTERITY) - 10 ) / 2;

	if(GetHasFeat(42,oPC) && DEX > STR) AB = AB + DEX;  //Weapon Finesse
	if(STR > DEX) AB = AB + STR;
	
	if (AB <= 0) AB = STR;
	
	int count;
	
	effect eAB = GetFirstEffect(oPC);
	while(GetIsEffectValid(eAB))
	{
	if(GetEffectType(eAB) == EFFECT_TYPE_ATTACK_INCREASE)
	{
	count = count + GetEffectInteger(eAB,0);
	}
	eAB = GetNextEffect(oPC);
	}
	
	if(GetHasFeat(584,oPC)) AB = AB + 1; //Epic Prowess
	
	return AB + count;
}

int SneakAttackCount(object oPC)
{
	int featid; int sneak;
	
	SQLExecDirect("SELECT `featid` FROM `featids` WHERE label LIKE '%sneak%';");
	while(SQLFetch())
	{
	featid = StringToInt(SQLGetData(1));
	if(GetHasFeat(featid, oPC)) sneak++;	
	}

	return sneak;
}

int ConcealmentCheck(object oTarget)
{
	int conceal;
	
	effect eConceal = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eConceal))
	{
	if(GetEffectType(eConceal) == EFFECT_TYPE_CONCEALMENT)
	{
	int IntAmt = GetEffectInteger(eConceal,0);
	if (IntAmt > conceal) conceal = IntAmt;
	}
	eConceal = GetNextEffect(oTarget);
	}
	
	if(GetHasFeat(748, oTarget)) return 10;
	if(GetHasFeat(749, oTarget)) return 20;
	if(GetHasFeat(750, oTarget)) return 30;
	if(GetHasFeat(751, oTarget)) return 40;
	if(GetHasFeat(752, oTarget)) return 50;	
	
	return conceal;	
}

int GetIsRangerFavored(object oPC, object oTarget)
{
	if((GetRacialType(oTarget) == RACIAL_TYPE_ABERRATION || GetSubRace(oTarget) == RACIAL_SUBTYPE_ABERRATION) && GetHasFeat(268,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_BEAST || GetSubRace(oTarget) == RACIAL_SUBTYPE_BEAST) && GetHasFeat(270,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetSubRace(oTarget) == RACIAL_SUBTYPE_CONSTRUCT) && GetHasFeat(271,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_DRAGON || GetSubRace(oTarget) == RACIAL_SUBTYPE_DRAGON) && GetHasFeat(272,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_DWARF && GetHasFeat(261,oPC)) return 1; 
	if(GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL && GetHasFeat(277,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_ELF && GetHasFeat(262,oPC)) return 1; 
	if(GetRacialType(oTarget) == RACIAL_TYPE_GIANT && GetHasFeat(279,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_GNOME && GetHasFeat(263,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID || GetSubRace(oTarget) == RACIAL_SUBTYPE_HUMANOID_GOBLINOID) && GetHasFeat(273,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HALFELF || GetSubRace(oTarget) == RACIAL_SUBTYPE_HALFELF) && GetHasFeat(265,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HALFORC || GetSubRace(oTarget) == RACIAL_SUBTYPE_HALFORC) && GetHasFeat(266,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_HALFLING && GetHasFeat(264,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HUMAN || GetSubRace(oTarget) == RACIAL_SUBTYPE_HUMAN) && GetHasFeat(267,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_MAGICAL_BEAST || GetSubRace(oTarget) == RACIAL_SUBTYPE_MAGICAL_BEAST) && GetHasFeat(280,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS && GetHasFeat(274,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_GRAYORC && GetHasFeat(275,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || GetSubRace(oTarget) == RACIAL_SUBTYPE_TIEFLING || GetSubRace(oTarget) == RACIAL_SUBTYPE_AASIMAR 
	|| GetSubRace(oTarget) == RACIAL_SUBTYPE_FIRE_GENASI || GetSubRace(oTarget) == RACIAL_SUBTYPE_EARTH_GENASI || GetSubRace(oTarget) == RACIAL_SUBTYPE_WATER_GENASI) && GetHasFeat(281,oPC)) return 1;
	if(GetSubRace(oTarget) == RACIAL_SUBTYPE_PLANT && GetHasFeat(282,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN || GetSubRace(oTarget) == RACIAL_SUBTYPE_YUANTI || GetSubRace(oTarget) == RACIAL_SUBTYPE_HUMANOID_REPTILIAN) && GetHasFeat(276,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER || GetSubRace(oTarget) == RACIAL_SUBTYPE_SHAPECHANGER) && GetHasFeat(284,oPC)) return 1;	
	if((GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || GetSubRace(oTarget) == RACIAL_SUBTYPE_UNDEAD) && GetHasFeat(285,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_VERMIN || GetSubRace(oTarget) == RACIAL_SUBTYPE_VERMIN) && GetHasFeat(286,oPC)) return 1;	
		
 	return 0;
}

int CalculateRangerBonus(object oPC)
{	
	if(GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES,oPC)) return 2;
	
	return 0;
}

int ApplyFeatsToWeapon(object oPC, object oWeapon)
{
	if(!GetIsObjectValid(oWeapon)) return 0;

	string sWeapon = Get2DAString("baseitems", "label", GetBaseItemType(oWeapon));
	
	string sLabel; int featid;
	
	int iCount = 0;
		
	SQLExecDirect("SELECT `label`, `featid` FROM `featids` WHERE label LIKE '%"+SQLEncodeSpecialChars(sWeapon)+"%';");
	while(SQLFetch())
	{
	sLabel = SQLGetData(1);
	featid = StringToInt(SQLGetData(2));
	
	if(FindSubString(sLabel, "EPIC_WEAPON") >= 0 && GetHasFeat(featid, oPC)) iCount = 4;
	if(FindSubString(sLabel, "GREATER_WEAPON") >= 0 && GetHasFeat(featid, oPC) && iCount < 4) iCount = 2;
	if(FindSubString(sLabel, "WeapFoc") >= 0 && GetHasFeat(featid, oPC) && iCount < 3) iCount = 1;
	if(FindSubString(sLabel, "WEAPON_FOCUS") >= 0 && GetHasFeat(featid, oPC) && iCount < 3) iCount = 1;
	if(FindSubString(sLabel, "WEAPON_OF_CHOICE") >= 0 && GetHasFeat(featid, oPC)) iCount = iCount + 1;
	}

	return iCount;
}

int GetWeaponThreatRange(object oPC, object oWeapon)
{
	if(!GetIsObjectValid(oWeapon)) return 0;

	string sWeapon = Get2DAString("baseitems", "label", GetBaseItemType(oWeapon));
	int ThreatRange = StringToInt(Get2DAString("baseitems", "CritThreat",  GetBaseItemType(oWeapon)));
	
	string sLabel; int featid; int iCount;
		
	SQLExecDirect("SELECT `label`, `featid` FROM `featids` WHERE label LIKE '%"+SQLEncodeSpecialChars(sWeapon)+"%';");
	while(SQLFetch())
	{
	sLabel = SQLGetData(1);
	featid = StringToInt(SQLGetData(2));
	
	if((FindSubString(sLabel, "FEAT_IMPROVED_CRITICAL") >= 0 && GetHasFeat(featid, oPC))
	|| GetItemHasItemProperty(oWeapon,ITEM_PROPERTY_KEEN) == TRUE)
	{
	ThreatRange = ThreatRange * 2;
	}
	
	if(FindSubString(sLabel, "FEAT_KI_CRITICAL") >= 0 && GetHasFeat(featid, oPC)) ThreatRange = ThreatRange + 2;
	}
	
	if (ThreatRange == 1) iCount = 20;
	if (ThreatRange == 2) iCount = 19;
	if (ThreatRange == 3) iCount = 18;
	if (ThreatRange == 4) iCount = 17;
	if (ThreatRange == 6) iCount = 15;
	if (ThreatRange == 8) iCount = 13;
	
	if(ThreatRange <= 0) iCount = 20;
		
	return iCount;
}

int GetWeaponBonuses(object oPC, object oWeapon)
{
	if(!GetIsObjectValid(oWeapon)) return 0;

	int count; int ab; int enhancement;

	itemproperty iProp = GetFirstItemProperty(oWeapon);
	while(GetIsItemPropertyValid(iProp))
	{
	if(GetItemPropertyType(iProp) == ITEM_PROPERTY_ENHANCEMENT_BONUS) enhancement = GetItemPropertyCostTableValue(iProp);
	if(GetItemPropertyType(iProp) == ITEM_PROPERTY_ATTACK_BONUS) ab = GetItemPropertyCostTableValue(iProp);

	iProp = GetNextItemProperty(oWeapon);
	}
	
	if(ab > enhancement) enhancement = ab;
	
	return enhancement;	
}

int GetEnhancementBonus(object oPC, object oWeapon)
{
	if(!GetIsObjectValid(oWeapon)) return 0;

	int count; int ab; int enhancement;

	itemproperty iProp = GetFirstItemProperty(oWeapon);
	while(GetIsItemPropertyValid(iProp))
	{
	if(GetItemPropertyType(iProp) == ITEM_PROPERTY_ENHANCEMENT_BONUS) enhancement = GetItemPropertyCostTableValue(iProp);
	iProp = GetNextItemProperty(oWeapon);
	}

	return enhancement;	
}

int GetDodgeAC(object oTarget)
{
	object oBoots = GetItemInSlot(INVENTORY_SLOT_BOOTS,oTarget);

	int iAC;
	
	itemproperty iProp = GetFirstItemProperty(oBoots);
	while(GetIsItemPropertyValid(iProp))
	{
	if(GetItemPropertyType(iProp) == ITEM_PROPERTY_AC_BONUS)
	{
	iAC = GetItemPropertyCostTableValue(iProp);
	break;
	}

	iProp = GetNextItemProperty(oBoots);
	}
	
	effect eAC = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eAC))
	{
	if(GetEffectType(eAC) == EFFECT_TYPE_AC_INCREASE && GetEffectSubType(eAC) == AC_DODGE_BONUS)
	{
	iAC = iAC + GetEffectInteger(eAC,0);
	}
	eAC = GetNextEffect(oTarget);
	}
	
	int DEX = (GetAbilityScore(oTarget,ABILITY_DEXTERITY) - 10 ) / 2;
	
	return iAC + DEX;
}

int FlatFooted(object oAttacker, object oTarget)
{
	if(GetStealthMode(oAttacker)) return TRUE;
	if(!GetCommandable(oTarget)) return TRUE;
	if(!GetIsInCombat(oTarget)) return TRUE;
	
	effect eEffect = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eEffect))
	{
	if(GetEffectType(eEffect) == (EFFECT_TYPE_PARALYZE || EFFECT_TYPE_DAZED || EFFECT_TYPE_STUNNED || EFFECT_TYPE_SLEEP)) return TRUE;
	eEffect = GetNextEffect(oTarget);
	}
	
	return FALSE;
}

int CountDualWieldingFeats(object oAttacker, object oWeapon)
{
	int iPen = 6;

	if(GetHasFeat(FEAT_TWO_WEAPON_FIGHTING,oAttacker)) iPen = 4;
	if(GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_TWO_WEAPON_FIGHTING,oAttacker))
	{
	string sArmor = Get2DAString("armorrulestats", "RANK", GetArmorRulesType(GetItemInSlot(INVENTORY_SLOT_CHEST,oAttacker)));
	if(sArmor == "None" || sArmor == "Light") iPen = 4;
	}

	if(StringToInt(Get2DAString("WeaponSize", "baseitems", GetBaseItemType(oWeapon))) < GetCreatureSize(oAttacker)) iPen = iPen - 2;

	return iPen;
}

int AttackerABPenalties(object oAttacker, object oRightWeapon)
{
	object oLeftWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oAttacker);
	int iPen;
	
	if(GetIsObjectValid(oLeftWeapon))
	{
	if (GetBaseItemType(oLeftWeapon) == BASE_ITEM_TOWERSHIELD) iPen = 2;
	else iPen = CountDualWieldingFeats(oAttacker, oRightWeapon);	
	}
	
	int count;
	
	effect eAB = GetFirstEffect(oAttacker);
	while(GetIsEffectValid(eAB))
	{
	if(GetEffectType(eAB) == EFFECT_TYPE_ATTACK_DECREASE)
	{
	count = count + GetEffectInteger(eAB,0);
	}
	eAB = GetNextEffect(oAttacker);
	}
	
	return iPen + count;
}

int CreatureSize(object oAttacker)
{
	int size = GetCreatureSize(oAttacker);
	
	if (size == CREATURE_SIZE_HUGE) return -2;
	if (size == CREATURE_SIZE_LARGE) return -1;
	if (size == CREATURE_SIZE_MEDIUM) return 0;
	if (size == CREATURE_SIZE_SMALL) return 1;
	if (size == CREATURE_SIZE_TINY) return 2;
	
	return 0;
}

int AttackerTotalAB(object oAttacker)
{
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oAttacker);
	return (GetAttackBonusTotal(oAttacker) + ApplyFeatsToWeapon(oAttacker, oWeapon) + GetWeaponBonuses(oAttacker, oWeapon) + CreatureSize(oAttacker)) - AttackerABPenalties(oAttacker, oWeapon);
}

// Script provided by comeandsee, Haven Admin
int AttemptMeleeAttackMainHand(object oAttacker, object oTarget, string abilityname, int givefeedback, string animation, int ranged)
{
	//0 - miss, 1 - hit, 2 - critical
	// Melee Attack: 1d20 + base attack bonus + strength modifier + size modifier vs their AC.
	// Damage Roll: Weapon Damage Roll + Strength Modifier + Weapon Enhancement.
	
	
	if(GetDistanceBetween(oAttacker,oTarget) >= 5.0 && ranged == 0)
	{
	SendMessageToPC(oAttacker,"Your target is too far away!");
	if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (miss - target too far)*", oAttacker, TRUE, 3.0f);
	return 0;
	}
	
	int conceal = ConcealmentCheck(oTarget); int imiss;
	
	if(conceal > 0 && conceal > d100())
	{
	imiss = 1;	
	
	if(GetHasFeat(408, oAttacker))
	{
	if(conceal > d100()) imiss = 1;
	else imiss = 0;
	}
	
	}
	
	if(imiss == 1)
	{
	if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (miss - concealment)*", oAttacker, TRUE, 3.0f);
	SendMessageToPC(oAttacker,"You missed! (concealment failure)");
	return 0;
	}
	
	if(GetHasSpellEffect(443,oTarget) || GetHasSpellEffect(724,oTarget))
	{
	if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (miss - etherealness)*", oAttacker, TRUE, 3.0f);
	SendMessageToPC(oAttacker,"You missed! (etherealness failure)");
	return 0;	
	}
				
	int roll = d20();
	int TargetAC = GetAC(oTarget); int iRangerBonus;
			
	if(FlatFooted(oAttacker, oTarget)) TargetAC = TargetAC - GetDodgeAC(oTarget);
	
	int iAttackerAB = AttackerTotalAB(oAttacker); int RangerFavored;
	
	if(GetLevelByClass(CLASS_TYPE_RANGER,oAttacker) > 0 && GetIsRangerFavored(oAttacker, oTarget) > 0)
	{
	iAttackerAB = iAttackerAB + CalculateRangerBonus(oAttacker);
	}
	
	int iAttack = roll + iAttackerAB;
	
	if(roll == 20 || iAttack >= TargetAC && roll > 1)
	{
	SendMessageToPC(oAttacker,"You hit! " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
	int ThreatRange = GetWeaponThreatRange(oAttacker, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oAttacker));
	
	if(animation != "") PS_CustomAnimation(oAttacker,animation,0);
	
	if(roll >= ThreatRange)
	{
	int confirmationRoll = d20();
	int confirmationTotal = confirmationRoll + iAttackerAB;
	
	if (confirmationRoll == 20 || confirmationTotal >= TargetAC && confirmationRoll > 1)
	{
		if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (critical hit)*", oAttacker, TRUE, 3.0f);
		return 2;
		}
	}
	
	if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (hit)*", oAttacker, TRUE, 3.0f);
	return 1;	
	}
	
	if(givefeedback == 1) FloatingTextStringOnCreature(abilityname+" (miss)*", oAttacker, TRUE, 3.0f);
	SendMessageToPC(oAttacker,"You missed! "+IntToString(iAttack)+" vs "+IntToString(TargetAC));
	
	return 0;
}