	// Script created by comeandsee 11/1/2016
// Converted for SCoD by Ceremorph 11/6/2016
// Note: A complete list of animations for use in this script can be found at
// nwn2.wikia.com/wiki/PlayCustomAnimation:_List_of_animations


#include "nwnx_sql"
#include "X0_I0_SPELLS"
#include "ps_inc_time"

int GetDamageBonusInt(int nBonus)
{
	if(nBonus <= 5) return nBonus;
	if(nBonus >= 6) return 10 + nBonus;
	
	return nBonus;
}

int GetDamageBonusDie(int damagebonus)
{
	//Use IP_CONST_DAMAGEBONUS
	if (damagebonus == 1) return   1;
	if (damagebonus == 2) return   2;
	if (damagebonus == 3) return   3;
	if (damagebonus == 4) return   4;
	if (damagebonus == 5) return   5;
	if (damagebonus == 16) return  6;
	if (damagebonus == 17) return  7;
	if (damagebonus == 18) return  8;
	if (damagebonus == 19) return  9;
	if (damagebonus == 20) return  10;
			
	if (damagebonus == 6) return   d4();
	if (damagebonus == 7) return   d6();
	if (damagebonus == 8) return   d8();
	if (damagebonus == 9) return  d10();
	if (damagebonus == 14) return d12();

	if (damagebonus == 12) return  d4(2);		
	if (damagebonus == 10) return  d6(2);
	if (damagebonus == 11) return  d8(2);
	if (damagebonus == 13) return d10(2);
	if (damagebonus == 15) return d12(2);
	
	if (damagebonus == 51) return d10(3);
	if (damagebonus == 52) return d12(3);
	if (damagebonus == 60) return d6(3);
	
	if (damagebonus == 55) return d10(4);
	if (damagebonus == 56) return d12(4);
	if (damagebonus == 53) return d6(4);
	if (damagebonus == 54) return d8(4);

	if (damagebonus == 58) return d12(5);
	if (damagebonus == 57) return d6(5);
	
	if (damagebonus == 59) return d12(6);
	if (damagebonus == 61) return d6(6);
			
	return 0;
}

int GetDamageBonusType(int damagetype)
{
	if(damagetype == 0) return DAMAGE_TYPE_BLUDGEONING;
	if(damagetype == 6) return DAMAGE_TYPE_ACID;
	if(damagetype == 7) return DAMAGE_TYPE_COLD;
	if(damagetype == 8) return DAMAGE_TYPE_DIVINE;
	if(damagetype == 9) return DAMAGE_TYPE_ELECTRICAL;
	if(damagetype == 10) return DAMAGE_TYPE_FIRE;
	if(damagetype == 5) return DAMAGE_TYPE_MAGICAL;
	if(damagetype == 11) return DAMAGE_TYPE_NEGATIVE;	
	if(damagetype == 1) return DAMAGE_TYPE_PIERCING;
	if(damagetype == 12) return DAMAGE_TYPE_POSITIVE;
	if(damagetype == 2) return DAMAGE_TYPE_SLASHING;
	if(damagetype == 13) return DAMAGE_TYPE_SONIC;

	return 0;
}

void BattleCry(object oPC)
{
	int nD3 = d3(1);
	switch (nD3)
	{
		case 1: PlayVoiceChat(VOICE_CHAT_GATTACK1, oPC); break;
		case 2: PlayVoiceChat(VOICE_CHAT_GATTACK2, oPC); break;
		case 3: PlayVoiceChat(VOICE_CHAT_GATTACK3, oPC); break;
	}
}

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
	int conceal; int IntAmt; int iConceal;
	
	effect eConceal = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eConceal))
	{
	if(GetEffectType(eConceal) == EFFECT_TYPE_CONCEALMENT)
	{
		IntAmt = GetEffectInteger(eConceal,0);
		if (IntAmt > conceal) conceal = IntAmt;
	}
	eConceal = GetNextEffect(oTarget);
	}
	
	if(GetHasFeat(748, oTarget)) iConceal = 10;
	if(GetHasFeat(749, oTarget)) iConceal = 20;
	if(GetHasFeat(750, oTarget)) iConceal = 30;
	if(GetHasFeat(751, oTarget)) iConceal = 40;
	if(GetHasFeat(752, oTarget)) iConceal = 50;	
	
	if(iConceal > conceal) conceal = iConceal;
	
	return conceal;	
}

