// Script created by comeandsee 11/1/2016
// Converted for SCoD by Ceremorph 11/6/2016
// Note: A complete list of animations for use in this script can be found at
// nwn2.wikia.com/wiki/PlayCustomAnimation:_List_of_animations

// Nov 27, 2024. FlattedFifth - Shield Bash wasn't working on some large targets. It was saying I wasn't 
// close enough even though I was as close as possible. This is because GetDistanceBetween()
// measures from centre of footprint to centre of footprint. I made a better function
// in ps_inc_functions that takes size into account and call it from AttemptMeleeAttackMainHand()



#include "nwnx_sql"
#include "X0_I0_SPELLS"
#include "ps_inc_time"
#include "ps_inc_advscript"
#include "ps_inc_functions"
#include "nwnx_dae"

int GetEnhancementBonus(object oPC, object oWeapon);

int Ceil(float numb)
{
    int cast = FloatToInt(numb);
    return numb > 0.0 ? ((numb - cast) > 0.0 ? cast + 1 : cast) : ((numb - cast) > 0.0 ? cast - 1 : cast);
}

int PS_IsPCStealthed(object oPC, object oTarget)
{
	if (!GetObjectSeen(oTarget, oPC))
	{	return TRUE;	}
	else
	{	return FALSE;	}
}

// Determines if the target is in a position to be flanked by the caller.
int PS_IsTargetFlanked(object oPC, object oTarget)
{
	

	vector vPC 				= GetPosition(oPC);
	vector vTarget 			= GetPosition(oTarget);
	vector vPCtoTarget 		= vPC - vTarget;
	float fAngleOfVector 	= VectorToAngle(vPCtoTarget);
	float fTargetFacing 	= GetFacing(oTarget);
	float fAngleToPC 		= fAngleOfVector - fTargetFacing;
//	SendMessageToPC(oPC, "<COLOR=RED>DEBUG: You are " + FloatToString(fAngleToPC, 18, 1) + " degrees from target facing");
					
	if (fAngleToPC < 280.0 && fAngleToPC > 80.0 || fAngleToPC >= -280.0 && fAngleToPC < -80.0)
	{
//		SendMessageToPC(oPC, "<COLOR=RED>Target is attacked from flank");	
		return TRUE;	
	}
	else
	{	return FALSE;	}
}

// Determines if the target is within range of the ability's range; fRange is expressed in meters
int PS_IsTargetWithinRange(object oPC, object oTarget, float fRange = 5.0f)
{
	if(PS_IsPCStealthed(oPC,oTarget)) fRange = 6.0f;

	if (GetDistanceToObject(oTarget) <= fRange)	
	{	return TRUE;	}
	else
	{	return FALSE;	}
}

// Determines if the target has immunity to sneak attack
int PS_IsTargetSneakImmune(object oTarget)
{	
	if (GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK) || GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{ 	return TRUE;	}
	else
	{	return FALSE;	}
}

// Determines if the target is under an effect or condition which would make it sneakable
int PS_IsTargetFlatFooted(object oPC, object oTarget)
{
	effect eEffect = GetFirstEffect(oTarget);
	int iEffectType;
	
	if (GetHasFeatEffect(FEAT_KNOCKDOWN, oTarget) || 
		GetHasFeatEffect(FEAT_IMPROVED_KNOCKDOWN, oTarget) ||
		GetHasFeatEffect(FEAT_FEINT, oTarget) ||
		GetHasFeatEffect(1510, oTarget)	||						// Impromptu Sneak Attack 1
		GetHasFeatEffect(1511, oTarget) ||						// Impromptu Sneak Attack 2
		GetHasSpellEffect(SPELL_I_BESHADOWED_BLAST, oTarget))
	{	return TRUE;	}
	if (GetHasEffect(EFFECT_TYPE_STUNNED, oTarget) ||
		GetHasEffect(EFFECT_TYPE_SLEEP, oTarget) ||
		GetHasEffect(EFFECT_TYPE_PARALYZE, oTarget) ||
		GetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget) ||
		GetHasEffect(EFFECT_TYPE_NWN2_DEX_ACMOD_DISABLE, oTarget))
	{	return TRUE;	}

		return FALSE;
}

// Determines if the caller has Epic Precision; if so, sneak damage will be halved
int PS_HasEpicPrecision(object oPC)
{	
	if (GetHasFeat(2128, oPC, TRUE))
	{	return TRUE;	}
	else
	{	return FALSE;	}
}

// Determines if the caller has the appropriate Ruin feat to bypass sneak/critical immunity
int PS_HasRuinFeat(object oPC, object oTarget)
{
	int nRace 	= GetRacialType(oTarget);
	if (nRace == RACIAL_TYPE_UNDEAD && GetHasFeat(2129, oPC, TRUE))				//Undead
	{	return TRUE;	}
	else if (nRace == RACIAL_TYPE_ELEMENTAL && GetHasFeat(2130, oPC, TRUE))		//Elemental
	{	return TRUE;	}
	else if (nRace == 22 && GetHasFeat(2131, oPC, TRUE))						// Plant
	{	return TRUE;	}
	else if (nRace == RACIAL_TYPE_INCORPOREAL && GetHasFeat(2132, oPC, TRUE))	// Spirit
	{	return TRUE;	}
	else if (nRace == RACIAL_TYPE_CONSTRUCT && GetHasFeat(2133, oPC, TRUE))		// Construct
	{	return TRUE;	}
	else
	{	return FALSE;	}
}

