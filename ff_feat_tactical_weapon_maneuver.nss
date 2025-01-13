#include "ff_feat_tactical_weapon_inc"
#include "ps_inc_functions"
#include "ps_inc_melee"

const int TAC_SPELL_ID = 14718;
const int TAC_FEAT_ID = 21922;
const float MELEE_RANGE = 3.5f;
const int ATTACK_MISS = 0;
const int ATTACK_HIT = 1;
const int ATTACK_CRIT = 2;

struct DamageStats{
	object oSkin; // creature skin in INVENTORY_SLOT_CARMOUR
	int nPow; // power of the damage, DAMAGE_POWER_NORMAL, DAMAGE_POWER_PLUS_ONE, etc, for damage effect
	int nDam; // amount of damage
	int nDamType; // piercing, slashing, etc
	int nHitMod; // ability modifier for attack roll
	int nAbilityDamMod; // ability damage modifier, not auto-added to damage, see Entangle
	int bCritImmune; // whether the target is immune to crits
	int bRacialImmune; // the target is an ooze or incorporeal, which makes them immune to some of these
	int nCritRange; // crit range of weapon from 2da, 1 if not a weapon
	int nCritMult; // crit multiplier of weapon from 2da, 2 if not a weapon
	int nCritConfirm; // 4 if they have power crit, 0 otherwise
	effect eHit; // the visual effect to apply to a hit, depends upon race of target
};
effect GetVFX(object oTarget);
int GetDamageBonus(itemproperty ip);
int PerformAttack(object oPC, object oTarget, int nPenalty, struct DamageStats data);
int RollDice(int nNumDice, int nDicetype);
struct DamageStats GetDamageStats(object oPC, object oTarget, object oItem)	;
void ApplyManeuverEffect(object oTarget, effect eFX, float fDuration = 0.0f);
void DoDisablingStrike(object oPC, object oTarget, struct DamageStats data);
void DoEntangle(object oPC, object oTarget, object oRHAND, object oLHAND, struct DamageStats data);
void DoHewing(object oPC, object oTarget, struct DamageStats data);
void DoLegSweep(object oPC, object oTarget, object oRHAND, object oLHAND, struct DamageStats data);
void DoRoundhouse(object oPC, object oTarget, struct DamageStats data);

void main(){
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();	
	
	if (!GetIsObjectValid(oTarget)){
		SendMessageToPC(oPC, "Invalid Target");
		return;
	}
	object oRHAND = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oLHAND = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE || !GetIsEnemy(oTarget, oPC)){
		SendMessageToPC(oPC, "Invalid target");
		return;
	}
	
	int nTacSuite = GetTacSuiteByWeaponCategory(oPC, oRHAND);
	
	if (nTacSuite == TAC_SUITE_NONE){
		SendMessageToPC(oPC, "You must have a weapon equipped to use this feat.");
		return;
	}
	
	if (!GetInWeaponRange(oPC, oTarget)){
		SendMessageToPC(oPC, "Target out of range!");
		ResetFeatUses(oPC, GetSpellFeatId(), FALSE, TRUE);
		return;
	}
	
	struct DamageStats data = GetDamageStats(oPC, oTarget, oRHAND);
	
	switch (nTacSuite){
		case TAC_SUITE_BOW: DoDisablingStrike(oPC, oTarget, data); break;
		case TAC_SUITE_CE: DoDisablingStrike(oPC, oTarget, data); break;
		case TAC_SUITE_CLEAVE: DoHewing(oPC, oTarget, data); break;
		case TAC_SUITE_DISARM: DoEntangle(oPC, oTarget, oRHAND, oLHAND, data); break;
		case TAC_SUITE_KD: DoLegSweep(oPC, oTarget, oRHAND, oLHAND, data); break;
		case TAC_SUITE_PA: DoRoundhouse(oPC, oTarget, data); break;
	}
	ClearAllActions(TRUE);
	DelayCommand(0.1f, ActionAttack(oTarget));
}

int PerformAttack(object oPC, object oTarget, int nPenalty, struct DamageStats data){
	int nAB = GetBaseAttackBonus(oPC) + data.nPow + nPenalty + data.nHitMod;
	int nAC = GetAC(oTarget);

	int nRoll = d20(1);
	if (nRoll + nAB > nAC){
		if (nRoll >= 20 - data.nCritRange + 1 && !data.bCritImmune){
			int bConfirm = (d20(1) + nAB + data.nCritConfirm > nAC);
			if (bConfirm) return ATTACK_CRIT;
		}
		return ATTACK_HIT;
	}
	return ATTACK_MISS;
}