int InvisibilityCheck(object oTarget)
{
	int Invis;
	
	effect eInvis = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eInvis))
	{
	if(GetEffectType(eInvis) == EFFECT_TYPE_INVISIBILITY || GetEffectType(eInvis) == EFFECT_TYPE_GREATERINVISIBILITY) return 1;
	eInvis = GetNextEffect(oTarget);
	}
	
	return 0;	
}

int GetIsImprovedRangerFavored(object oPC, object oTarget)
{
	if((GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL || GetSubRace(oTarget) == RACIAL_SUBTYPE_ANIMAL) && GetHasFeat(1206,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_ABERRATION || GetSubRace(oTarget) == RACIAL_SUBTYPE_ABERRATION) && GetHasFeat(1205,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_BEAST || GetSubRace(oTarget) == RACIAL_SUBTYPE_BEAST) && GetHasFeat(1207,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetSubRace(oTarget) == RACIAL_SUBTYPE_CONSTRUCT) && GetHasFeat(1208,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_DRAGON || GetSubRace(oTarget) == RACIAL_SUBTYPE_DRAGON) && GetHasFeat(1209,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_DWARF && GetHasFeat(1198,oPC)) return 1; 
	if(GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL && GetHasFeat(277,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_ELF && GetHasFeat(1199,oPC)) return 1; 
	if(GetRacialType(oTarget) == RACIAL_TYPE_GIANT && GetHasFeat(1216,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_GNOME && GetHasFeat(1200,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID || GetSubRace(oTarget) == RACIAL_SUBTYPE_HUMANOID_GOBLINOID) && GetHasFeat(1210,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HALFELF || GetSubRace(oTarget) == RACIAL_SUBTYPE_HALFELF) && GetHasFeat(1203,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HALFORC || GetSubRace(oTarget) == RACIAL_SUBTYPE_HALFORC) && GetHasFeat(1203,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_HALFLING && GetHasFeat(1201,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HUMAN || GetSubRace(oTarget) == RACIAL_SUBTYPE_HUMAN) && GetHasFeat(1204,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_MAGICAL_BEAST || GetSubRace(oTarget) == RACIAL_SUBTYPE_MAGICAL_BEAST) && GetHasFeat(1207,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS && GetHasFeat(1211,oPC)) return 1;
	if(GetRacialType(oTarget) == RACIAL_TYPE_GRAYORC && GetHasFeat(1212,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || GetSubRace(oTarget) == RACIAL_SUBTYPE_TIEFLING || GetSubRace(oTarget) == RACIAL_SUBTYPE_AASIMAR 
	|| GetSubRace(oTarget) == RACIAL_SUBTYPE_FIRE_GENASI || GetSubRace(oTarget) == RACIAL_SUBTYPE_EARTH_GENASI || GetSubRace(oTarget) == RACIAL_SUBTYPE_WATER_GENASI) && GetHasFeat(1218,oPC)) return 1;
	if(GetSubRace(oTarget) == RACIAL_SUBTYPE_PLANT && GetHasFeat(2055,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN || GetSubRace(oTarget) == RACIAL_SUBTYPE_YUANTI || GetSubRace(oTarget) == RACIAL_SUBTYPE_HUMANOID_REPTILIAN) && GetHasFeat(1213,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER || GetSubRace(oTarget) == RACIAL_SUBTYPE_SHAPECHANGER) && GetHasFeat(1219,oPC)) return 1;	
	if((GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || GetSubRace(oTarget) == RACIAL_SUBTYPE_UNDEAD) && GetHasFeat(1220,oPC)) return 1;
	if((GetRacialType(oTarget) == RACIAL_TYPE_VERMIN || GetSubRace(oTarget) == RACIAL_SUBTYPE_VERMIN) && GetHasFeat(1221,oPC)) return 1;	
		
 	return 0;
}

int GetIsRangerFavored(object oPC, object oTarget)
{
	if((GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL || GetSubRace(oTarget) == RACIAL_SUBTYPE_ANIMAL) && GetHasFeat(269,oPC)) return 1;

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
	int iBonus;

	if(GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES,oPC)) return 2;
	
	return iBonus;
}

int CalculateRangerTotal(object oAttacker,object oTarget)
{	
	int iRanger = GetLevelByClass(CLASS_TYPE_RANGER,oAttacker);
	int iBonus = iRanger / 5;
	
	if(iBonus <= 0) iBonus = 1;
	if(GetIsImprovedRangerFavored(oAttacker,oTarget)) iBonus = iBonus + 3;
	if(GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES,oAttacker)) iBonus = iBonus + d6(2);
	
	return 0;
}

int ApplyFeatsToWeapon(object oPC, object oWeapon)
{
	if(!GetIsObjectValid(oWeapon)) return 0;

	int baseitem = GetBaseItemType(oWeapon);
	int iCount = 0;
	
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATWpnOfChoice", baseitem)),oPC,TRUE)) iCount++;
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATEpicWpnFocus", baseitem)),oPC,TRUE)) return iCount + 4;
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATGrtrWpnFocus", baseitem)),oPC,TRUE)) return iCount + 2;
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATWpnFocus", baseitem)),oPC,TRUE)) return iCount + 1;
		
//	SQLExecDirect("SELECT `label`, `featid` FROM `featids` WHERE label LIKE '%"+SQLEncodeSpecialChars(sWeapon)+"%';");
//	while(SQLFetch())
//	{
//	sLabel = SQLGetData(1);
//	featid = StringToInt(SQLGetData(2));
	
//	if(FindSubString(sLabel, "EPIC_WEAPON_FOCUS") >= 0 && GetHasFeat(featid, oPC)) iCount = 4;
//	if(FindSubString(sLabel, "GREATER_WEAPON_FOCUS") >= 0 && GetHasFeat(featid, oPC) && iCount < 4) iCount = 2;
//	if(FindSubString(sLabel, "WeapFoc") >= 0 && GetHasFeat(featid, oPC) && iCount < 3) iCount = 1;
//	if(FindSubString(sLabel, "WEAPON_FOCUS") >= 0 && GetHasFeat(featid, oPC) && iCount < 3) iCount = 1;
//	if(FindSubString(sLabel, "WEAPON_OF_CHOICE") >= 0 && GetHasFeat(featid, oPC)) iCount = iCount + 1;
//	}

	return iCount;
}

int ApplyDamageFeatsToWeapon(object oPC, object oWeapon)
{
	if(!GetIsObjectValid(oWeapon)) return 0;

//	string sWeapon = Get2DAString("baseitems", "label", GetBaseItemType(oWeapon));
	
//	string sLabel; int featid;
	
	int iCount = 0; int baseitem = GetBaseItemType(oWeapon);
		
//	SQLExecDirect("SELECT `label`, `featid` FROM `featids` WHERE label LIKE '%"+SQLEncodeSpecialChars(sWeapon)+"%';");
//	while(SQLFetch())
//	{
//	sLabel = SQLGetData(1);
//	featid = StringToInt(SQLGetData(2));
	
//	if(FindSubString(sLabel, "EPIC_WEAPON_SPEC") >= 0 && GetHasFeat(featid, oPC)) iCount = 6;
//	if(FindSubString(sLabel, "GREATER_WEAPON_SPEC") >= 0 && GetHasFeat(featid, oPC) && iCount < 4) iCount = 4;
//	if(FindSubString(sLabel, "WEAPON_SPECIALIZATION") >= 0 && GetHasFeat(featid, oPC) && iCount < 3) iCount = 2;
//	if(FindSubString(sLabel, "WEAPON_OF_CHOICE") >= 0 && GetHasFeat(featid, oPC)) iCount = iCount + 1;
//	}
	
	// if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATWpnOfChoice", baseitem)),oPC,TRUE)) iCount++;
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATEpicWpnSpec", baseitem)),oPC,TRUE)) return iCount + 6;
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATGrtrWpnSpec", baseitem)),oPC,TRUE)) return iCount + 4;
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATWpnSpec", baseitem)),oPC,TRUE)) return iCount + 2;
		
	return iCount;
}

int GetWeaponThreatRange(object oPC)
{
	int iMonk = GetLevelByClass(CLASS_TYPE_MONK,oPC);
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	
	if(!GetIsObjectValid(oWeapon) && iMonk > 0) oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS);
	else return 20;
	
	if(!GetIsObjectValid(oWeapon)) return 20;

	int baseitem = GetBaseItemType(oWeapon);
	if(baseitem == BASE_ITEM_GLOVES)
	{
		if(GetHasFeat(62,oPC,TRUE)) return 19;
		else return 20;
	}
	
	string sWeapon = Get2DAString("baseitems", "label", baseitem);
	int ThreatRange = StringToInt(Get2DAString("baseitems", "CritThreat",baseitem));
	
//	SendMessageToPC(oPC,"Initial threat range: "+IntToString(ThreatRange));	
		
	string sLabel; int featid; int iCount;
		
//	SQLExecDirect("SELECT `label`, `featid` FROM `featids` WHERE label LIKE '%"+SQLEncodeSpecialChars(sWeapon)+"%';");
//	while(SQLFetch())
//	{
//	sLabel = SQLGetData(1);
//	featid = StringToInt(SQLGetData(2));
	
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATImprCrit",baseitem)),oPC,TRUE) || GetItemHasItemProperty(oWeapon,ITEM_PROPERTY_KEEN) == TRUE)
	{
		ThreatRange = ThreatRange * 2;
	}
	
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATWpnOfChoice",baseitem)),oPC,TRUE)) ThreatRange = ThreatRange + 2;
//	}
	
	iCount = 21 - ThreatRange;
	
	if(ThreatRange <= 0) iCount = 20;
	else if(ThreatRange >= 12) iCount = 17;
	
//	SendMessageToPC(oPC,"Threat range: "+IntToString(iCount));	
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

effect GetDamageBonusEffects(object oPC)
{
	int iCount; effect eLink;

	effect eEffect = GetFirstEffect(oPC);
	while(GetIsEffectValid(eEffect))
	{
	if(GetEffectType(eEffect) == EFFECT_TYPE_DAMAGE_INCREASE)
	{
//	SendMessageToPC(oPC,"Debug DM Effect 1:"+IntToString(GetEffectInteger(eEffect,0)));
//	SendMessageToPC(oPC,"Debug DM Effect 2:"+IntToString(GetEffectInteger(eEffect,1)));
//	SendMessageToPC(oPC,"Debug DM Effect 3:"+IntToString(GetEffectInteger(eEffect,2)));
			
	if(iCount > 0) eLink = EffectLinkEffects(EffectDamage(GetDamageBonusDie(GetEffectInteger(eEffect,0)),GetEffectInteger(eEffect,1)),eLink);
	else eLink = EffectDamage(GetDamageBonusDie(GetEffectInteger(eEffect,0)),GetEffectInteger(eEffect,1));
	iCount++;
	}
	
	eEffect = GetNextEffect(oPC);
	}
	
	return eLink;
}

effect GetWeaponDamageEnchantments(object oAttacker, object oWeapon)
{
	effect eLink;
	if(!GetIsObjectValid(oWeapon)) return eLink;

	int count; int ab; int enhancement; int sPropSub; int sPropValue; int iCount;

	itemproperty iProp = GetFirstItemProperty(oWeapon);
	while(GetIsItemPropertyValid(iProp))
	{
	if(GetItemPropertyType(iProp) == ITEM_PROPERTY_DAMAGE_BONUS)
	{
	sPropSub = GetItemPropertySubType(iProp); //Element Damage Type
	sPropValue = GetItemPropertyCostTableValue(iProp); //Damage Amt
		
//	SendMessageToPC(oAttacker,"Subtype:"+IntToString(sPropSub));
//	SendMessageToPC(oAttacker,"Subtype Value:"+IntToString(sPropValue));
//	SendMessageToPC(oAttacker,"Damage Bonus Die:"+IntToString(GetDamageBonusDie(sPropValue)));	
//	SendMessageToPC(oAttacker,"Damage Bonus Type:"+IntToString(GetDamageBonusType(sPropSub)));		
	
	if(GetDamageBonusType(sPropSub) > 4)
	{
		if(iCount > 0) eLink = EffectLinkEffects(EffectDamage(GetDamageBonusDie(sPropValue),GetDamageBonusType(sPropSub)),eLink);
		else eLink = EffectDamage(GetDamageBonusDie(sPropValue),GetDamageBonusType(sPropSub));
		iCount++;
	}
		
	}

	iProp = GetNextItemProperty(oWeapon);
	}

	return eLink;	
}

int WeaponMasterCritCheck(object oAttacker, object oWeapon)
{
	if(GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATWpnOfChoice", GetBaseItemType(oWeapon))),oAttacker,TRUE)) return 1;
	
	//string sLabel; int featid;
	
//	int iCount = 0;
		
//	SQLExecDirect("SELECT `featid` FROM `featids` WHERE label LIKE '%FEAT_WEAPON_OF_CHOICE_"+SQLEncodeSpecialChars(sWeapon)+"%';");
//	while(SQLFetch())
//	{
//	featid = StringToInt(SQLGetData(1));
//	if(GetHasFeat(featid, oAttacker)) return 1;
//	}

	return 0;
}

effect GetDamageFeatBonuses(object oPC)
{
	effect eDmg;

	int DEX = ((GetAbilityScore(oPC,ABILITY_DEXTERITY) - 10 ) / 2) / 2;
	int WIS = ((GetAbilityScore(oPC,ABILITY_WISDOM) - 10 ) / 2) / 2;
//	int CHA = ((GetAbilityScore(oPC,ABILITY_CHARISMA) - 10 ) / 2) / 2;
			
	if(DEX > 1 && GetHasFeat(2879,oPC,TRUE)) return EffectDamage(DEX,DAMAGE_TYPE_ACID); //Deadly Precision
	if(WIS > 1 && GetHasFeat(2898,oPC,TRUE)) return EffectDamage(WIS,DAMAGE_TYPE_COLD); //insightful Precision
//	if(WIS > CHA) WIS = CHA;

	if(GetHasFeat(3022, oPC, TRUE))
	{
		int iPerform = GetSkillRank(SKILL_PERFORM,oPC,FALSE);
		int iDmg = FloatToInt(iPerform * 0.15);	
		if(iDmg < 0) iDmg = 1;
		
	    return EffectDamage(iDmg,DAMAGE_TYPE_SONIC); //insightful Precision		
	}
	
//	if(WIS > 1 && GetHasFeat(2894,oPC,TRUE)) return EffectDamage(WIS,DAMAGE_TYPE_POSITIVE); //secrest of harsh master
			
	return eDmg;
}

int GetIsTwoHanding(object oPC)
{
	if(StringToInt(Get2DAString("baseitems", "WeaponSize", GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)))) > 2 
	&& GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC) == OBJECT_INVALID) return TRUE;
	else return FALSE;
}

effect GetWeaponDamageTotal(object oAttacker, object oTarget, object oWeapon, int iCrit, int physicalignore, int sneakattack)
{
	// Damage Roll: Weapon Damage Roll + Strength Modifier + Weapon Enhancement.
	effect eDMG; if(!GetIsObjectValid(oWeapon)) return eDMG;

	//Get stats from attacker/their weapon.
	int iType = GetWeaponType(oWeapon); int nWeaponDmg = GetEnhancementBonus(oAttacker,oWeapon);
	int STR = (GetAbilityScore(oAttacker,ABILITY_STRENGTH) - 10 ) / 2;	
	int INT = (GetAbilityScore(oAttacker,ABILITY_INTELLIGENCE) - 10 ) / 2;	
	
	if(GetHasFeat(1957,oAttacker,TRUE) && INT > STR) STR = INT; //Combat Insight
	
//	SendMessageToPC(oAttacker,"Debug STR:"+IntToString(STR));
//	SendMessageToPC(oAttacker,"Weapon Enhancement:"+IntToString(nWeaponDmg));
	
	//GetWeaponDamage Range
	int iBase = GetBaseItemType(oWeapon); int iRoll;	
	int NumDie = StringToInt(Get2DAString("baseitems", "NumDice", iBase));
	int DieToRoll = StringToInt(Get2DAString("baseitems", "DieToRoll", iBase));
	
	if(DieToRoll == 2) iRoll = d2(NumDie); if(DieToRoll == 4) iRoll = d4(NumDie);
	if(DieToRoll == 6) iRoll = d6(NumDie); if(DieToRoll == 8) iRoll = d8(NumDie);
	if(DieToRoll == 10) iRoll = d10(NumDie); if(DieToRoll == 12) iRoll = d12(NumDie);

//	SendMessageToPC(oAttacker,"Debug Die Roll:"+IntToString(NumDie)+"("+IntToString(DieToRoll)+")");
//	SendMessageToPC(oAttacker,"iRoll:"+IntToString(iRoll));
				
	//Calculate Ranger Favored Enemy/Bane of Enemy	
	if(GetLevelByClass(CLASS_TYPE_RANGER,oAttacker) > 0 && GetIsRangerFavored(oAttacker, oTarget) > 0)
	{
		iRoll = iRoll + CalculateRangerTotal(oAttacker, oTarget);
//		SendMessageToPC(oAttacker,"Ranger Favored: "+IntToString(iRoll));
	}
	
	//powerAttack calculations
	if(GetActionMode(oAttacker, ACTION_MODE_POWER_ATTACK))
	{
		if(GetHasFeat(1459,oAttacker,TRUE)) iRoll = iRoll + 5; //Enhanced Power Attack
		else iRoll = iRoll + 3;
//		SendMessageToPC(oAttacker,"Power Attack:"+IntToString(iRoll));
	}
	
	if(GetActionMode(oAttacker, ACTION_MODE_IMPROVED_POWER_ATTACK))
	{
		if(GetHasFeat(1459,oAttacker,TRUE)) iRoll = iRoll + 10;  //Enhanced Power Attack
		else iRoll = iRoll + 6;
//		SendMessageToPC(oAttacker,"Improved Power Attack:"+IntToString(iRoll));
	}
		
	int iDmgTotal = STR + nWeaponDmg + iRoll + ApplyDamageFeatsToWeapon(oAttacker,oWeapon);
	if(GetHasFeat(2141,oAttacker,TRUE) && INT > STR) iDmgTotal = iDmgTotal + INT; //Insightful Strike Bonus
//	SendMessageToPC(oAttacker,"iDmgTotal: "+IntToString(iDmgTotal));
		
	//SneakAttack
	if(sneakattack == 1) iDmgTotal = iDmgTotal + d6(SneakAttackCount(oAttacker));

	//Crit Boost	
	int iCritBoost = StringToInt(Get2DAString("baseitems", "CritHitMult", iBase));
//	SendMessageToPC(oAttacker,"Crit Boost: "+IntToString(iCritBoost));
			
	int iWeapMaster = GetLevelByClass(33,oAttacker);
	if(iWeapMaster > 0)
	{
		iCritBoost = iCritBoost + WeaponMasterCritCheck(oAttacker,oWeapon);
//		SendMessageToPC(oAttacker,"Weapon Master Boost: "+IntToString(iCritBoost));
	}
	
	if(iCrit == 2) iDmgTotal = iDmgTotal * iCritBoost;
	
	if(iType == 0 || iType == 2) 
	{
		if(physicalignore == 1) eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_BLUDGEONING,TRUE);
		else eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_BLUDGEONING);
//		SendMessageToPC(oAttacker,"Bludgeon Boost: "+IntToString(iDmgTotal));
	}
	
	if(iType == 1) 
	{
		if(physicalignore == 1) eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_PIERCING,TRUE);
		else eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_PIERCING);