// The final determination: can the PC sneak attack this target?
int PS_CanSneak(object oPC, object oTarget, float fRange)
{
	if (PS_IsTargetWithinRange(oPC, oTarget, fRange))
	{	
		int iSneakImmune = PS_IsTargetSneakImmune(oTarget);
	
		if (!iSneakImmune)
		{	if (PS_IsTargetFlanked(oPC, oTarget))
			{	return TRUE;	}
			if (PS_IsTargetFlatFooted(oPC, oTarget))
			{	return TRUE;	}
			if (PS_IsPCStealthed(oPC, oTarget))
			{	return TRUE;	}
		}
		
		if (iSneakImmune && PS_HasEpicPrecision(oPC))
		{	if (PS_IsTargetFlanked(oPC, oTarget))
			{	return TRUE;	}
			if (PS_IsTargetFlatFooted(oPC, oTarget))
			{	return TRUE;	}
			if (PS_IsPCStealthed(oPC, oTarget))
			{	return TRUE;	}
		}
		
		if (iSneakImmune && PS_HasRuinFeat(oPC, oTarget))
		{	if (PS_IsTargetFlanked(oPC, oTarget))
			{	return TRUE;	}
			if (PS_IsTargetFlatFooted(oPC, oTarget))
			{	return TRUE;	}
			if (PS_IsPCStealthed(oPC, oTarget))
			{	return TRUE;	}
		}
	}
	
	return FALSE;
}


int GetDamageBonusInt(int nBonus)
{
	if(nBonus <= 5) return nBonus;
	if(nBonus >= 6) return 10 + nBonus;
	
	return nBonus;
}

int GetDieAverage(int die, int dieToRoll)
{
	if(die > 1) return Ceil((dieToRoll / 2.0) * die) + die - 1;
	else return Ceil((dieToRoll / 2.0) * die);
}