/*
Make a free attack with a -2 penalty. If you are using a polearm 1-handed it's a -4 penalty. If you hit you deal half damage and attempt to sweep your opponent's legs (or whatever they use for legs) out from under them. You make a knockdown roll that, if successful, knocks them down. This does not provoke an attack of opportunity. If you succeed your opponent also takes 1d6 bypassing blunt falling damage for each size category they are above tiny and is slowed for 2 rounds after the knockdown wears off. Even if you fail the knockdown, your opponent is still slowed for 2 rounds due to taking a hit on their method of mobility. This ability may be attempted no matter what size your opponent is. If you have Improved knockdown feat, your penalty is reduced by 2 and you are treated as one size larger than you really are for the knockdown roll. Oozes, incorporeal beings, and creatures immune to knockdown cannot be knocked down in this way and therefore won't take the falling damage either, but they will still be slowed. Shamans of level 6 or higher and undead can use this move to full effect on incorporeal opponents. 
*/
void DoLegSweep(object oPC, object oTarget, object oRHAND, object oLHAND, struct DamageStats data){

	int nDam = (data.nDam + data.nAbilityDamMod) / 2;
	int nPenalty = -2;
	int nSize = GetCreatureSize(oPC);
	if (GetHasFeat(FEAT_IMPROVED_KNOCKDOWN, oPC, TRUE)){
		nPenalty = 0;
		nSize += 1;
	}

	
	// polearms have an additional -2 to leg sweep maneuver if not used with both hands.
	if (GetWeaponIsPolearm(GetBaseItemType(oRHAND)) && !GetWeaponIsTwoHanded(oPC, oRHAND, oLHAND))
			nPenalty -= 2;
			
	string sMessage = "Leg Sweep Maneuver";
	int bHit = FALSE;
	effect eDam;
	int bKd = FALSE;
	effect eKd = EffectKnockdown();
	effect eSlow = EffectSlow();
	
	int nResult = PerformAttack(oPC, oTarget, nPenalty, data);
	if (nResult == ATTACK_CRIT) nDam *= data.nCritMult;
	
	if (nResult != ATTACK_MISS){
		if (nResult == ATTACK_HIT) sMessage += " Hit!";
		else sMessage += " Critical Hit!"; // roll function won't return crit if target immune
		bHit = TRUE;
		eDam = EffectDamage(nDam, data.nDamType, data.nPow, FALSE);
		eDam = EffectLinkEffects(data.eHit, eDam);
		if (GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN, oPC) || data.bRacialImmune) 
			sMessage += "\nTarget Immune to Knockdown!";
		else {
			// now roll for knockdown as explained at https://nwn2.fandom.com/wiki/Knockdown.
			// PC first
			int nAbility = GetAbilityModifier(ABILITY_STRENGTH, oPC);
			int nTargetSize = GetCreatureSize(oTarget);
			int nPcRoll = d20(1) + nAbility + ((nSize - nTargetSize) * 4);
			// now get the target's roll
			nAbility = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
			int nDex =  GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
			if (nDex > nAbility) nAbility = nDex;
			int nTargetRoll = d20(1) + nAbility;
			if (nTargetRoll > nPcRoll) sMessage += "\nKnockdown Failed!";
			else {
				bKd = TRUE;
				sMessage += "\nTarget Knocked Down";
				int nMultiplier = nTargetSize - 1;
				if (nMultiplier > 0){
					nDam = d6(nMultiplier);
					effect eDam2 = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING, 0, TRUE);
					eDam = EffectLinkEffects(eDam2, eDam);
				}		
			}
		}
	} else sMessage += " Missed!";
	SendMessageToPC(oPC, sMessage);
	FloatingTextStringOnCreature(sMessage, oPC, FALSE);
	
	if (bHit){
		ApplyManeuverEffect(oTarget, eDam);
		if (bKd){
			AssignCommand(oTarget, ClearAllActions(TRUE));
			DelayCommand(0.2f, ApplyManeuverEffect(oTarget, eKd, 6.0f));
			DelayCommand(0.2f, ApplyManeuverEffect(oTarget, eSlow, 18.0f));
		} else ApplyManeuverEffect(oTarget, eSlow, 12.0f);
	}
}
/*
Make a free attack with a -2 penalty (no penalty if you have Improved Disarm). If you hit you do half damage and your weapon wraps around your opponent's weapon. You then attempt to pull them off-balance and disarm them by giving a quick tug. This does not provoke an attack of opportunity. You roll your dexterity or strength, whichever is higher, plus your size category, and your opponent rolls their dexterity or strength plus their size category. If you roll the same or lower, your opponent pulls their weapon free. If you roll higher, your opponent is pulled slightly off-balance and loses half of their dexterity bonus to armor class (minimum 3) for 1 round. As they fall towards you you gain a free special attack with your off-hand weapon, shield, or shoulder-check/body-slam. This will automatically hit but you do not get ability score modifiers to damage;  you're putting yourself/shield/weapon in their way, not actively lashing out. If using an off-hand weapon, you hit with that. If using a shield, you do 1d6 damage for a light shield, 1d10 for a heavy, and 3d4 for a tower. If shoulder-checking, you do 1d6 if you are a small character, 1d8 if medium, and 1d10 if large or huge, plus a bonus of 1 for light armor, 2 for medium armor, and 3 for heavy armor. In either of the latter 2 cases, your ac enchantment on shields or armor count as ehancement bonuses to damage. Finally, you attempt to disarm your opponent by pulling the entangled weapon out of their hand. This requires a normal disarm roll but does not provoke an attack of opportunity. Because your weapon is wrapped around theirs, your weapon is treated as one size larger than it really is for purposes of the disarm roll and if you have Improved Disarm you get a +2 bonus to this roll. You cannot disarm oozes or slimes or pull them off-balance and they therefore don't take the additional attack either. You also cannot pull incorporeal targets off-balance or disarm them unless your character is undead or at least Shaman level 6. 
 */
