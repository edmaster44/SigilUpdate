#include "ps_inc_functions"

const int EXPERIMENTAL_EFFECTS_GOOD = 55;
const int EXPERIMENTAL_EFFECTS_BAD = 31;
const int EXPERIMENTAL_SPELLEFFECTS_GOOD = 70;
const int EXPERIMENTAL_SPELLEFFECTS_BAD = 75;

const int SPELL_TYPE_SINGLE_INSTANT = 0;
const int SPELL_TYPE_AOE = 1;

//returns a generally good effect
effect GetHelpfulEffect(object oPC, int nLevel = 1, int nIndex = -1) {
	
	int nTotal = EXPERIMENTAL_EFFECTS_GOOD;
	if (nIndex < 1)
		nIndex = Random(nTotal)+1;
	switch (nIndex) {
		case 1: SendMessageToPC(oPC, "You instantly feel stronger."); return EffectAbilityIncrease(0, nLevel*2);
		case 2: SendMessageToPC(oPC, "You instantly feel more agile."); return EffectAbilityIncrease(1, nLevel*2);
		case 3: SendMessageToPC(oPC, "You instantly feel healthier."); return EffectAbilityIncrease(2, nLevel*2);
		case 4: SendMessageToPC(oPC, "You instantly feel smarter."); return EffectAbilityIncrease(3, nLevel*2);
		case 5: SendMessageToPC(oPC, "You instantly feel wiser."); return EffectAbilityIncrease(4, nLevel*2);
		case 6: SendMessageToPC(oPC, "You instantly feel more confident."); return EffectAbilityIncrease(5, nLevel*2);
		case 7: SendMessageToPC(oPC, "You notice that enemies are hitting you less frequently."); return EffectACIncrease(nLevel);
		case 8: SendMessageToPC(oPC, "You execute attacks more effectively."); return EffectAttackIncrease(nLevel);
		case 9: SendMessageToPC(oPC, "You instantly feel more durable."); return EffectTemporaryHitpoints(10*nLevel);
		case 10: SendMessageToPC(oPC, "You become harder to see."); return EffectConcealment(5*nLevel);
		case 11: SendMessageToPC(oPC, "Your blows hit harder."); return EffectDamageIncrease(nLevel);
		case 12: SendMessageToPC(oPC, "Your blows hit harder."); return EffectDamageIncrease(DAMAGE_BONUS_1d4);
		case 13: SendMessageToPC(oPC, "You become more resistant to acid."); return EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 5*nLevel);
		case 14: SendMessageToPC(oPC, "You become more resistant to cold."); return EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 5*nLevel);
		case 15: SendMessageToPC(oPC, "You become more resistant to electricity."); return EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 5*nLevel);
		case 16: SendMessageToPC(oPC, "You become more resistant to fire."); return EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 5*nLevel);
		case 17: SendMessageToPC(oPC, "You become more resistant to sonic."); return EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 5*nLevel);
		case 18: SendMessageToPC(oPC, "You start sensing the spirits around you."); return EffectDetectSpirits();
		case 19: SendMessageToPC(oPC, "Your start sensing the undead around you."); return EffectDetectUndead();
		case 20: SendMessageToPC(oPC, "You become invisible to those who would harm you."); return EffectEthereal();
		case 21: SendMessageToPC(oPC, "You become faster."); return EffectHaste();
		case 22: SendMessageToPC(oPC, "You vanish from sight."); return EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
		case 23: SendMessageToPC(oPC, "Your wounds begin to heal faster."); return EffectRegenerate(nLevel, 6.0f);
		case 24: SendMessageToPC(oPC, "Your wounds begin to heal faster.");return EffectRegenerate(nLevel, 60.0f);
		case 25: SendMessageToPC(oPC, "You start noticing things which were before invisible.");return EffectSeeInvisible();
		case 26: SendMessageToPC(oPC, "You become more skilled."); return EffectSkillIncrease(SKILL_ALL_SKILLS, nLevel);
		case 27: SendMessageToPC(oPC, "You become more skilled in appraisal."); return EffectSkillIncrease(SKILL_APPRAISE, nLevel);
		case 28: SendMessageToPC(oPC, "You become more skilled in bluffing"); return EffectSkillIncrease(SKILL_BLUFF, nLevel);
		case 29: SendMessageToPC(oPC, "You become more skilled in concentration."); return EffectSkillIncrease(SKILL_CONCENTRATION, nLevel);
		case 30: SendMessageToPC(oPC, "You become more skilled in alchemy."); return EffectSkillIncrease(SKILL_CRAFT_ALCHEMY, nLevel);
		case 31: SendMessageToPC(oPC, "You become more skilled in crafting armor."); return EffectSkillIncrease(SKILL_CRAFT_ARMOR, nLevel);
		case 32: SendMessageToPC(oPC, "You become more skilled in crafting traps."); return EffectSkillIncrease(SKILL_CRAFT_TRAP, nLevel);
		case 33: SendMessageToPC(oPC, "You become more skilled in crafting weapons."); return EffectSkillIncrease(SKILL_CRAFT_WEAPON, nLevel);
		case 34: SendMessageToPC(oPC, "You become more skilled in diplomacy."); return EffectSkillIncrease(SKILL_DIPLOMACY, nLevel);
		case 35: SendMessageToPC(oPC, "You become more skilled in mechanics."); return EffectSkillIncrease(SKILL_DISABLE_TRAP, nLevel);
		case 36: SendMessageToPC(oPC, "You become more skilled in healing."); return EffectSkillIncrease(SKILL_HEAL, nLevel);
		case 37: SendMessageToPC(oPC, "You become more skilled in hiding."); return EffectSkillIncrease(SKILL_HIDE, nLevel);
		case 38: SendMessageToPC(oPC, "You become more skilled in intimidation."); return EffectSkillIncrease(SKILL_INTIMIDATE, nLevel);
		case 39: SendMessageToPC(oPC, "You become more skilled in listening."); return EffectSkillIncrease(SKILL_LISTEN, nLevel);
		case 40: SendMessageToPC(oPC, "You become more skilled in lore."); return EffectSkillIncrease(SKILL_LORE, nLevel);
		case 41: SendMessageToPC(oPC, "You become more skilled in moving silently."); return EffectSkillIncrease(SKILL_MOVE_SILENTLY, nLevel);
		case 42: SendMessageToPC(oPC, "You become more skilled in opening locks."); return EffectSkillIncrease(SKILL_OPEN_LOCK, nLevel);
		case 43: SendMessageToPC(oPC, "You become more skilled in parrying."); return EffectSkillIncrease(SKILL_PARRY, nLevel);
		case 44: SendMessageToPC(oPC, "You become more skilled in performing."); return EffectSkillIncrease(SKILL_PERFORM, nLevel);
		case 45: SendMessageToPC(oPC, "You become more skilled in searching."); return EffectSkillIncrease(SKILL_SEARCH, nLevel);
		case 46: SendMessageToPC(oPC, "You become more skilled in setting traps."); return EffectSkillIncrease(SKILL_SET_TRAP, nLevel);
		case 47: SendMessageToPC(oPC, "You become more skilled in sleight of hand."); return EffectSkillIncrease(SKILL_SLEIGHT_OF_HAND, nLevel);
		case 48: SendMessageToPC(oPC, "You become more skilled in spellcraft."); return EffectSkillIncrease(SKILL_SPELLCRAFT, nLevel);
		case 49: SendMessageToPC(oPC, "You become more skilled in spotting things."); return EffectSkillIncrease(SKILL_SPOT, nLevel);
		case 50: SendMessageToPC(oPC, "You become more skilled in surviving in the wild."); return EffectSkillIncrease(SKILL_SURVIVAL, nLevel);
		case 51: SendMessageToPC(oPC, "You become more skilled in taunting."); return EffectSkillIncrease(SKILL_TAUNT, nLevel);
		case 52: SendMessageToPC(oPC, "You become more skilled in tumbling."); return EffectSkillIncrease(SKILL_TUMBLE, nLevel);
		case 53: SendMessageToPC(oPC, "You become more skilled in fooling magical items."); return EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, nLevel);
		case 54: SendMessageToPC(oPC, "You become more resistant to magic."); return EffectSpellResistanceIncrease(10+(5*nLevel));
	}
	return EffectAttackIncrease(nLevel);
}

