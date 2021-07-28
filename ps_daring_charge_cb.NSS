#include "X0_I0_SPELLS"

int FEAT_RECKLESS_CHARGE = 15001;
int FEAT_WATCHFUL_CHARGE = 15002;
int FEAT_HEAVY_CHARGE = 15003;
int FEAT_SWEEPING_CHARGE = 15004;
int FEAT_SWIFT_CHARGE = 15005;
int FEAT_SHADOWED_CHARGE = 15006;
int FEAT_FRENZIED_CHARGE = 15010;

int GetDamageBonusConstant(int nDamage)
{
	switch(nDamage) {
	case 0:  return DAMAGE_BONUS_1;
	case 1:  return DAMAGE_BONUS_1;
	case 2:  return DAMAGE_BONUS_2;
	case 3:  return DAMAGE_BONUS_3;
	case 4:  return DAMAGE_BONUS_4;
	case 5:  return DAMAGE_BONUS_5;
	case 6:  return DAMAGE_BONUS_6;
	case 7:  return DAMAGE_BONUS_7;
	case 8:  return DAMAGE_BONUS_8;
	case 9:  return DAMAGE_BONUS_9;
	case 10: return DAMAGE_BONUS_10;
	case 11:  return DAMAGE_BONUS_11;
	case 12:  return DAMAGE_BONUS_12;
	case 13:  return DAMAGE_BONUS_13;
	case 14:  return DAMAGE_BONUS_14;
	case 15:  return DAMAGE_BONUS_15;
	case 16:  return DAMAGE_BONUS_16;
	case 17:  return DAMAGE_BONUS_17;
	case 18:  return DAMAGE_BONUS_18;
	case 19:  return DAMAGE_BONUS_19;
	case 20: return DAMAGE_BONUS_20;
	case 21:  return DAMAGE_BONUS_21;
	case 22:  return DAMAGE_BONUS_22;
	case 23:  return DAMAGE_BONUS_23;
	case 24:  return DAMAGE_BONUS_24;
	case 25:  return DAMAGE_BONUS_25;
	case 26:  return DAMAGE_BONUS_26;
	case 27:  return DAMAGE_BONUS_27;
	case 28:  return DAMAGE_BONUS_28;
	case 29:  return DAMAGE_BONUS_29;
	case 30: return DAMAGE_BONUS_30;
	case 31:  return DAMAGE_BONUS_31;
	case 32:  return DAMAGE_BONUS_32;
	case 33:  return DAMAGE_BONUS_33;
	case 34:  return DAMAGE_BONUS_34;
	case 35:  return DAMAGE_BONUS_35;
	case 36:  return DAMAGE_BONUS_36;
	case 37:  return DAMAGE_BONUS_37;
	case 38:  return DAMAGE_BONUS_38;
	case 39:  return DAMAGE_BONUS_39;
	case 40: return DAMAGE_BONUS_40;
	}
	return DAMAGE_BONUS_40;
}

void doKnockdown(object oCaster, object oTarget, int hasHeavyCharge)
{
	if(!GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN)) {
		int nCasterSize = GetCreatureSize(oCaster);
		nCasterSize += hasHeavyCharge ? 1 : 0;
		int nTargetSize = GetCreatureSize(oTarget);
		int nTargetSizeBonus = nTargetSize - nCasterSize;
		if(nTargetSizeBonus <= 1) {
			if(TouchAttackMelee(oTarget)) {
				int nCasterRoll = d20() + GetAbilityModifier(ABILITY_STRENGTH, oCaster);
				int nTargetSTR = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
				int nTargetDEX = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
				int nTargetAbl = nTargetSTR > nTargetDEX ? nTargetSTR : nTargetDEX;
				int nTargetRoll = d20() + nTargetAbl + 4 * nTargetSizeBonus;
				SendMessageToPC(oCaster, "Daring Charge knockdown check: player "
					+ IntToString(nCasterRoll) + " vs " + GetName(oTarget) + " "
					+ IntToString(nTargetRoll));
				if(nCasterRoll >= nTargetRoll) {
					effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
						EffectKnockdown(),
						oTarget,
						6.0f);
				}
			}
		}
	}
}