void DoEntangle(object oPC, object oTarget, object oRHAND, object oLHAND, struct DamageStats data){
	int nAB = GetBaseAttackBonus(oPC) + data.nPow;
	int nDam = (data.nDam + data.nAbilityDamMod) / 2;
	int nPenalty = -2;
	int nBonus = 0;
	if (GetHasFeat(FEAT_IMPROVED_DISARM, oPC, TRUE)){
		nPenalty = 0;
		nBonus = 2;
	}
	
	object oTargetWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	
	string sMessage = "Entangle Maneuver";
	int bHit = FALSE;
	effect eDam;
	int bOffBalance = FALSE;
	effect eOffBalance;
	int bDisarm = FALSE;

	int nResult = PerformAttack(oPC, oTarget, nPenalty, data);
	if (nResult == ATTACK_CRIT) nDam *= data.nCritMult;
	
	if (nResult != ATTACK_MISS){
		if (nResult == ATTACK_HIT) sMessage += " Hit!";
		else sMessage += " Critical Hit!";
		bHit = TRUE;
		eDam = EffectDamage(nDam, data.nDamType, data.nPow, FALSE);
		eDam = EffectLinkEffects(data.eHit, eDam);
		if (data.bRacialImmune) sMessage += "\nTarget Cannot Be Pulled Off-Balance";
		else {
			// now an opposed roll to see if the target resists being pulled forward
			int nSize = GetCreatureSize(oPC);
			int nAbility = GetAbilityModifier(ABILITY_STRENGTH, oPC);
			int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
			if (nDex > nAbility) nAbility = nDex;
			int nPcRoll = d20(1) + nSize + nAbility;
			// now the targets roll
			nSize = GetCreatureSize(oTarget);
			nAbility = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
			nDex = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
			if (nDex > nAbility) nAbility = nDex;
			int nTargetRoll = d20(1) + nSize + nAbility;
			if (nPcRoll > nTargetRoll){
	
				sMessage += "\nTarget Off-Balance ";
				bOffBalance = TRUE;
				nDex = nDex / 2;
				if (nDex < 3) nDex = 3;
				eOffBalance = EffectACDecrease(nDex);
				
				data = GetDamageStats(oPC, oTarget, oLHAND);
				effect eDam2 = EffectDamage(data.nDam, data.nDamType, data.nPow, FALSE);
				eDam = EffectLinkEffects(eDam2, eDam);
				// Apparently EVERYTHING is flagged as immune disarm, so not checking for that. I'm guessing some 
				// dev at some point didn't want players to get a hold of creature weapons so instead of doing the
				// sensible thing and rewriting disarm feat to make mobs unequip weapons instead of drop them, they
				// just made disarm feat useless. smfh
				if (oTargetWeapon == OBJECT_INVALID) sMessage += "but cannot be disarmed!";
				else {
					// now the disarm roll as detailed at https://nwn2.fandom.com/wiki/Disarm
					nSize = GetCreatureSize(oPC);
					int nWeaponSize = IPGetWeaponSize(oRHAND) + 1;
					nPcRoll = nAB + (nSize * 4) + (nWeaponSize * 4) + d20(1) + nBonus;
					// Opponent roll
					nAB = GetBaseAttackBonus(oTarget);
					data = GetDamageStats(oPC, oTarget, oTargetWeapon);
					nAB += data.nPow;
					nSize = GetCreatureSize(oTarget);
					nWeaponSize = IPGetWeaponSize(oTargetWeapon);
					int nTargetRoll = nAB + (nSize * 4) + (nWeaponSize * 4) + d20(1);
					if (nPcRoll >= nTargetRoll){
						sMessage += " and is disarmed!";
						bDisarm = TRUE;
					} else sMessage += " but pulls their weapon free!";
				}
			} else sMessage += "\nTarget Resists!";
		}
	} else sMessage += " Missed!";
	SendMessageToPC(oPC, sMessage);
	FloatingTextStringOnCreature(sMessage, oPC, FALSE);	
	
	if (bHit){
		ApplyManeuverEffect(oTarget, eDam);
		if (bOffBalance) ApplyManeuverEffect(oTarget, eOffBalance, 6.0f);
		if (bDisarm){
			AssignCommand(oTarget, ClearAllActions(TRUE));
			DelayCommand(0.2f, AssignCommand(oTarget, ActionUnequipItem(oTargetWeapon)));
			DelayCommand(0.5f, AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE)));
		}
	}
}