//Returns a harmful effect
effect GetHarmfulEffect(object oPC, int nLevel = 1, int nIndex = -1) {

	int nTotal = EXPERIMENTAL_EFFECTS_BAD;
	if (nIndex < 1)
		nIndex = Random(nTotal)+1;
	switch (nIndex) {
		case 1: SendMessageToPC(oPC, "You feel weak."); return EffectAbilityDecrease(0, nLevel*2);
		case 2: SendMessageToPC(oPC, "You feel less agile."); return EffectAbilityDecrease(1, nLevel*2);
		case 3: SendMessageToPC(oPC, "You feel sick."); return EffectAbilityDecrease(2, nLevel*2);
		case 4: SendMessageToPC(oPC, "You feel less intelligent."); return EffectAbilityDecrease(3, nLevel*2);
		case 5: SendMessageToPC(oPC, "You feel like there is a fog over your mind."); return EffectAbilityDecrease(4, nLevel*2);
		case 6: SendMessageToPC(oPC, "You feel less confident."); return EffectAbilityDecrease(5, nLevel*2);
		case 7: SendMessageToPC(oPC, "You notice enemies hit you more often."); return EffectACDecrease(nLevel);
		case 8: SendMessageToPC(oPC, "Your blows land less often."); return EffectAttackDecrease(nLevel);
		case 9: SendMessageToPC(oPC, "You cannot see."); return EffectNewBlindness();
		case 10: SendMessageToPC(oPC, "You feel confused."); return EffectConfused();
		case 11: SendMessageToPC(oPC, "Your blows are weak."); return EffectDamageDecrease(nLevel);
		case 12: SendMessageToPC(oPC, "Your blows are weak."); return EffectDamageDecrease(4);
		case 13: SendMessageToPC(oPC, "You become vulnerable to acid."); return EffectDamageImmunityDecrease(DAMAGE_TYPE_ACID, 5*nLevel);
		case 14: SendMessageToPC(oPC, "You become vulnerable to cold."); return EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, 5*nLevel);
		case 15: SendMessageToPC(oPC, "You become vulnerable to electrical."); return EffectDamageImmunityDecrease(DAMAGE_TYPE_ELECTRICAL, 5*nLevel);
		case 16: SendMessageToPC(oPC, "You become vulnerable to fire."); return EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 5*nLevel);
		case 17: SendMessageToPC(oPC, "You become vulnerable to sonic."); return EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, 5*nLevel);
		case 18: SendMessageToPC(oPC, "You are cursed!"); return EffectCurse(2*nLevel, 0, 0, 0, 0, 2*nLevel);
		case 19: SendMessageToPC(oPC, "You are cursed!"); return EffectCurse(0, 2*nLevel, 0, 0, 2*nLevel, 0);
		case 20: SendMessageToPC(oPC, "You are cursed!"); return EffectCurse(0, 0, 2*nLevel, 2*nLevel, 0, 0);
		case 21: SendMessageToPC(oPC, "You feel dazed."); return EffectDazed();
		case 22: SendMessageToPC(oPC, "You cannot hear."); return EffectDeaf();
		case 23: SendMessageToPC(oPC, "Your wounds refuse to heal."); return EffectDamageOverTime(nLevel, 6.0f);
		case 24: SendMessageToPC(oPC, "Your wounds refuse to heal."); return EffectDamageOverTime(nLevel, 60.0f);
		case 25: SendMessageToPC(oPC, "Enemies find you wherever you hide."); return EffectConcealmentNegated();
		case 26: SendMessageToPC(oPC, "You become less skilled"); return EffectSkillDecrease(SKILL_ALL_SKILLS, nLevel);
		case 27: SendMessageToPC(oPC, "You become less resistant to magic."); return EffectSpellResistanceDecrease(10+(5*nLevel));
		case 28: SendMessageToPC(oPC, "You are stunned!"); return EffectStunned();
		case 29: SendMessageToPC(oPC, "You fall asleep."); return EffectSleep();
		case 30: SendMessageToPC(oPC, "Your feet feel like lead."); return EffectSlow();
		case 31: SendMessageToPC(oPC, "You cannot move!"); return EffectParalyze(10+(5*nLevel), SAVING_THROW_FORT);
	}
	return EffectAttackDecrease(nLevel);
	
}