void main()
{
	object oCaster = OBJECT_SELF;
	object oTarget = GetLocalObject(oCaster, "DARING_CHARGE_TARGET_OBJ");
	DeleteLocalObject(oCaster, "DARING_CHARGE_TARGET_OBJ");

	float fDist = GetDistanceToObject(oTarget);

	// Combat flow bonuses
	int nSbLevels = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER);
	int nIntBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
	int nDurRounds = 3;
	float durSeconds = nDurRounds * 6.0f;

	int hasHeavyCharge = GetHasFeat(FEAT_HEAVY_CHARGE, oCaster, TRUE);
	
	// TEMP HP
	int nTempHp = (nSbLevels == 1 ? 1 : (nSbLevels / 2)) + (nIntBonus > 0 ? nIntBonus : 0);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
		ExtraordinaryEffect(EffectTemporaryHitpoints(nTempHp)),
		oCaster,
		durSeconds);

	// DAMAGE BONUS
	int nDmgBonus = (nSbLevels == 1 ? 1 : nSbLevels / 2);
	nDmgBonus += hasHeavyCharge ? (nIntBonus > 0 ? nIntBonus : 0) : 0;
	object mainWpnItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	int nWpnType = GetWeaponType(mainWpnItem);
	int nDmgType = 0;
	switch(nWpnType) {
	default:
	case WEAPON_TYPE_PIERCING:
		nDmgType = DAMAGE_TYPE_PIERCING;
		break;
	case WEAPON_TYPE_BLUDGEONING:
		nDmgType = DAMAGE_TYPE_BLUDGEONING;
		break;
	case WEAPON_TYPE_SLASHING:
		nDmgType = DAMAGE_TYPE_SLASHING;
		break;
	case WEAPON_TYPE_PIERCING_AND_SLASHING:
		nDmgType = DAMAGE_TYPE_PIERCING | DAMAGE_TYPE_SLASHING;
		break;
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
		ExtraordinaryEffect(EffectDamageIncrease(GetDamageBonusConstant(nDmgBonus), nDmgType)),
		oCaster,
		durSeconds);

	string strReport = "Daring Charge: gained " 
		+ IntToString(nTempHp) + " temporary HP, +"
		+ IntToString(nDmgBonus) + " damage";

	// FEATS
	if(GetHasFeat(FEAT_RECKLESS_CHARGE, oCaster, TRUE)) {
		int nABBonus = nSbLevels / 6;
		strReport += ", +" + IntToString(nABBonus) + " attack bonus";
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectAttackIncrease(nABBonus, ATTACK_BONUS_MISC)),
			oCaster, durSeconds);
	}
	
	if(GetHasFeat(FEAT_WATCHFUL_CHARGE, oCaster, TRUE)) {
		int nACBonus = nSbLevels / 6;
		strReport += ", +" + IntToString(nACBonus) + " AC bonus";
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(nACBonus)),
			oCaster, durSeconds);
	}
	
	if(GetHasFeat(FEAT_SWIFT_CHARGE, oCaster, TRUE)) {
		strReport += ", hasted";
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectHaste()),
			oCaster, durSeconds);
	}

	if(GetHasFeat(FEAT_SHADOWED_CHARGE, oCaster, TRUE)) {
		strReport += ", 50% concealment";
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectConcealment(50)),
			oCaster, durSeconds);
	}

	if(GetHasFeat(FEAT_FRENZIED_CHARGE, oCaster, TRUE)) {
		strReport += ", 1 extra attack";
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectModifyAttacks(1)),
			oCaster, durSeconds);
	}

	SendMessageToPC(oCaster, strReport + " for " + IntToString(nDurRounds) + " rounds");

	// Knockdown effect
	if(fDist <= 1.0f) {
		if(!GetHasFeat(FEAT_SWEEPING_CHARGE, oCaster, TRUE)) {
			doKnockdown(oCaster, oTarget, hasHeavyCharge);
		}
		else {
			location loc = GetLocation(oCaster);
			object oTgt = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, loc, TRUE, OBJECT_TYPE_CREATURE);
			while(GetIsObjectValid(oTgt)) {
				if(oTgt != oCaster && spellsIsTarget(oTgt, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)) {
					doKnockdown(oCaster, oTgt, hasHeavyCharge);
				}
				oTgt = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, loc, TRUE, OBJECT_TYPE_CREATURE);
			}
		}
	}
	
	AssignCommand(oCaster, ActionAttack(oTarget));
}