/*
Make a free attack with a -2 penalty. If you have Improved Power Attack, you have no penalty and do 150% damage. Either way, if you hit then 2/3 of your damage is applied normally and the other 1/3  bypasses all resistances and immunities.
*/
void DoRoundhouse(object oPC, object oTarget, struct DamageStats data){

	int nDam = data.nDam + data.nAbilityDamMod;
	int nPenalty = 2;
	if (GetHasFeat(FEAT_IMPROVED_POWER_ATTACK, oPC, TRUE)){
		nPenalty = 0;
		nDam += nDam / 2;
	}
	
	string sMessage = "Roundhouse Maneuver";
	int bHit = FALSE;
	effect eDam;
	
	int nResult = PerformAttack(oPC, oTarget, nPenalty, data);
	if (nResult == ATTACK_CRIT) nDam *= data.nCritMult;
	
	// split the damage, 2/3 normal and 1/3 bypassing
	int nDamBypass = nDam / 3;
	if (nDamBypass < 1) nDamBypass = 1;
	nDam = nDamBypass * 2;
	
	if (nResult != ATTACK_MISS){
		if (nResult == ATTACK_HIT) sMessage += " Hit!";
		else sMessage += " Critical Hit!";
		bHit = TRUE;
	} else sMessage += " Missed!";
	SendMessageToPC(oPC, sMessage);
	FloatingTextStringOnCreature(sMessage, oPC, FALSE);	
	
	if (bHit){
		eDam = EffectDamage(nDam, data.nDamType, data.nPow, FALSE);
		effect eDamBypass = EffectDamage(nDamBypass, data.nDamType, data.nPow, TRUE);
		eDam = EffectLinkEffects(eDamBypass, eDam);
		eDam = EffectLinkEffects(data.eHit, eDam);
		ApplyManeuverEffect(oTarget, eDam);
	}
}