string GetExperimentalEffectName(int nGood, int nBad) {

	string sName = "";
	//First part of description is always the bad thing
	switch (nBad) {
		case 1: sName += "Weak"; break;
		case 2: sName += "Clumsy"; break;
		case 3: sName += "Sickly"; break;
		case 4: sName += "Dull"; break;
		case 5: sName += "Dumb"; break;
		case 6: sName += "Ugly"; break;
		case 7: sName += "Unlucky"; break;
		case 8: sName += "Unlucky"; break;
		case 9: sName += "Blind"; break;
		case 10: sName += "Confused"; break;
		case 11: sName += "Ineffective"; break;
		case 12: sName += "Ineffective"; break;
		case 13: sName += "Corroded"; break;
		case 14: sName += "Frozen"; break;
		case 15: sName += "Shocked"; break;
		case 16: sName += "Burned"; break;
		case 17: sName += "Deafened"; break;
		case 18: sName += "Accursed"; break;
		case 19: sName += "Accursed"; break;
		case 20: sName += "Accursed"; break;
		case 21: sName += "Dazed"; break;
		case 22: sName += "Deaf"; break;
		case 23: sName += "Wounded"; break;
		case 24: sName += "Wounded"; break;
		case 25: sName += "Exposed"; break;
		case 26: sName += "Unskilled"; break;
		case 27: sName += "Vulnerable"; break;
		case 28: sName += "Stunned"; break;
		case 29: sName += "Sleepy"; break;
		case 30: sName += "Slowed"; break;
		case 31: sName += "Paralyzed"; break;
		case 32: sName += "Acidic"; break;
		case 33: sName += "Blunt"; break;
		case 34: sName += "Icey"; break;
		case 35: sName += "Divine"; break;
		case 36: sName += "Shocking"; break;
		case 37: sName += "Firey"; break;
		case 38: sName += "Magical"; break;
		case 39: sName += "Piercing"; break;
		case 40: sName += "Slashing"; break;
		case 41: sName += "Thunderous"; break;
		case 42: sName += "Acidic"; break;
		case 43: sName += "Blunt"; break;
		case 44: sName += "Icey"; break;
		case 45: sName += "Divine"; break;
		case 46: sName += "Shocking"; break;
		case 47: sName += "Firey"; break;
		case 48: sName += "Magical"; break;
		case 49: sName += "Piercing"; break;
		case 50: sName += "Slashing"; break;
		case 61: sName += "Thunderous"; break;
		case 62: sName += "Acidic"; break;
		case 63: sName += "Blunt"; break;
		case 64: sName += "Icey"; break;
		case 65: sName += "Divine"; break;
		case 66: sName += "Shocking"; break;
		case 67: sName += "Firey"; break;
		case 68: sName += "Magical"; break;
		case 69: sName += "Piercing"; break;
		case 70: sName += "Slashing"; break;
		case 71: sName += "Thunderous"; break;
		case 72: sName += "Insane"; break;
		case 73: sName += "Fearful"; break;
		case 74: sName += "Deadly"; break;
		case 75: sName += "Silent"; break;
	}
	
	//Second word is the good effect
	switch (nGood) {
		case 1: sName += " Strength"; break;
		case 2: sName += " Agility"; break;
		case 3: sName += " Health"; break;
		case 4: sName += " Intelligence"; break;
		case 5: sName += " Wisdom"; break;
		case 6: sName += " Charisma"; break;
		case 7: sName += " Mobility"; break;
		case 8: sName += " Attacks"; break;
		case 9: sName += " Durability"; break;
		case 10: sName += " Concealment"; break;
		case 11: sName += " Keenness"; break;
		case 12: sName += " Keenness"; break;
		case 13: sName += " Acid Resistance"; break;
		case 14: sName += " Cold Resistance"; break;
		case 15: sName += " Electrical Resistance"; break;
		case 16: sName += " Fire Resistance"; break;
		case 17: sName += " Sonic Resistance"; break;
		case 18: sName += " Spirit Sense"; break;
		case 19: sName += " Undead Sense"; break;
		case 20: sName += " Sanctuary"; break;
		case 21: sName += " Haste"; break;
		case 22: sName += " Invisibility"; break;
		case 23: sName += " Regeneration"; break;
		case 24: sName += " Regeneration"; break;
		case 25: sName += " Sight"; break;
		case 26: sName += " Skill"; break;
		case 27: sName += " Appraisal"; break;
		case 28: sName += " Bluffing"; break;
		case 29: sName += " Concentration"; break;
		case 30: sName += " Alchemy"; break;
		case 31: sName += " Crafting Armor"; break;
		case 32: sName += " Crafting Traps"; break;
		case 33: sName += " Crafting Weapons"; break;
		case 34: sName += " Diplomacy"; break;
		case 35: sName += " Mechanics"; break;
		case 36: sName += " Healing"; break;
		case 37: sName += " Hiding"; break;
		case 38: sName += " Intimidation"; break;
		case 39: sName += " Listening"; break;
		case 40: sName += " Lore"; break;
		case 41: sName += " Moving Silently"; break;
		case 42: sName += " Opening Locks"; break;
		case 43: sName += " Parrying"; break;
		case 44: sName += " Performing"; break;
		case 45: sName += " Searching"; break;
		case 46: sName += " Setting Traps"; break;
		case 47: sName += " Sleight of Hand"; break;
		case 48: sName += " Spellcraft"; break;
		case 49: sName += " Spot"; break;
		case 50: sName += " Survival"; break;
		case 51: sName += " Taunt"; break;
		case 52: sName += " Tumbling"; break;
		case 53: sName += " Magical Acumen"; break;
		case 54: sName += " Spell Resistance"; break;
		case 55: sName += " Corrosive Shield"; break;
		case 56: sName += " Icey Shield"; break;
		case 57: sName += " Electrical Shield"; break;
		case 58: sName += " Firey Shield"; break;
		case 59: sName += " Solid Shield"; break;
		case 60: sName += " Piercing Shield"; break;
		case 61: sName += " Bladed Shield"; break;
		case 62: sName += " Healing"; break;
		case 63: sName += " Healing"; break;
		case 64: sName += " Healing"; break;
		case 65: sName += " Healing"; break;
		case 66: sName += " Healing"; break;
		case 67: sName += " Healing"; break;
		case 68: sName += " Spell Shield"; break;
		case 69: sName += " Spell Shield"; break;
		case 70: sName += " Spell Shield"; break;
	}
	return sName;
}

