
#include "ps_class_inc"
#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "ff_feat_tactical_weapon_inc"
#include "ff_feat_tactical_weapon_man_inc"

const int SAMURAI_AGILE_WARRIOR_FEAT_ID = 21885;
const int SAMURAI_AGILE_WARRIOR_SPELL_ID = 1537;
const int SAMURAI_COMMANDING_PRESENCE_FEAT_ID = 21886;
const int SAMURAI_COMMANDING_PRESENCE_SPELL_ID = 1538;
const int VFX_SAMURAI_COMMANDING_PRESENCE = 98;
const int SAMURAI_STRIKETHROUGH_FEAT_ID = 21884;
const int SAMURAI_STRIKETHROUGH_SPELL_ID = 1539;
const int SAMURAI_STRIKETHROUGH_IP_ID = 150;
const int SAMURAI_FRENZIED_FEAT_ID = 21883;
const int SAMURAI_FRENZIED_SPELL_ID = 1540;

void AgileWarrior(object oPC, int nLevel);
int TwoHandedNoHeavyArmor(object oPC);
void CommandingPresence(object oPC);
void Strikethrough(object oPC, int nLevel);
void FrenziedBlade(object oPC, int nLevel);
int GetSamKenLevel(object oPC);

int GetSamKenLevel(object oPC){
	int nLevel = GetLevelByClass(CLASS_TYPE_SAMURAI, oPC);
	if (nLevel < 1) return 0;
	
	nLevel += GetLevelByClass(CLASS_TYPE_KENSAI, oPC);
	return nLevel;
}

void FrenziedBlade(object oPC, int nLevel){
	if (!TwoHandedNoHeavyArmor(oPC)){
		SendMessageToPC(oPC, "You can only use this ability if you are not in heavy armor and are using a melee weapon in both hands");
		ResetFeatUses(oPC, SAMURAI_FRENZIED_FEAT_ID, TRUE, TRUE);
		return;
	}
	
	location lPC = GetLocation(oPC);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, MELEE_RANGE, lPC, TRUE);
	while (GetIsObjectValid(oTarget)){
		if (GetIsEnemy(oTarget, oPC))
			break;
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, MELEE_RANGE, lPC, TRUE);
	}
	
	if (!GetIsObjectValid(oTarget)){
		SendMessageToPC(oPC, "You can only use this ability while enemies are within melee range");
		ResetFeatUses(oPC, SAMURAI_FRENZIED_FEAT_ID, TRUE, TRUE);
		return;
	}
	
	int nFeat = FEAT_WHIRLWIND_ATTACK;
	if (nLevel >= 23) nFeat = FEAT_IMPROVED_WHIRLWIND;
	object oSkin = PS_GetCreatureSkin(oPC);
	ApplyTacticalBonusFeat(oSkin, nFeat, oPC);
	DelayCommand(0.3f, ActionUseFeat(nFeat, oTarget));
	RemoveBonusFeats(oSkin, nFeat, oPC);
}

void Strikethrough(object oPC, int nLevel){
	// 50% chance of firing
	if (d100() < 51) 
		return;
	
	if (!TwoHandedNoHeavyArmor(oPC))
		return;
	
	object oTarget = GetSpellTargetObject();
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
	int nTargets;
	float fMod = 0.0f;
	float fMod1; float fMod2; float fMod3;
	if (nLevel >= 25){
		nTargets = 3;
		fMod1 = 0.75f;
		fMod2 = 0.5f;
		fMod3 = 0.25f;
	} else if (nLevel >= 21){
		nTargets = 2;
		fMod1 = 0.75f;
		fMod2 = 0.5f;
		fMod3 = 0.0f;
	} else if (nLevel >= 15){
		nTargets = 2;
		fMod1 = 0.5f;
		fMod2 = 0.25f;
		fMod3 = 0.0f;
	} else {
		nTargets = 1;
		fMod1 = 0.5f;
		fMod2 = 0.0f;
		fMod3 = 0.0f;
	}
	
	effect eDam;
	effect eFX;
	string sMessage = "Strikethrough: ";
	struct DamageStats data;
	int nDam;
	float fDam;
	int nTargetsFound = 0;
	int nAttack;
	location lPC = GetLocation(oPC);
	object oNearest = GetFirstObjectInShape(SHAPE_SPHERE, MELEE_RANGE, lPC, TRUE);
	while (nTargets > 0 && GetIsObjectValid(oNearest)){
		if (oNearest != oTarget && GetIsEnemy(oNearest, oPC)){
			nTargets--;
			nTargetsFound++;
			if (nTargetsFound == 1) fMod = fMod1;
			else if (nTargetsFound == 2) fMod = fMod2;
			else if (nTargetsFound == 3) fMod = fMod3;
			
			if (fMod < 0.01f) break;
			else {
				data = GetDamageStats(oPC, oNearest, oWeapon);
				nAttack = PerformAttack(oPC, oNearest, 0, data);
				if (nAttack != ATTACK_MISS){
					nDam = data.nDam + data.nAbilityDamMod;
					if (nAttack == ATTACK_CRIT){
						nDam *= data.nCritMult;
						sMessage += "Critical Hit!";
					} else sMessage += "Hit!";
					fDam = IntToFloat(nDam) * fMod;
					nDam = FloatToInt(fDam);
					eDam = EffectDamage(nDam, data.nDamType, data.nPow, FALSE);
					eFX = EffectLinkEffects(data.eHit, eDam);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oNearest);
					FloatingTextStringOnCreature(sMessage, oPC);
				}
			}
		}
		oNearest = GetNextObjectInShape(SHAPE_SPHERE, MELEE_RANGE, lPC, TRUE);
	}
}

void CommandingPresence(object oPC){
	
	if (!GetHasFeat(SAMURAI_COMMANDING_PRESENCE_FEAT_ID, oPC, TRUE))
		return;
	effect eAOE = EffectAreaOfEffect(VFX_SAMURAI_COMMANDING_PRESENCE);
	eAOE = SupernaturalEffect(eAOE);
 
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oPC);
}

int TwoHandedNoHeavyArmor(object oPC){
		// Most Samurai abilities only work in light, medium, or no armor
	if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) == ARMOR_RANK_HEAVY)
		return FALSE;
		
	// and only work if using a melee weapon...
	object oRHAND = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (!IPGetIsMeleeWeapon(oRHAND))
		return FALSE;

	//... and that melee weapon is being used two handed
	if (!GetWeaponIsTwoHanded(oPC, oRHAND, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
		return FALSE;
		
	return TRUE;
}

void AgileWarrior(object oPC, int nLevel){

	PS_RemoveEffects(oPC, SAMURAI_AGILE_WARRIOR_SPELL_ID);
	
	if (!GetHasFeat(SAMURAI_AGILE_WARRIOR_FEAT_ID, oPC, TRUE))
		return;
	
	if (!TwoHandedNoHeavyArmor(oPC))
		return;
		
	int nBonus = 0;

	if (nLevel >= 17) nBonus = 3;
	else if (nLevel >= 9) nBonus = 2;
	else if (nLevel >= 3) nBonus = 1;
	
	if (nBonus < 1) return;
	
	effect eAC = EffectACIncrease(nBonus);
	eAC = SupernaturalEffect(eAC);
	eAC = SetEffectSpellId(eAC, SAMURAI_AGILE_WARRIOR_SPELL_ID);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
}