//		SendMessageToPC(oAttacker,"Piercing Boost: "+IntToString(iDmgTotal));
	}
	
	if(iType == 3) 
	{
		if(physicalignore == 1) eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_SLASHING,TRUE);
		else eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_SLASHING);
//		SendMessageToPC(oAttacker,"Slashing Boost: "+IntToString(iDmgTotal));
	}
	
	if(iType == 4) 
	{
		if(physicalignore == 1) eDMG = EffectDamage(iDmgTotal, 4,TRUE);
		else eDMG = EffectDamage(iDmgTotal, 4);
//		SendMessageToPC(oAttacker,"Slashing/Piercing Boost: "+IntToString(iDmgTotal));
	}
	
	//Get weapon enchantments.
	eDMG = EffectLinkEffects(GetWeaponDamageEnchantments(oAttacker,oWeapon), eDMG);
	
	//Get any dmg buffs
	eDMG = EffectLinkEffects(GetDamageBonusEffects(oAttacker), eDMG);	

	//Get any dmg feats
//	eDMG = EffectLinkEffects(GetDamageFeatBonuses(oAttacker), eDMG);	
		
	return eDMG;
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
	
	if(GetActionMode(oAttacker,ACTION_MODE_POWER_ATTACK)) iPen = iPen + 3;
	if(GetActionMode(oAttacker,ACTION_MODE_IMPROVED_POWER_ATTACK)) iPen = iPen + 6;

	if(GetActionMode(oAttacker,ACTION_MODE_COMBAT_EXPERTISE)) iPen = iPen + 3;
	if(GetActionMode(oAttacker,ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)) iPen = iPen + 6;
				
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