//Uses GetHarmfulEffect + a few extra bad effects, and applies them to the target
void ApplyExperimentalSpellEffectGood(object oTarget, int nLevel = 1, int nIndex = -1) {
	effect eEffect;
	float fDuration = 6.0f*(nLevel*3); //3-9 rounds
	int nDurationType = DURATION_TYPE_INSTANT;
	
	//starting index is 55
	switch (nIndex) {
		case 55: SendMessageToPC(oTarget, "You are surrounded by a shield of corrosive energy."); eEffect = EffectDamageShield(nLevel, DAMAGE_BONUS_1d4, DAMAGE_TYPE_ACID); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 56: SendMessageToPC(oTarget, "You are surrounded by a shield of icey energy."); eEffect = EffectDamageShield(nLevel, DAMAGE_BONUS_1d4, DAMAGE_TYPE_COLD); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 57: SendMessageToPC(oTarget, "You are surrounded by a shield of electrical energy."); eEffect = EffectDamageShield(nLevel, DAMAGE_BONUS_1d4, DAMAGE_TYPE_ELECTRICAL); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 58: SendMessageToPC(oTarget, "You are surrounded by a shield of firey energy."); eEffect = EffectDamageShield(nLevel, DAMAGE_BONUS_1d4, DAMAGE_TYPE_FIRE); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 59: SendMessageToPC(oTarget, "You are surrounded by a shield of sonic energy."); eEffect = EffectDamageShield(nLevel, DAMAGE_BONUS_1d4, DAMAGE_TYPE_SONIC); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 60: SendMessageToPC(oTarget, "You are surrounded by a shield of blunt objects."); eEffect = EffectDamageShield(nLevel, DAMAGE_BONUS_1d4, DAMAGE_TYPE_BLUDGEONING); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 61: SendMessageToPC(oTarget, "You are surrounded by a shield of sharp objects."); eEffect = EffectDamageShield(nLevel, DAMAGE_BONUS_1d4, DAMAGE_TYPE_PIERCING); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 62: SendMessageToPC(oTarget, "You are surrounded by a shield of slashing blades."); eEffect = EffectDamageShield(nLevel, DAMAGE_BONUS_1d4, DAMAGE_TYPE_SLASHING); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 63: eEffect = EffectHeal(d8(nLevel)); nDurationType = DURATION_TYPE_INSTANT; break;
		case 64: eEffect = EffectHeal(d8(nLevel*3)); nDurationType = DURATION_TYPE_INSTANT; break;
		case 65: eEffect = EffectHeal(d8(nLevel*6)); nDurationType = DURATION_TYPE_INSTANT; break;
		case 66: eEffect = EffectHeal(d8(nLevel*9)); nDurationType = DURATION_TYPE_INSTANT; break;
		case 67: eEffect = EffectHeal(d8(nLevel*12)); nDurationType = DURATION_TYPE_INSTANT; break;
		case 68: SendMessageToPC(oTarget, "You are temporarily able to absorb spells of the "+IntToString(nLevel)+" tier"); eEffect = EffectSpellLevelAbsorption(nLevel, nLevel*3); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 69: SendMessageToPC(oTarget, "You are temporarily able to absorb spells of the "+IntToString(nLevel+1)+" tier");  eEffect = EffectSpellLevelAbsorption(nLevel+1, nLevel*6); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 70: SendMessageToPC(oTarget, "You are temporarily able to absorb spells of the "+IntToString(nLevel+2)+" tier"); eEffect = EffectSpellLevelAbsorption(nLevel+2, nLevel*9); nDurationType = DURATION_TYPE_TEMPORARY; break;
		//for everything less than 55
		default: eEffect = GetHelpfulEffect(oTarget, nLevel, nIndex); nDurationType = DURATION_TYPE_TEMPORARY; break; 
	}
	
	ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
}		
		