/*
Make a free attack with a -2 penalty. If you hit, you sweep your blade along the next enemy, doing double damage divided evenly between the two. If you have Great Cleave, you have no penalty and you do 300% divided evenly between your target and the nearest 2 other enemies. If you do not have enough targets the damage is divided between the available enemies, though you cannot do more than 150% damage to any one enemy.
*/
void DoHewing(object oPC, object oTarget, struct DamageStats data){

	int nDam = data.nDam + data.nAbilityDamMod;
	int nMaxDamToEach = nDam + (nDam / 2);
	int nTargetsFound = 1; // includes initial target
	int nAddTargets = 1; // number of targets other than intitial, not total targets
	int nPenalty = 2;
	if (GetHasFeat(FEAT_GREAT_CLEAVE, oPC, TRUE)){
		nPenalty = 0;
		nAddTargets = 2;
		nDam *= 3;
	} else nDam *= 2;
	
	string sMessage = "Hewing Maneuver";
	int bHit = FALSE;
	effect eDam;
	object oNearest1 = OBJECT_INVALID;
	object oNearest2 = OBJECT_INVALID;
	
	int nResult = PerformAttack(oPC, oTarget, nPenalty, data);
	if (nResult == ATTACK_CRIT){
		nDam *= data.nCritMult;
		nMaxDamToEach *= data.nCritMult;
	}
	
	
	if (nResult != ATTACK_MISS){
		if (nResult == ATTACK_HIT) sMessage += " Hit!";
		else sMessage += " Critical Hit!";
		bHit = TRUE;
		location lPC = GetLocation(oPC);
		object oNearest = GetFirstObjectInShape(SHAPE_SPHERE, MELEE_RANGE, lPC, TRUE);
		while (nAddTargets > 0 && GetIsObjectValid(oNearest)){
			if (oNearest != oTarget && oNearest != oNearest1 && GetIsEnemy(oNearest, oPC)){
				nAddTargets--;
				nTargetsFound++;
				if (oNearest1 == OBJECT_INVALID) oNearest1 = oNearest;
				else oNearest2 = oNearest;
			} else oNearest = GetNextObjectInShape(SHAPE_SPHERE, MELEE_RANGE, lPC, TRUE);
		}
	} else sMessage += " Missed!";
	
	SendMessageToPC(oPC, sMessage);
	FloatingTextStringOnCreature(sMessage, oPC, FALSE);	
	
	if (bHit){
		nDam = nDam / nTargetsFound;
		if (nDam > nMaxDamToEach) nDam = nMaxDamToEach;
		eDam = EffectDamage(nDam, data.nDamType, data.nPow, FALSE);
		effect efx = EffectLinkEffects(data.eHit, eDam);
		ApplyManeuverEffect(oTarget, efx);
		if (oNearest1 != OBJECT_INVALID){
			efx = EffectLinkEffects(GetVFX(oNearest1), eDam);
			ApplyManeuverEffect(oNearest1, efx);
		}
		if (oNearest2 != OBJECT_INVALID){
			efx = EffectLinkEffects(GetVFX(oNearest2), eDam);
			ApplyManeuverEffect(oNearest2, efx);
		}
	}
}


/*
Attack with a -2 penalty, lunging at whatever limb your opponent attacks with most. If you hit then your target takes 150% damage and suffers a -2 attack penalty, 20% miss chance, and 2 points of bypassing "bleed" damage for 2 rounds. If you have Improved Combat Expertise you have no attack penalty and your opponent suffers -3 attack penalty, 30% miss chance, and 3 points bleed for 3 rounds. If your opponent is immune to critical hits they take normal damage instead of 150% and do not suffer the bleed damage, but still suffer the other penalties. If your opponent is incorporeal or an ooze, they take normal damage only and suffer no penalties. Shamans of level 6 and above and undead characters can use this ability to full effect on incorporeal targets.
*/
void DoDisablingStrike(object oPC, object oTarget, struct DamageStats data){

	int nDam = data.nDam + data.nAbilityDamMod;
	int nPenalty = -2;
	int nTargetPenalty = 2;
	if (GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE, oPC, TRUE)){
		nPenalty = 0;
		nTargetPenalty = 3;
	} 
	
	if (!data.bCritImmune) nDam += nDam / 2;
		// TODO DOT
	string sMessage = "Disabling Strike Maneuver";
	int bHit = FALSE;
	effect eDam;
	int bCrip = FALSE;
	effect eCrip;
	
	int nResult = PerformAttack(oPC, oTarget, nPenalty, data);
	if (nResult == ATTACK_CRIT) nDam *= data.nCritMult;
	
	if (nResult != ATTACK_MISS){
		if (nResult == ATTACK_HIT) sMessage += " Hit!";
		else sMessage += " Critical Hit!";
		bHit = TRUE;
		eDam = EffectDamage(nDam, data.nDamType, data.nPow, FALSE);
		if (data.bRacialImmune) sMessage += "\nTarget Immune!";
		else {
			bCrip = TRUE;
			eCrip = EffectAttackDecrease(nTargetPenalty);
			effect eMiss = EffectMissChance(nTargetPenalty * 10);
			eCrip = EffectLinkEffects(eMiss, eCrip);
			if (!data.bCritImmune){
				effect eBleed = EffectDamageOverTime(nTargetPenalty, 6.0f, data.nDamType, TRUE);
				eCrip = EffectLinkEffects(eBleed, eCrip);
			}
		}
	} else sMessage += " Missed!";
	
	SendMessageToPC(oPC, sMessage);
	FloatingTextStringOnCreature(sMessage, oPC, FALSE);	
	
	if (bHit){
		ApplyManeuverEffect(oTarget, eDam);
		if (bCrip) ApplyManeuverEffect(oTarget, eCrip, RoundsToSeconds(nTargetPenalty));
	}
}