int ConstToDmg(int iConst)
{
	//Use IP_CONST_DAMAGEBONUS
	int NumDice = StringToInt(Get2DAString("iprp_damagecost","NumDice",iConst));
	int NumDie = StringToInt(Get2DAString("iprp_damagecost","Die",iConst));
	
	if(NumDice == 0) return NumDie; //Flat Amounts
	else return GetDieAverage(NumDice,NumDie);
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

int GetAttackBonusTotal(object oPC, object oWeapon)
{
/*
	All of this is deprecated, Dae does it better.
	
	int AB = GetTRUEBaseAttackBonus(oPC);
	int STR = GetAbilityModifier(ABILITY_STRENGTH,oPC);
	int DEX = GetAbilityModifier(ABILITY_DEXTERITY,oPC);
	int WIS = GetAbilityModifier(ABILITY_WISDOM,oPC);
	
	if (GetWeaponRanged(oWeapon) && GetHasFeat(FEAT_ZEN_ARCHERY, oPC, TRUE) && WIS > DEX) AB += GetAbilityModifier(ABILITY_WISDOM,oPC);
	else if (GetWeaponRanged(oWeapon)) AB += DEX;
	else if(GetHasFeat(FEAT_WEAPON_FINESSE, oPC) && DEX > STR) AB += DEX;  //Weapon Finesse
	else AB += STR;
	
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
	
	if(GetHasFeat(584,oPC)) AB++; //Epic Prowess	
	return AB + count;
	*/
	return GetBaseAttackBonus(oPC) + dae_GetOnHandAttackModifier(oPC);
}

void RemoveMirrorImage(object oPC)
{
	effect eEffect = GetFirstEffect( oPC );
	int iType;
	while ( GetIsEffectValid(eEffect) )
	{
		iType = GetEffectType(eEffect);
	
		if ( iType == EFFECT_TYPE_ABSORBDAMAGE)
		{
			RemoveEffect( oPC, eEffect ); return;
		}
			eEffect = GetNextEffect( oPC );
	}
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

int ConcealmentCheck(object oTarget, int ranged)
{
	int conceal; int IntAmt; int iConceal;
	
	effect eConceal = GetFirstEffect(oTarget);
	
	if(ranged == 1)
	{
		while(GetIsEffectValid(eConceal))
		{
		if(GetEffectType(eConceal) == EFFECT_TYPE_CONCEALMENT)
		{
			IntAmt = GetEffectInteger(eConceal,0);
			if (IntAmt > conceal) conceal = IntAmt;
		}
		eConceal = GetNextEffect(oTarget);
		}
	}
	else 
	{
		while(GetIsEffectValid(eConceal))
		{
		if(GetEffectType(eConceal) == EFFECT_TYPE_CONCEALMENT && GetEffectSpellId(eConceal) != 1007)
		{
			IntAmt = GetEffectInteger(eConceal,0);
			if (IntAmt > conceal) conceal = IntAmt;
		}
		eConceal = GetNextEffect(oTarget);
		}
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

string GetRacialTypeName(object oTarget)
{
	int iRacial = GetRacialType(oTarget);

	if(iRacial == RACIAL_TYPE_ANIMAL) return "Animals";
	else if(iRacial == RACIAL_TYPE_ABERRATION) return "Aberrations";
	else if(iRacial == RACIAL_TYPE_BEAST) return "Beasts";
	else if(iRacial == RACIAL_TYPE_CONSTRUCT) return "Constructs";
	else if(iRacial == RACIAL_TYPE_DRAGON) return "Dragons";
	else if(iRacial == RACIAL_TYPE_DWARF) return "Dwarfs"; 
	else if(iRacial == RACIAL_TYPE_ELEMENTAL) return "Elementals";
	else if(iRacial == RACIAL_TYPE_ELF) return "Elves"; 
	else if(iRacial == RACIAL_TYPE_GIANT) return "Giants";
	else if(iRacial == RACIAL_TYPE_GNOME) return "Gnomes";
	else if(iRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) return "Goblinoids";
	else if(iRacial == RACIAL_TYPE_HALFELF) return "Half-Elves";
	else if(iRacial == RACIAL_TYPE_HALFORC) return "Half-Orcs";
	else if(iRacial == RACIAL_TYPE_HALFLING) return "Halflings";
	else if(iRacial == RACIAL_TYPE_HUMAN) return "Humans";
	else if(iRacial == RACIAL_TYPE_MAGICAL_BEAST) return "Magical Beasts";
	else if(iRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) return "Monstrous Humanoids";
	else if(iRacial == RACIAL_TYPE_GRAYORC || iRacial == IP_CONST_RACIALTYPE_HUMANOID_ORC) return "Orcs";
	else if(iRacial == RACIAL_TYPE_OUTSIDER) return "Outsiders";
	else if(iRacial == RACIAL_TYPE_HUMANOID_REPTILIAN) return "Reptilian Humanoids";
	else if(iRacial == RACIAL_TYPE_SHAPECHANGER) return "Shapechangers";	
	else if(iRacial == RACIAL_TYPE_UNDEAD) return "Undead";
	else if(iRacial == RACIAL_TYPE_VERMIN) return "Vermin";	
	else if(iRacial == RACIAL_TYPE_FEY) return "Fey";			
 	else return "Invalid Race";
}

int GetRacialTypeConst(object oTarget)
{
	int iRacial = GetRacialType(oTarget);

	if(iRacial == RACIAL_TYPE_ANIMAL) return IP_CONST_RACIALTYPE_ANIMAL;
	else if(iRacial == RACIAL_TYPE_ABERRATION) return IP_CONST_RACIALTYPE_ABERRATION;
	else if(iRacial == RACIAL_TYPE_BEAST) return IP_CONST_RACIALTYPE_BEAST;
	else if(iRacial == RACIAL_TYPE_CONSTRUCT) return IP_CONST_RACIALTYPE_CONSTRUCT;
	else if(iRacial == RACIAL_TYPE_DRAGON) return IP_CONST_RACIALTYPE_DRAGON;
	else if(iRacial == RACIAL_TYPE_DWARF) return IP_CONST_RACIALTYPE_DWARF; 
	else if(iRacial == RACIAL_TYPE_ELEMENTAL) return IP_CONST_RACIALTYPE_ELEMENTAL;
	else if(iRacial == RACIAL_TYPE_ELF) return IP_CONST_RACIALTYPE_ELF; 
	else if(iRacial == RACIAL_TYPE_GIANT) return IP_CONST_RACIALTYPE_GIANT;
	else if(iRacial == RACIAL_TYPE_GNOME) return IP_CONST_RACIALTYPE_GNOME;
	else if(iRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) return IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID;
	else if(iRacial == RACIAL_TYPE_HALFELF) return IP_CONST_RACIALTYPE_HALFELF;
	else if(iRacial == RACIAL_TYPE_HALFORC) return IP_CONST_RACIALTYPE_HALFORC;
	else if(iRacial == RACIAL_TYPE_HALFLING) return IP_CONST_RACIALTYPE_HALFLING;
	else if(iRacial == RACIAL_TYPE_HUMAN) return IP_CONST_RACIALTYPE_HUMAN;
	else if(iRacial == RACIAL_TYPE_MAGICAL_BEAST) return IP_CONST_RACIALTYPE_MAGICAL_BEAST;
	else if(iRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) return IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS;
	else if(iRacial == RACIAL_TYPE_GRAYORC || iRacial == IP_CONST_RACIALTYPE_HUMANOID_ORC) return IP_CONST_RACIALTYPE_HUMANOID_ORC;
	else if(iRacial == RACIAL_TYPE_OUTSIDER) return IP_CONST_RACIALTYPE_OUTSIDER;
	else if(iRacial == RACIAL_TYPE_HUMANOID_REPTILIAN) return IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN;
	else if(iRacial == RACIAL_TYPE_SHAPECHANGER) return IP_CONST_RACIALTYPE_SHAPECHANGER;	
	else if(iRacial == RACIAL_TYPE_UNDEAD) return IP_CONST_RACIALTYPE_UNDEAD;
	else if(iRacial == RACIAL_TYPE_VERMIN) return IP_CONST_RACIALTYPE_VERMIN;	
	else if(iRacial == RACIAL_TYPE_FEY) return IP_CONST_RACIALTYPE_FEY;			
 	else return 0;
}

int GetHasIgnoreCritImmunity(object oPC, object oTarget)
{
	if(GetHasFeat(StringToInt(Get2DAString("racialtypes","FEATIgnoreCritImmunity",GetRacialType(oTarget))),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetIsImprovedRangerFavored(object oPC, object oTarget)
{
	int iRacial = GetRacialType(oTarget);

	if(GetHasFeat(StringToInt(Get2DAString("racialtypes","FEATImprovedFavoredEnemy",GetRacialType(oTarget))),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetIsRangerFavored(object oPC, object oTarget)
{
	if(GetHasFeat(StringToInt(Get2DAString("racialtypes","FEATFavoredEnemy",GetRacialType(oTarget))),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetIsRangerFavoredPowerAttack(object oPC, object oTarget)
{
	if(GetHasFeat(StringToInt(Get2DAString("racialtypes","FEATFavoredPowerAttack",GetRacialType(oTarget))),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int CalculateRangerBonus(object oPC)
{	
	if(GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES,oPC)) return 2;
	return 0;
}

int CalculateRangerTotal(object oAttacker,object oTarget)
{	
	int iRanger = GetLevelByClass(CLASS_TYPE_RANGER,oAttacker);
	int iBonus = iRanger / 5;
	
	if(iBonus <= 0) iBonus = 1;
	if(GetIsImprovedRangerFavored(oAttacker,oTarget)) iBonus = iBonus + 3;
	if(GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES,oAttacker)) iBonus = iBonus + d6(2);
	
	return iBonus;
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
	
	if (GetWeaponRanged(oWeapon)) enhancement += (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) + 1) / 2;
	
	return enhancement;	
}

int GetACBonus(object oArmor)
{
	if(!GetIsObjectValid(oArmor)) return 0;

	int ac;

	itemproperty iProp = GetFirstItemProperty(oArmor);
	while(GetIsItemPropertyValid(iProp))
	{
		if(GetItemPropertyType(iProp) == ITEM_PROPERTY_AC_BONUS) ac = GetItemPropertyCostTableValue(iProp);
		iProp = GetNextItemProperty(oArmor);
	}

	return ac;	
}

int GetEnhancedArrowBonus(object oPC)
{
	if(GetHasFeat(449,oPC,TRUE)) return 5;
	else if(GetHasFeat(448,oPC,TRUE)) return 4;
	else if(GetHasFeat(447,oPC,TRUE)) return 3;
	else if(GetHasFeat(446,oPC,TRUE)) return 2;
	else if(GetHasFeat(445,oPC,TRUE)) return 1;
	else return 0;	
}

int GetMightyBonus(object oPC, object oWeapon)
{
	if(!GetIsObjectValid(oWeapon)) return 0;

	int mighty, iCount; int STR; int iBonus = 0;
	
	itemproperty iProp = GetFirstItemProperty(oWeapon);
	while(GetIsItemPropertyValid(iProp))
	{
		if(GetItemPropertyType(iProp) == ITEM_PROPERTY_MIGHTY) iCount = GetItemPropertyCostTableValue(iProp);
		if(iCount > mighty) mighty = iCount;
		
		iProp = GetNextItemProperty(oWeapon);
	}
	
	if(mighty > 0)
	{
		STR = GetAbilityModifier(ABILITY_STRENGTH,oPC);
		if(STR > mighty) iBonus = mighty;	
	}

	return iBonus;	
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
	if(DEX <= 0) DEX = 0;
	
	return iAC + DEX;
}


int FlatFooted(object oAttacker, object oTarget)
{
	return PS_CanSneak(oAttacker,oTarget,3.75f);
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

effect GetArrowEnchantments(object oAttacker)
{
	effect eLink;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_ARROWS,oAttacker);
	if(!GetIsObjectValid(oWeapon)) oWeapon = GetItemInSlot(INVENTORY_SLOT_BOLTS,oAttacker);
	if(!GetIsObjectValid(oWeapon)) oWeapon = GetItemInSlot(INVENTORY_SLOT_BULLETS,oAttacker);
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
//	SendMessageToPC(oAttacker,"Damage Bonus Die:"+IntToString(ConstToDmg(sPropValue)));	
//	SendMessageToPC(oAttacker,"Damage Bonus Type:"+IntToString(GetDamageBonusType(sPropSub)));		
	
			if(GetDamageBonusType(sPropSub) > 4)
			{
				if(iCount > 0) eLink = EffectLinkEffects(EffectDamage(ConstToDmg(sPropValue),GetDamageBonusType(sPropSub)),eLink);
				else eLink = EffectDamage(ConstToDmg(sPropValue),GetDamageBonusType(sPropSub));
				iCount++;
			}	
		}

		iProp = GetNextItemProperty(oWeapon);
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
	effect eDMG; 
	if(!GetIsObjectValid(oWeapon)) return eDMG;
	
	int iBonus;

	//Get stats from attacker/their weapon.
	int iType = GetWeaponType(oWeapon); 
	
	int nWeaponDmg = GetEnhancementBonus(oAttacker,oWeapon);
	
	int STR = GetAbilityModifier(ABILITY_STRENGTH,oAttacker);	
	int INT = GetAbilityModifier(ABILITY_INTELLIGENCE,oAttacker);	
	
	int IsTwoHanding = GetIsTwoHanding(oAttacker);
	//if(IsTwoHanding == 1) STR = (STR * 3) / 2;	
	
	if(GetHasFeat(1957,oAttacker,TRUE) && INT > STR) STR = INT; //Combat Insight
		
//	SendMessageToPC(oAttacker,"Debug STR:"+IntToString(STR));
//	SendMessageToPC(oAttacker,"Weapon Enhancement:"+IntToString(nWeaponDmg));
	
	//GetWeaponDamage Range
	int iBase = GetBaseItemType(oWeapon); int iRoll, NumDie, DieToRoll;
	
	if(iBase == BASE_ITEM_GLOVES)
	{
		int iMonk = MonkLevels(oAttacker);
		if(iMonk > 0)
		{
			if(GetHasFeat(2562, oAttacker, TRUE) || GetHasFeat(5280, oAttacker, TRUE)) iRoll = IncreasedUnarmedDamageBonus(oAttacker,oWeapon);
			else iRoll = MonkUnarmedDamage(oAttacker,iMonk);
		}
		else iRoll = 0;	
	}
	else
	{
		NumDie = StringToInt(Get2DAString("baseitems", "NumDice", iBase));
		DieToRoll = StringToInt(Get2DAString("baseitems", "DieToRoll", iBase));
		iRoll = GetDieAverage(NumDie,DieToRoll);
	}
			
//	SendMessageToPC(oAttacker,"Debug Die Roll: "+IntToString(NumDie)+"("+IntToString(DieToRoll)+")");
//	SendMessageToPC(oAttacker,"iRoll: "+IntToString(iRoll));
				
	//Calculate Ranger Favored Enemy/Bane of Enemy	
	if(GetLevelByClass(CLASS_TYPE_RANGER,oAttacker) > 0 && GetIsRangerFavored(oAttacker, oTarget))
	{
		iRoll = iRoll + CalculateRangerTotal(oAttacker, oTarget);
//		SendMessageToPC(oAttacker,"Ranger Favored: "+IntToString(iRoll));
	}
	
	if(GetActionMode(oAttacker, ACTION_MODE_IMPROVED_POWER_ATTACK))
	{
		if(GetHasFeat(FEAT_SUPREME_POWER_ATTACK, oAttacker,TRUE)) iBonus = 12;
		else if(GetHasFeat(FEAT_IMPROVED_POWER_ATTACK, oAttacker,TRUE)) iBonus = 10;
		else iBonus = 6;
		
		if(GetIsRangerFavoredPowerAttack(oAttacker,oTarget)) iBonus += iBonus;		
				
		if (IsTwoHanding == 1) iBonus += iBonus;
		
		iRoll += iBonus;
//		SendMessageToPC(oAttacker,"Improved Power Attack:"+IntToString(iRoll));
	}	
	//powerAttack calculations
	else if(GetActionMode(oAttacker, ACTION_MODE_POWER_ATTACK))
	{
		if(GetHasFeat(FEAT_SUPREME_POWER_ATTACK, oAttacker,TRUE)) iBonus = 6;
		else if(GetHasFeat(FEAT_IMPROVED_POWER_ATTACK, oAttacker,TRUE)) iBonus = 5;
		else iBonus = 3;

		if(GetIsRangerFavoredPowerAttack(oAttacker,oTarget)) iBonus += iBonus;
				
		if (IsTwoHanding == 1) iBonus += iBonus;
		
		iRoll += iBonus;
//		SendMessageToPC(oAttacker,"Power Attack:"+IntToString(iRoll));
	}
	
	int iDmgTotal = STR + nWeaponDmg + iRoll + ApplyDamageFeatsToWeapon(oAttacker,oWeapon);
	if(GetHasFeat(2141,oAttacker,TRUE) && INT > STR) iDmgTotal = iDmgTotal + INT; //Insightful Strike Bonus
//	SendMessageToPC(oAttacker,"iDmgTotal: "+IntToString(iDmgTotal));
		
	//SneakAttack
	if(sneakattack == 1) iDmgTotal = iDmgTotal + d6(SneakAttackCount(oAttacker));
//	SendMessageToPC(oAttacker,"iDmgTotal 1: "+IntToString(iDmgTotal));

	//Crit Boost	
	int iCritBoost = StringToInt(Get2DAString("baseitems", "CritHitMult", iBase));
	if(iCritBoost < 2) iCritBoost = 2;
//	SendMessageToPC(oAttacker,"Crit Boost: "+IntToString(iCritBoost));
			
	iCritBoost = iCritBoost + WeaponMasterCritCheck(oAttacker,oWeapon);
//		SendMessageToPC(oAttacker,"Weapon Master Boost: "+IntToString(iCritBoost));
	
	if(iCrit == 2) iDmgTotal = iDmgTotal * iCritBoost;
//	SendMessageToPC(oAttacker,"iDmgTotal 2: "+IntToString(iDmgTotal));	

	//Mighty Check
	if(GetWeaponRanged(oWeapon)) iDmgTotal = iDmgTotal + GetMightyBonus(oAttacker, oWeapon);
//	SendMessageToPC(oAttacker,"iDmgTotal 3: "+IntToString(iDmgTotal));	

	if(iType == 1) 
	{
		if(physicalignore == 1) eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_PIERCING,TRUE);
		else eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_PIERCING);
//		SendMessageToPC(oAttacker,"Piercing Boost: "+IntToString(iDmgTotal));
	}
	else if(iType == 3) 
	{
		if(physicalignore == 1) eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_SLASHING,TRUE);
		else eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_SLASHING);
//		SendMessageToPC(oAttacker,"Slashing Boost: "+IntToString(iDmgTotal));
	}	
	else if(iType == 4) 
	{
		if(physicalignore == 1) eDMG = EffectDamage(iDmgTotal, 4, TRUE);
		else eDMG = EffectDamage(iDmgTotal, 4);
//		SendMessageToPC(oAttacker,"Slashing/Piercing Boost: "+IntToString(iDmgTotal));
	}
	else
	{
		if(physicalignore == 1) eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_BLUDGEONING,TRUE);
		else eDMG = EffectDamage(iDmgTotal, DAMAGE_TYPE_BLUDGEONING);
//		SendMessageToPC(oAttacker,"Bludgeon Boost: "+IntToString(iDmgTotal));
	}
		
	//Get weapon enchantments.
	eDMG = EffectLinkEffects(GetWeaponDamageEnchantments(oAttacker,oWeapon), eDMG);
	
	//Get arrow effects (ranged only)
	if(GetWeaponRanged(oWeapon)) eDMG = EffectLinkEffects(GetArrowEnchantments(oAttacker), eDMG);
	
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
		if ((GetBaseItemType(oLeftWeapon) == BASE_ITEM_TOWERSHIELD) && GetHasFeat(3060,oAttacker)) iPen = 0;
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
	return (GetAttackBonusTotal(oAttacker, oWeapon) + ApplyFeatsToWeapon(oAttacker, oWeapon) + GetWeaponBonuses(oAttacker, oWeapon) + CreatureSize(oAttacker)) - AttackerABPenalties(oAttacker, oWeapon);
}

int AttackerTotalABCreature(object oAttacker)
{
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
	if(oWeapon == OBJECT_INVALID) oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oAttacker);
	return (GetAttackBonusTotal(oAttacker, oWeapon) + ApplyFeatsToWeapon(oAttacker, oWeapon) + GetWeaponBonuses(oAttacker, oWeapon) + CreatureSize(oAttacker)) - AttackerABPenalties(oAttacker, oWeapon);
}

// 0 = miss, 1 = hit, 2 = crit
int AttemptMeleeAttackMainHand(object oAttacker, object oTarget, string abilityname, int givefeedback, string animation, int ranged, int nSpellID){
	//0 - miss, 1 - hit, 2 - critical
	// Melee Attack: 1d20 + base attack bonus + strength modifier + size modifier vs their AC.
	// Damage Roll: Weapon Damage Roll + Strength Modifier + Weapon Enhancement.

	int nFeatId = StringToInt(Get2DAString("spells", "FeatID", nSpellID));
	
	int nBash = (nSpellID == SPELLFEAT_SHIELDBASH || nSpellID == SPELLFEAT_AGILE_SHIELDSTRIKE);
	int nThrow = (nSpellID == SPELLFEAT_SHIELDTHROW || nSpellID == SPELLFEAT_ARCANEBASH);
	
	if (!PS_GetTargetInRange(oAttacker, oTarget, nFeatId, TRUE, nBash, nThrow)){
		if (givefeedback == 1)
			FloatingTextStringOnCreature("*"+abilityname+" (miss - target too far)*", oAttacker, TRUE, 3.0f);
		int nFeatid = StringToInt(Get2DAString("spells", "FeatID", nSpellID));
		DelayCommand(1.5f,ResetFeatUses(oAttacker,nFeatid,TRUE,TRUE));
		AssignCommand(oAttacker, ClearAllActions(FALSE));
		DelayCommand(0.2f,	AssignCommand(oAttacker, ActionAttack(oTarget)));
		return 0;
	}

	int imiss;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oAttacker);
	
	int conceal = ConcealmentCheck(oTarget,ranged);
	
	if(conceal > 0 && conceal > d100() + 1){
		imiss = 1;	
		if(GetHasFeat(408, oAttacker,TRUE))
		{
			if(conceal > d100()) imiss = 1;
			else imiss = 0;
		}
	}
	
	if(imiss == 1)
	{
		if(givefeedback == 1)
			FloatingTextStringOnCreature("*"+abilityname+" (miss - concealment)*", oAttacker, TRUE, 3.0f);
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
		if(!GetHasSpellEffect(186,oAttacker) && !GetHasSpellEffect(943, oAttacker) && 
		!GetHasSpellEffect(849, oAttacker) &&
		!GetItemHasItemProperty(GetItemInSlot(INVENTORY_SLOT_HEAD,oAttacker),ITEM_PROPERTY_TRUE_SEEING))
		{
			if(givefeedback == 1)
				FloatingTextStringOnCreature("*"+abilityname+" (miss - invisibility)*", oAttacker, TRUE, 3.0f);
			SendMessageToPC(oAttacker,"You missed! (invisibility failure)");
			return 0;
		}
	}
	
	if(GetHasSpellEffect(852,oTarget))
	{
		if(givefeedback == 1)
			FloatingTextStringOnCreature("*"+abilityname+" (miss - mirror image)*", oAttacker, TRUE, 3.0f);
		SendMessageToPC(oAttacker,"You missed! (mirror image)");
		AssignCommand(oAttacker, ClearAllActions(FALSE));		
		DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
		RemoveMirrorImage(oTarget);
		return 0;	
	}
	
	if(GetHasFeat(856,oTarget,TRUE) && d6() == 1)
	{
		if(givefeedback == 1)
			FloatingTextStringOnCreature("*"+abilityname+" (miss - epic dodge)*", oAttacker, TRUE, 3.0f);
		SendMessageToPC(oAttacker,"You missed! (epic dodge)");
		AssignCommand(oAttacker, ClearAllActions(FALSE));			
		DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
		return 0;	
	}
				
	int roll = d20();
	int TargetAC = GetAC(oTarget);
	if(FlatFooted(oAttacker, oTarget) && !GetHasFeat(195,oTarget)) TargetAC = TargetAC - GetDodgeAC(oTarget);
	
	int iAttackerAB = AttackerTotalAB(oAttacker);
	if(GetLevelByClass(CLASS_TYPE_RANGER,oAttacker) > 0 && GetIsRangerFavored(oAttacker, oTarget))
	{
		iAttackerAB = iAttackerAB + CalculateRangerBonus(oAttacker);
	}
	
	int iAttack = roll + iAttackerAB; int confirmationRoll; int confirmationTotal;
	
	if(roll == 20 || iAttack >= TargetAC && roll > 1)
	{
		if(roll == 20)
		{
			SendMessageToPC(oAttacker,"You hit! (rolled 20) " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
			SendMessageToPC(oTarget,"You were hit! (rolled 20) " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
		}
		else
		{
			SendMessageToPC(oAttacker,"You hit! " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
			SendMessageToPC(oTarget,"You were hit! " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
		}
		
		int ThreatRange = GetWeaponThreatRange(oAttacker);
	
		if(animation != "")
		{
			PS_CustomAnimation(oAttacker,animation,0);
			BattleCry(oAttacker);
			if(ranged == 0)
			{
				AssignCommand(oAttacker, ClearAllActions(FALSE));
				DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
			}
		}
	
		if(roll >= ThreatRange && !GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT) && !GetHasIgnoreCritImmunity(oAttacker, oTarget))
		{
			confirmationRoll = d20();
			confirmationTotal = confirmationRoll + iAttackerAB;
	
			if (confirmationRoll == 20 || confirmationTotal >= TargetAC && confirmationRoll > 1)
			{
				if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (critical hit)*", oAttacker, TRUE, 3.0f);
				return 2;
			}
		}
	
		if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (hit)*", oAttacker, TRUE, 3.0f);
		return 1;	
	}
	
	if(ranged == 0)
	{
		AssignCommand(oAttacker, ClearAllActions(FALSE));
		DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
	}
	
	if(givefeedback == 1 && roll == 1)
	{
		FloatingTextStringOnCreature(abilityname+" (miss - rolled 1)*", oAttacker, TRUE, 3.0f);
		SendMessageToPC(oAttacker,"You missed! (Rolled 1) "+IntToString(iAttack)+" vs "+IntToString(TargetAC));
		AssignCommand(oAttacker, ClearAllActions(FALSE));
		DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
		return 0;
	}
	
	if(givefeedback == 1) FloatingTextStringOnCreature(abilityname+" (miss)*", oAttacker, TRUE, 3.0f);
	SendMessageToPC(oAttacker,"You missed! "+IntToString(iAttack)+" vs "+IntToString(TargetAC));
			
	return 0;
}

/* orginal code

int AttemptMeleeAttackMainHand(object oAttacker, object oTarget, string abilityname, int givefeedback, string animation, int ranged, int nSpellID)
{
	//0 - miss, 1 - hit, 2 - critical
	// Melee Attack: 1d20 + base attack bonus + strength modifier + size modifier vs their AC.
	// Damage Roll: Weapon Damage Roll + Strength Modifier + Weapon Enhancement.

	int featid; float fDistance = 4.0f;	
	
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oAttacker);
	if(GetIsObjectValid(oWeapon) && GetBaseItemType(oWeapon) == 202) fDistance = 4.75;
	

	
	if(GetDistanceBetween(oAttacker,oTarget) >= 4.0 && ranged == 0)
	{
		if(givefeedback == 1)
		{
			FloatingTextStringOnCreature("*"+abilityname+" (miss - target too far)*", oAttacker, TRUE, 3.0f);
			featid = StringToInt(Get2DAString("spells", "FeatID", nSpellID));
			DelayCommand(1.5f,ResetFeatUses(oAttacker,featid,TRUE,TRUE));
			AssignCommand(oAttacker, ClearAllActions(FALSE));
//			if(GetLocalInt(oAttacker,"HIPSTIMER") == 1)
//			{
//				SendMessageToPC(oAttacker,"In Stealth!");
//				DelayCommand(0.5f,SetActionMode(oAttacker,ACTION_MODE_STEALTH,TRUE));
//			}
			DelayCommand(0.2f,	AssignCommand(oAttacker, ActionAttack(oTarget)));
		}
		return 0;
	}
	
	if(givefeedback == 1 && nSpellID > 0)
	{
	int iTime = GetLocalInt(oAttacker,"GCDOWN"); int uTime = PS_GetTime();
	{	
		//SendMessageToPC(oAttacker,"Debug GCD: "+IntToString(iTime));
		//SendMessageToPC(oAttacker,"Time: "+IntToString(uTime));	
		//SendMessageToPC(oAttacker,"Debug SpellID: "+IntToString(nSpellID));	
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
	SetLocalInt(oAttacker,"GCDOWN",PS_GetTime());
	}
	
	int conceal = ConcealmentCheck(oTarget,ranged); int imiss;
	
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
		if(!GetHasSpellEffect(186,oAttacker) && !GetHasSpellEffect(943, oAttacker) && 
		!GetHasSpellEffect(849, oAttacker) &&
		!GetItemHasItemProperty(GetItemInSlot(INVENTORY_SLOT_HEAD,oAttacker),ITEM_PROPERTY_TRUE_SEEING))
		{
			if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (miss - invisibility)*", oAttacker, TRUE, 3.0f);
			SendMessageToPC(oAttacker,"You missed! (invisibility failure)");
			return 0;
		}
	}
	
	if(GetHasSpellEffect(852,oTarget))
	{
		if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (miss - mirror image)*", oAttacker, TRUE, 3.0f);
		SendMessageToPC(oAttacker,"You missed! (mirror image)");
		AssignCommand(oAttacker, ClearAllActions(FALSE));		
		DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
		RemoveMirrorImage(oTarget);
		return 0;	
	}
	
	if(GetHasFeat(856,oTarget,TRUE) && d6() == 1)
	{
		if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (miss - epic dodge)*", oAttacker, TRUE, 3.0f);
		SendMessageToPC(oAttacker,"You missed! (epic dodge)");
		AssignCommand(oAttacker, ClearAllActions(FALSE));			
		DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
		return 0;	
	}
				
	int roll = d20();
	int TargetAC = GetAC(oTarget);
	if(FlatFooted(oAttacker, oTarget) && !GetHasFeat(195,oTarget)) TargetAC = TargetAC - GetDodgeAC(oTarget);
	
	int iAttackerAB = AttackerTotalAB(oAttacker);
	if(GetLevelByClass(CLASS_TYPE_RANGER,oAttacker) > 0 && GetIsRangerFavored(oAttacker, oTarget))
	{
		iAttackerAB = iAttackerAB + CalculateRangerBonus(oAttacker);
	}
	
	int iAttack = roll + iAttackerAB; int confirmationRoll; int confirmationTotal;
	
	if(roll == 20 || iAttack >= TargetAC && roll > 1)
	{
		if(roll == 20)
		{
			SendMessageToPC(oAttacker,"You hit! (rolled 20) " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
			SendMessageToPC(oTarget,"You were hit! (rolled 20) " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
		}
		else
		{
			SendMessageToPC(oAttacker,"You hit! " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
			SendMessageToPC(oTarget,"You were hit! " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
		}
		
		int ThreatRange = GetWeaponThreatRange(oAttacker);
	
		if(animation != "")
		{
			PS_CustomAnimation(oAttacker,animation,0);
			BattleCry(oAttacker);
			if(ranged == 0)
			{
				AssignCommand(oAttacker, ClearAllActions(FALSE));
				DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
			}
		}
	
		if(roll >= ThreatRange && !GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT) && !GetHasIgnoreCritImmunity(oAttacker, oTarget))
		{
			confirmationRoll = d20();
			confirmationTotal = confirmationRoll + iAttackerAB;
	
			if (confirmationRoll == 20 || confirmationTotal >= TargetAC && confirmationRoll > 1)
			{
				if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (critical hit)*", oAttacker, TRUE, 3.0f);
				return 2;
			}
		}
	
		if(givefeedback == 1) FloatingTextStringOnCreature("*"+abilityname+" (hit)*", oAttacker, TRUE, 3.0f);
		return 1;	
	}
	
	if(ranged == 0)
	{
		AssignCommand(oAttacker, ClearAllActions(FALSE));
		DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
	}
	
	if(givefeedback == 1 && roll == 1)
	{
		FloatingTextStringOnCreature(abilityname+" (miss - rolled 1)*", oAttacker, TRUE, 3.0f);
		SendMessageToPC(oAttacker,"You missed! (Rolled 1) "+IntToString(iAttack)+" vs "+IntToString(TargetAC));
		AssignCommand(oAttacker, ClearAllActions(FALSE));
		DelayCommand(0.2f,AssignCommand(oAttacker, ActionAttack(oTarget)));
		return 0;
	}
	
	if(givefeedback == 1) FloatingTextStringOnCreature(abilityname+" (miss)*", oAttacker, TRUE, 3.0f);
	SendMessageToPC(oAttacker,"You missed! "+IntToString(iAttack)+" vs "+IntToString(TargetAC));
			
	return 0;
}
*/

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