//Uses GetHarmfulEffect + a few extra bad effects, and applies them to the target
void ApplyExperimentalSpellEffectBad(object oTarget, int nLevel = 1, int nIndex = -1) {

	effect eEffect;
	float fDuration = 6.0f*(nLevel*3); //3-9 rounds
	int nDurationType = DURATION_TYPE_INSTANT;
	
	//starting index is 32
	switch (nIndex) {
		case 32: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_ACID); nDurationType = DURATION_TYPE_INSTANT; break;
		case 33: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_BLUDGEONING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 34: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_COLD); nDurationType = DURATION_TYPE_INSTANT; break;
		case 35: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_DIVINE); nDurationType = DURATION_TYPE_INSTANT; break;
		case 36: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_ELECTRICAL); nDurationType = DURATION_TYPE_INSTANT; break;
		case 37: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_FIRE); nDurationType = DURATION_TYPE_INSTANT; break;
		case 38: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_MAGICAL); nDurationType = DURATION_TYPE_INSTANT; break;
		case 39: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_PIERCING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 40: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_SLASHING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 41: eEffect = EffectDamage(d8(nLevel), DAMAGE_TYPE_SONIC); nDurationType = DURATION_TYPE_INSTANT; break;
		case 42: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_ACID); nDurationType = DURATION_TYPE_INSTANT; break;
		case 43: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_BLUDGEONING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 44: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_COLD); nDurationType = DURATION_TYPE_INSTANT; break;
		case 45: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_DIVINE); nDurationType = DURATION_TYPE_INSTANT; break;
		case 46: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_ELECTRICAL); nDurationType = DURATION_TYPE_INSTANT; break;
		case 47: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_FIRE); nDurationType = DURATION_TYPE_INSTANT; break;
		case 48: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_MAGICAL); nDurationType = DURATION_TYPE_INSTANT; break;
		case 49: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_PIERCING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 50: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_SLASHING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 51: eEffect = EffectDamage(d8(nLevel*3), DAMAGE_TYPE_SONIC); nDurationType = DURATION_TYPE_INSTANT; break;
		case 52: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_ACID); nDurationType = DURATION_TYPE_INSTANT; break;
		case 53: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_BLUDGEONING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 54: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_COLD); nDurationType = DURATION_TYPE_INSTANT; break;
		case 55: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_DIVINE); nDurationType = DURATION_TYPE_INSTANT; break;
		case 56: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_ELECTRICAL); nDurationType = DURATION_TYPE_INSTANT; break;
		case 57: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_FIRE); nDurationType = DURATION_TYPE_INSTANT; break;
		case 58: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_MAGICAL); nDurationType = DURATION_TYPE_INSTANT; break;
		case 59: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_PIERCING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 60: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_SLASHING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 61: eEffect = EffectDamage(d8(nLevel*6), DAMAGE_TYPE_SONIC); nDurationType = DURATION_TYPE_INSTANT; break;
		case 62: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_ACID); nDurationType = DURATION_TYPE_INSTANT; break;
		case 63: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_BLUDGEONING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 64: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_COLD); nDurationType = DURATION_TYPE_INSTANT; break;
		case 65: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_DIVINE); nDurationType = DURATION_TYPE_INSTANT; break;
		case 66: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_ELECTRICAL); nDurationType = DURATION_TYPE_INSTANT; break;
		case 67: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_FIRE); nDurationType = DURATION_TYPE_INSTANT; break;
		case 68: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_MAGICAL); nDurationType = DURATION_TYPE_INSTANT; break;
		case 69: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_PIERCING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 70: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_SLASHING); nDurationType = DURATION_TYPE_INSTANT; break;
		case 71: eEffect = EffectDamage(d8(nLevel*9), DAMAGE_TYPE_SONIC); nDurationType = DURATION_TYPE_INSTANT; break;
		case 72: eEffect = EffectInsane(); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 73: eEffect = EffectFrightened(); nDurationType = DURATION_TYPE_TEMPORARY; break;
		case 74: eEffect = EffectDeath(); nDurationType = DURATION_TYPE_INSTANT; break;
		case 75: eEffect = EffectSilence(); nDurationType = DURATION_TYPE_TEMPORARY; break;
		//for everything less than 32
		default: eEffect = GetHarmfulEffect(oTarget, nLevel, nIndex); nDurationType = DURATION_TYPE_TEMPORARY; break; 
	}
	
	ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
}