void ApplyManeuverEffect(object oTarget, effect eFX, float fDuration = 0.0f){
	if (fDuration == 0.0f) ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oTarget);
    else	{
		eFX = SupernaturalEffect(eFX);
		eFX = SetEffectSpellId(eFX, TAC_SPELL_ID);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oTarget, fDuration);
	}
}

int RollDice(int nNumDice, int nDicetype){
	int nResult = 0;
	int i;
	for (i = 1; i <= nNumDice; i++){
		nResult += Random(nDicetype) + 1;
	}
	return nResult;
}

effect GetVFX(object oTarget){
	int nTargetRace = GetRacialType(oTarget);
	int vfx = VFX_COM_CHUNK_RED_SMALL;
	switch (nTargetRace){
		case RACIAL_TYPE_CONSTRUCT:
		case RACIAL_TYPE_ELEMENTAL:{
				vfx = VFX_COM_CHUNK_STONE_SMALL; break;
			}
		case RACIAL_TYPE_UNDEAD:
		case RACIAL_TYPE_INCORPOREAL:{
				vfx = VFX_COM_HIT_NEGATIVE; break;
			}
		case RACIAL_TYPE_OOZE: vfx = VFX_COM_CHUNK_YELLOW_SMALL; break;
	}
	return EffectVisualEffect(vfx);
}

// at some point this will need to be completely re-written to use Dae's function dae_GetOnHandAttackModifier()
// but not until I have time to test what exactly that does and does not include so I don't wind up
// counting any modifiers twice. Since Dae's plugin functions are opaque to the rest of us he
// should really be more complete with his commentary explanations. -FlattedFifth
struct DamageStats GetDamageStats(object oPC, object oTarget, object oItem){
	
	int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
	

	struct DamageStats data;
	data.nPow = 0;
	data.nDam = 0;
	data.nDamType = DAMAGE_TYPE_BLUDGEONING;
	data.nHitMod = nStr;
	data.nAbilityDamMod = nStr;
	data.bCritImmune = FALSE;
	data.bRacialImmune = FALSE;
	data.nCritRange = 1;
	data.nCritMult = 2;
	data.nCritConfirm = 0;
	data.eHit = GetVFX(oTarget);
	