int AttemptMeleeAttackMainHand(object oAttacker, object oTarget, string abilityname, int givefeedback, string animation, int ranged, int nSpellID)
{
	//0 - miss, 1 - hit, 2 - critical
	// Melee Attack: 1d20 + base attack bonus + strength modifier + size modifier vs their AC.
	// Damage Roll: Weapon Damage Roll + Strength Modifier + Weapon Enhancement.

	int featid;
	
	if(GetDistanceBetween(oAttacker,oTarget) >= 4.0 && ranged == 0)
	{
		SendMessageToPC(oAttacker,"Your target is too far away!");
		if(givefeedback == 1)
		{
			FloatingTextStringOnCreature("*"+abilityname+" (miss - target too far)*", oAttacker, TRUE, 3.0f);
			featid = StringToInt(Get2DAString("spells", "FeatID", nSpellID));
			DelayCommand(1.5f,ResetFeatUses(oAttacker,featid,TRUE,TRUE));
			DelayCommand(0.2f,	AssignCommand(oAttacker, ActionAttack(oTarget)));
		}
		return 0;
	}
	
	if(givefeedback == 1 && nSpellID > 0)
	{
	int iTime = GetLocalInt(oAttacker,"GCDOWN"); int uTime = GetRealTime();
	{	
		if (iTime + 3 > uTime && givefeedback == 1)
		{
		int result = (iTime + 3)-uTime;
		FloatingTextStringOnCreature("*You must wait "+IntToString(result)+" seconds between ability activations*", oAttacker, TRUE, 3.0f);
		featid = StringToInt(Get2DAString("spells", "FeatID", nSpellID));
		
//		SendMessageToPC(oAttacker,"FeatID: "+IntToString(featid));
	
		DelayCommand(IntToFloat(result),ResetFeatUses(oAttacker,featid,TRUE,TRUE));
		return 0;
		}
	}
	SetLocalInt(oAttacker,"GCDOWN",GetRealTime());
	}
	
	int conceal = ConcealmentCheck(oTarget); int imiss;
	
	if(conceal > 0 && conceal > d100())
	{
	imiss = 1;	
	
		if(GetHasFeat(408, oAttacker,TRUE))
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
	
	if(InvisibilityCheck(oTarget) == 1)
	{
		if(!GetHasSpell(186,oAttacker) && !GetItemHasItemProperty(GetItemInSlot(INVENTORY_SLOT_HEAD,oAttacker),ITEM_PROPERTY_TRUE_SEEING))
		{
			if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (miss - invisibility)*", oAttacker, TRUE, 3.0f);
			SendMessageToPC(oAttacker,"You missed! (invisibility failure)");
			return 0;
		}
	}
				
	int roll = d20();
	int TargetAC = GetAC(oTarget);
	if(FlatFooted(oAttacker, oTarget)) TargetAC = TargetAC - GetDodgeAC(oTarget);
	
	int iAttackerAB = AttackerTotalAB(oAttacker);
	if(GetLevelByClass(CLASS_TYPE_RANGER,oAttacker) > 0 && GetIsRangerFavored(oAttacker, oTarget) > 0)
	{
		iAttackerAB = iAttackerAB + CalculateRangerBonus(oAttacker);
	}
	
	int iAttack = roll + iAttackerAB;
	
	if(roll == 20 || iAttack >= TargetAC && roll > 1)
	{
		SendMessageToPC(oAttacker,"You hit! " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
		int ThreatRange = GetWeaponThreatRange(oAttacker);
	
		if(animation != "")
		{
			PS_CustomAnimation(oAttacker,animation,0);
			BattleCry(oAttacker);
			if(ranged == 0) DelayCommand(0.2f,	AssignCommand(oAttacker, ActionAttack(oTarget)));
		}
	
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
	
	if(givefeedback == 1 && roll == 1)
	{
	FloatingTextStringOnCreature(abilityname+" (miss - rolled 1)*", oAttacker, TRUE, 3.0f);
	SendMessageToPC(oAttacker,"You missed! (Rolled 1) "+IntToString(iAttack)+" vs "+IntToString(TargetAC));
	return 0;
	}
	
	if(givefeedback == 1) FloatingTextStringOnCreature(abilityname+" (miss)*", oAttacker, TRUE, 3.0f);
	SendMessageToPC(oAttacker,"You missed! "+IntToString(iAttack)+" vs "+IntToString(TargetAC));
	
	return 0;
}

void AttemptTauntAroundPlayer(object oPC, int iMax)
{
	int iHit; int iLoop;
	
	object oTargetSphere = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);	
	while( GetIsObjectValid(oTargetSphere) && iMax > iLoop)
    {
 		if (spellsIsTarget(oTargetSphere, SPELL_TARGET_STANDARDHOSTILE, oPC) && 
		GetStealthMode(oTargetSphere) == STEALTH_MODE_DISABLED && 
		GetAttackTarget(oTargetSphere) != oPC && 
		GetIsInCombat(oTargetSphere))
    {
	iHit = TouchAttackRanged(oTargetSphere,TRUE);

	if(iHit > 0)
	{
		SendMessageToPC(oPC,"Taunt hit "+GetName(oTargetSphere)+"!");
		AssignCommand(oTargetSphere, ClearAllActions(FALSE));
		DelayCommand(0.5f,AssignCommand(oTargetSphere, ActionAttack(oPC)));	
		iLoop++;
	}
	}
		oTargetSphere = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);	
	}
}