	// find out what immunities the target has and if we overcome them.
	data.bCritImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, oPC);
	int nTargetRace = GetRacialType(oTarget);		
	data.bRacialImmune = (nTargetRace ==  RACIAL_TYPE_OOZE || nTargetRace == RACIAL_TYPE_INCORPOREAL);
	if (nTargetRace == RACIAL_TYPE_INCORPOREAL){
		if (GetHasFeat(2132, oPC, TRUE) || // spirit's ruin
			GetHasFeat(2031, oPC, TRUE) || // shaman ghost warrior feat
			GetRacialType(oPC) == RACIAL_TYPE_UNDEAD){
				data.bCritImmune = FALSE;
				data.bRacialImmune = FALSE;
			}
	}
	

	
	// Find out what kind of object we're dealing with. Main hand weapon?
	// offhand? two-hand? Shield? shoulder-check/body-slam?
	int nType = GetBaseItemType(oItem);
	object oLHAND = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	int bIsOffHand = (oLHAND == oItem);
	int bIsMelee = IPGetIsMeleeWeapon(oItem); // unarmed strikes don't work with tac 
	int bIsWeapon = (bIsMelee || IPGetIsRangedWeapon(oItem));
	int bIsTwoHand = FALSE;	
		if (oLHAND == OBJECT_INVALID && bIsMelee)
			bIsTwoHand = GetWeaponIsTwoHanded(oPC, oItem, oLHAND);
	
	// set up integers that will be converted to initial damage
	int nNumDice = 0;
	int nDicetype = 0;
	int nBonus = 0;	
	int bImpCrit = FALSE;
	int bKiCrit = FALSE;

	// get the data for the above integers, as well as crit ranges for weapons and ability mods
	// and damage types
	if (bIsWeapon){
		data.nCritRange = StringToInt(Get2DAString("baseitems", "CritThreat", nType));
		data.nCritMult = StringToInt(Get2DAString("baseitems", "CritHitMult", nType));
		if (GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATImprCrit", nType)), oPC, TRUE)){
			bImpCrit = TRUE;
			data.nCritRange *= 2;
		}
		if (GetHasFeat(StringToInt(Get2DAString("baseitems", "FEATPowerCrit", nType)), oPC, TRUE))
			data.nCritConfirm = 4;
		nNumDice = StringToInt(Get2DAString("baseitems", "NumDice", nType));
		nDicetype = StringToInt(Get2DAString("baseitems", "DieToRoll", nType));
		
		if (IPGetIsPiercingWeapon(oItem)) data.nDamType = DAMAGE_TYPE_PIERCING;
		else if (IPGetIsSlashingWeapon(oItem, -1, FALSE)) data.nDamType = DAMAGE_TYPE_SLASHING;
		
		if (bIsMelee){
			if (nDex > data.nHitMod && GetIsFinessable(oItem)) data.nHitMod = nDex;
			if (GetHasFeat(1957, oPC, TRUE) && nInt > data.nAbilityDamMod) data.nAbilityDamMod = nInt; // combat insight
			if (GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oPC) > 2){
				int bInsightful = (IPGetWeaponSize(oItem) <= 2 || 
					nType == BASE_ITEM_RAPIER);
				if (data.bCritImmune && !GetHasFeat(2128, oPC, TRUE))
					bInsightful = FALSE;
				if (bInsightful) data.nAbilityDamMod += nInt;
			}
			int nPA = 0;
			if (GetActionMode(oPC, ACTION_MODE_IMPROVED_POWER_ATTACK)) nPA = 6;
			else if (GetActionMode(oPC, ACTION_MODE_POWER_ATTACK)) nPA = 3;
			data.nHitMod -= nPA;
			if (bIsTwoHand){
				data.nAbilityDamMod += data.nAbilityDamMod / 2;
				nPA *= 2;
			}
			nBonus += nPA;
			int nOtherMode = 0;
			if (GetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)) nOtherMode = 6;
			else if (GetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE)) nOtherMode = 3;
			else if (GetActionMode(oPC, ACTION_MODE_FLURRY_OF_BLOWS)) nOtherMode = 2;
			data.nHitMod -= nOtherMode;
			
			// is this a kensai or weapon master using their chosen weapon?
			int nWeapOfChoice = StringToInt(Get2DAString("baseitems", "FEATWpnOfChoice", nType));
			if (GetHasFeat(nWeapOfChoice, oPC, TRUE)){
				if (GetHasFeat(883, oPC, TRUE)) data.nCritMult += 1; // wm or kensai increase mult
				if (GetHasFeat(885, oPC, TRUE)) bKiCrit = TRUE; // wm ki crit, added later after keen check
			}
		} else { // ranged
			data.nHitMod = nDex;
			if (GetHasFeat(412, oPC, TRUE)){ // zen archery
				int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
				if (nWis > data.nHitMod) data.nHitMod = nWis;
			}
			if (GetActionMode(oPC, ACTION_MODE_RAPID_SHOT)) data.nHitMod -= 2;
		}
		data.nHitMod += ApplyFeatsToWeapon(oPC, oItem);
		data.nDam += ApplyDamageFeatsToWeapon(oPC, oItem);
	} else if (nType == BASE_ITEM_SMALLSHIELD){
		nNumDice = 1;
		nDicetype = 6;
	} else if (nType == BASE_ITEM_LARGESHIELD){
		nNumDice = 1;
		nDicetype = 10;
	} else if (nType == BASE_ITEM_TOWERSHIELD){
		nNumDice = 2;
		nDicetype = 6;
	} else {
		oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
		int nPCsize = GetCreatureSize(oPC);
		nNumDice = 1;
		if (nPCsize > 3) nDicetype = 10;
		else if (nPCsize < 3) nDicetype = 6;
		else nDicetype = 8;
		nBonus = GetArmorRank(oItem); // small damage bonus for armor type. cloth = 0, light = 1, etc
	}
	data.nDam += RollDice(nNumDice, nDicetype) + nBonus;
	
	// Now we search for enchantments that will fill out the rest of the data
	// Note that we no longer need the base item type, so we're repurposing the
	// variable nType to represent the item property type.
	int nAB = 0;
	int nEB = 0;	
	int nTempAb;
	int nTempEb;
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip)){
		nType = GetItemPropertyType(ip);
		nTempAb = 0;
		nTempEb = 0;
		if (bIsWeapon){
			if (nType == ITEM_PROPERTY_ENHANCEMENT_BONUS)
				nTempEb = GetItemPropertySubType(ip);
			else if  (nType == ITEM_PROPERTY_ATTACK_BONUS)
				nTempAb = GetItemPropertySubType(ip);
			else if (nType == ITEM_PROPERTY_DAMAGE_BONUS)
				data.nDam += GetDamageBonus(ip);
			else if (nType == ITEM_PROPERTY_KEEN && !bImpCrit)
				data.nCritRange *= 2;
			else if (nType == ITEM_PROPERTY_MIGHTY){
				int nMighty = GetItemPropertyCostTableValue(ip);
				if (nStr <= nMighty) data.nAbilityDamMod += nStr;
				else data.nAbilityDamMod += nStr;
			}
		} else {
			if (nType == ITEM_PROPERTY_AC_BONUS)
				nTempEb = GetItemPropertyCostTableValue(ip);
		}
		if (nTempEb > nEB) nEB = nTempAb;
		if (nTempAb > nAB) nAB = nTempEb;
        ip = GetNextItemProperty(oItem);
    }
	if (nAB > nEB) data.nPow = nAB;
	else data.nPow = nEB;
	data.nDam += nEB;
	
	// Now look for effects applied directly to the attacker that will modify the roll
	effect eEff = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEff)){
		nType = GetEffectType(eEff);
		if (nType == EFFECT_TYPE_ATTACK_INCREASE)
			data.nHitMod += GetEffectInteger(eEff, 0);
        else if (nType == EFFECT_TYPE_ATTACK_DECREASE)
			data.nHitMod -= GetEffectInteger(eEff, 0);
		eEff = GetNextEffect(oPC);
		
	}
	if (bKiCrit) data.nCritRange += 2;
	if (data.nPow > 5) data.nPow = 5;
	if (data.nPow < 0) data.nPow = 0;
	if (data.nDam < 0) data.nDam = 1;
    return data;
}

int GetDamageBonus(itemproperty ip){
	int nDam = GetItemPropertyCostTableValue(ip);
	switch (nDam){
		case IP_CONST_DAMAGEBONUS_1: return 1;
		case IP_CONST_DAMAGEBONUS_2: return 2;
		case IP_CONST_DAMAGEBONUS_3: return 3;
		case IP_CONST_DAMAGEBONUS_4: return 4;
		case IP_CONST_DAMAGEBONUS_5: return 5;
		case IP_CONST_DAMAGEBONUS_1d4: return d4(1);
		case IP_CONST_DAMAGEBONUS_1d6: return d6(1);
		case IP_CONST_DAMAGEBONUS_1d8: return d8(1);
		case IP_CONST_DAMAGEBONUS_1d10: return d10(1);
		case IP_CONST_DAMAGEBONUS_2d6: return d6(2);
		case IP_CONST_DAMAGEBONUS_2d8: return d8(2);
		case IP_CONST_DAMAGEBONUS_2d4: return d4(2);
		case IP_CONST_DAMAGEBONUS_2d10: return d10(2);
		case IP_CONST_DAMAGEBONUS_1d12: return d12(1);
		case IP_CONST_DAMAGEBONUS_2d12: return d12(2);
		case IP_CONST_DAMAGEBONUS_6: return 6;
		case IP_CONST_DAMAGEBONUS_7: return 7;
		case IP_CONST_DAMAGEBONUS_8: return 8;
		case IP_CONST_DAMAGEBONUS_9: return 9;
		case IP_CONST_DAMAGEBONUS_10: return 10;
		case IP_CONST_DAMAGEBONUS_3d10: return d10(3);
		case IP_CONST_DAMAGEBONUS_3d12: return d12(3);
		case IP_CONST_DAMAGEBONUS_4d6: return d6(4);
		case IP_CONST_DAMAGEBONUS_4d8: return d8(4);
		case IP_CONST_DAMAGEBONUS_4d10: return d10(4);
		case IP_CONST_DAMAGEBONUS_4d12: return d12(4);
		case IP_CONST_DAMAGEBONUS_5d6: return d6(5);
		case IP_CONST_DAMAGEBONUS_5d12: return d12(5);
		case IP_CONST_DAMAGEBONUS_6d12: return d12(6);
		case IP_CONST_DAMAGEBONUS_3d6: return d6(3);
		case IP_CONST_DAMAGEBONUS_6d6: return d6(6);
	}
	return 0;
}