#include "X0_I0_SPELLS"
#include "ps_inc_functions"

//-----------------------------------------------------------------------------
// Utility Functions
//-----------------------------------------------------------------------------
// limits a number so that it will be between nMin and nMax (inclusive)
int Limit(int nNumber, int nMin, int nMax)
{
    if(nNumber < nMin)
        return nMin;
    if(nNumber > nMax)
        return nMax;
    return nNumber;
}

// Links 3 effects together
effect EffectLinkEffects3(effect e1, effect e2, effect e3)
{
    return EffectLinkEffects(e1, EffectLinkEffects(e2, e3));
}

// Links 4 effects together
effect EffectLinkEffects4(effect e1, effect e2, effect e3, effect e4)
{
    return EffectLinkEffects(e1, EffectLinkEffects(e2, EffectLinkEffects(e3, e4)));
}


// Gets the number of bonus dice from 'epic' caster levels (caster levels beyond 20)
// Current formula is (caster levels beyond 20 / 2)
/*/ This excludes practiced spellcaster
int EpicCasterLevels(object oCaster)
{
    int nCasterLevel = PS_GetCasterLevel(oCaster);

    int nPracticedSpellcaster = FALSE;
    if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_BARD, oCaster))
        nPracticedSpellcaster = TRUE;
    if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_CLERIC, oCaster))
        nPracticedSpellcaster = TRUE;
    if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_DRUID, oCaster))
        nPracticedSpellcaster = TRUE;
    if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_PALADIN, oCaster))
        nPracticedSpellcaster = TRUE;
    if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_RANGER, oCaster))
        nPracticedSpellcaster = TRUE;
    if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_SORCERER, oCaster))
        nPracticedSpellcaster = TRUE;
    if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_WIZARD, oCaster))
        nPracticedSpellcaster = TRUE;
    if(GetHasFeat(2003, oCaster)) // spirit shaman
        nPracticedSpellcaster = TRUE;
    if(GetHasFeat(2068, oCaster)) // favored soul
        nPracticedSpellcaster = TRUE;
    // warlock 2484
    if(nPracticedSpellcaster)
        nCasterLevel -= 4;
    int nEpicLevelBonus = Limit(nCasterLevel-20, 0, 20) / 2;
    // SendMessageToPC(oCaster, "Caster Level:" + IntToString(nCasterLevel));
    // SendMessageToPC(oCaster, "Practiced Spellcaster: " + IntToString(nPracticedSpellcaster));
    // SendMessageToPC(oCaster, "Epic Levels: " + IntToString(nEpicLevels));
    return nEpicLevelBonus;
}*/

int GetSpellSchoolFromID(int nSpell)
{
    // TODO: maybe we want to cache these in memory?
    // I'm not sure what the current performance of 2da lookups is
    int nResult = 0;
    string sResult = Get2DAString("spells", "School", nSpell);
    if (sResult == "A")
        nResult = SPELL_SCHOOL_ABJURATION;
    else if (sResult == "C")
        nResult = SPELL_SCHOOL_CONJURATION;
    else if (sResult == "D")
        nResult = SPELL_SCHOOL_DIVINATION;
    else if (sResult == "E")
        nResult = SPELL_SCHOOL_ENCHANTMENT;
    else if (sResult == "V")
        nResult = SPELL_SCHOOL_EVOCATION;
    else if (sResult == "I")
        nResult = SPELL_SCHOOL_ILLUSION;
    else if (sResult == "N")
        nResult = SPELL_SCHOOL_NECROMANCY;
    else if (sResult == "T")
        nResult = SPELL_SCHOOL_TRANSMUTATION;
    return nResult;
}

// Returns the descriptive name from an ABILITY_* constant
string GetAbilityName(int nAbility)
{
    switch(nAbility)
    {
        case ABILITY_STRENGTH:
            return "Strength";
        case ABILITY_DEXTERITY:
            return "Dexterity";
        case ABILITY_CONSTITUTION:
            return "Constitution";
        case ABILITY_INTELLIGENCE:
            return "Intelligence";
        case ABILITY_WISDOM:
            return "Wisdom";
        case ABILITY_CHARISMA:
            return "Charisma";
        }
    return "Unknown";
}

// maps DAMAGE_TYPE_* values to their corresponding IP_CONST_DAMAGETYPE_*
int DamageTypeToIPConstDamageType(int nDamageType)
{
    switch(nDamageType)
    {
        case DAMAGE_TYPE_BLUDGEONING:
            return IP_CONST_DAMAGETYPE_BLUDGEONING;
        case DAMAGE_TYPE_PIERCING:
            return IP_CONST_DAMAGETYPE_PIERCING;
        case DAMAGE_TYPE_SLASHING:
            return IP_CONST_DAMAGETYPE_SLASHING;
        case DAMAGE_TYPE_MAGICAL:
            return IP_CONST_DAMAGETYPE_MAGICAL;
        case DAMAGE_TYPE_ACID:
            return IP_CONST_DAMAGETYPE_ACID;
        case DAMAGE_TYPE_COLD:
            return IP_CONST_DAMAGETYPE_COLD;
        case DAMAGE_TYPE_DIVINE:
            return IP_CONST_DAMAGETYPE_DIVINE;
        case DAMAGE_TYPE_ELECTRICAL:
            return IP_CONST_DAMAGETYPE_ELECTRICAL;
        case DAMAGE_TYPE_FIRE:
            return IP_CONST_DAMAGETYPE_FIRE;
        case DAMAGE_TYPE_NEGATIVE:
            return IP_CONST_DAMAGETYPE_NEGATIVE;
        case DAMAGE_TYPE_POSITIVE:
            return IP_CONST_DAMAGETYPE_POSITIVE;
        case DAMAGE_TYPE_SONIC:
            return IP_CONST_DAMAGETYPE_SONIC;
    }
    return 0;
}

// Attempts to get how much damage resistance oTarget has against DamageType
// Only returns the highest damage resistance - it doesn't care about the damage limit
// ie, if the target has resist 30 fire, but with 1 point remaining
// and resist 20 fire with 100 points remaining this will return 30
int GetDamageResistance(object oTarget, int nDamageType)
{
    int nDamageResist = 0;

    // Get Damage resistance from effects
    effect e = GetFirstEffect(oTarget);
    while(GetIsEffectValid(e))
    {
        if(GetEffectType(e) == EFFECT_TYPE_DAMAGE_RESISTANCE)
        {
            if(GetEffectInteger(e, 0) == nDamageType)
            {
                int nRes = GetEffectInteger(e, 1);
                if(nRes > nDamageResist)
                    nDamageResist = nRes;
            }
        }
        e = GetNextEffect(oTarget);
    }
    // Get Damage Resistance from items
    int i;
    for(i=0; i < 18; i++)
    {
        object oItem = GetItemInSlot(i, oTarget);
        if(GetIsObjectValid(oItem))
        {
            itemproperty ip = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ip))
            {
                if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_RESISTANCE)
                {
                    int subtype = GetItemPropertySubType(ip);
                    if(subtype == DamageTypeToIPConstDamageType(nDamageType))
                    {
                        int nRes = StringToInt(Get2DAString("iprp_resistcost", "Value", GetItemPropertyCostTableValue(ip)));
                        if(nRes > nDamageResist)
                            nDamageResist = nRes;
                    }
                }
                ip = GetNextItemProperty(oItem);
            }
        }
    }
    // We could loop through inventory as well to get the immunities from charms
    // That is probably too expensive tho.
    return nDamageResist;
}

// Attempts to get how much damage immunity oTarget has against DamageType
int GetDamageImmunity(object oTarget, int nDamageType)
{
    int nDamageImmunity = 0;

    // Get Damage immunity from effects
    effect e = GetFirstEffect(oTarget);
    while(GetIsEffectValid(e))
    {
        if(GetEffectType(e) == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE)
        {
            if(GetEffectInteger(e, 0) == nDamageType)
                nDamageImmunity += GetEffectInteger(e, 1);
        }
        else if(GetEffectType(e) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE)
        {
            if(GetEffectInteger(e, 0) == nDamageType)
                nDamageImmunity -= GetEffectInteger(e, 1);
        }
        e = GetNextEffect(oTarget);
    }
    
    // Figure out Damage immunity from equipped items
    int i;
    for(i=0; i < 18; i++)
    {
        object oItem = GetItemInSlot(i, oTarget);
        if(GetIsObjectValid(oItem))
        {
            itemproperty ip = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ip))
            {
                if(GetItemPropertyType(ip) == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE)
                {
                    int subtype = GetItemPropertySubType(ip);
                    if(subtype == DamageTypeToIPConstDamageType(nDamageType))
                    {
                        int nImmu = StringToInt(Get2DAString("iprp_immuncost", "Value", GetItemPropertyCostTableValue(ip)));
                        nDamageImmunity += nImmu;
                    }
                }
                else if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_VULNERABILITY)
                {
                    int subtype = GetItemPropertySubType(ip);
                    if(subtype == DamageTypeToIPConstDamageType(nDamageType))
                    {
                        int nImmu = StringToInt(Get2DAString("iprp_immuncost", "Value", GetItemPropertyCostTableValue(ip)));
                        nDamageImmunity -= nImmu;
                    }
                }
                ip = GetNextItemProperty(oItem);
            }
        }
    }
    // We could loop through inventory as well to get the immunities from charms
    // That is probably too expensive tho.
    return nDamageImmunity;
}

// General purpose dice rolling function that also handles metamagic
int RollDamage(int nDice, int nDiceType, int nFlatDamagePerDice, int nFlatDamage, int nMetamagic)
{
    if(nMetamagic == METAMAGIC_MAXIMIZE)
        return nFlatDamage + ((nDiceType + nFlatDamagePerDice) * nDice);

    int nRolled = 0;
    int nFlat = nFlatDamage + (nFlatDamagePerDice * nDice);

    int i;
    for(i=0; i<nDice; i++)
    {
        nRolled += 1 + Random(nDiceType);
    }

    int nTotal = nFlat + nRolled;

    if(nMetamagic == METAMAGIC_EMPOWER)
    {
        // Technically empower should only apply to damage if there is a dice roll
        // but that may not be what players expect. We'll empower even static dmg spells
        nTotal = nTotal + (nTotal / 2);
    }
    return nTotal;
}

// Does an ability score check against the target dc
// oTarget's d20 + ability score modifier vs DC
// DC of the ability score check. The dc is the target's score in that ability.
// nDC -1 indicates an opposed check vs the caster's stat
// Returns: 1 if the target succeeds
int AbilityScoreCheck(object oCaster, object oTarget, int nAbilityScore, int nDC)
{
    int nMod = (GetAbilityScore(oTarget, nAbilityScore) - 10) / 2;
    int nRoll = d20();
    int nCasterMod = (nDC - 10) / 2;
    int nCasterRoll = d20();
    if(nDC == -1)
    {
        // Opposed check versus the caster's stat
        // target's strength vs caster's strength, for instance
        nCasterMod = (GetAbilityScore(oCaster, nAbilityScore) - 10) / 2;
    }
    if(GetIsPC(oTarget))
        SendMessageToPC(oTarget, "Rolling " + GetAbilityName(nAbilityScore) + ": Roll(" + IntToString(nRoll) + ") + " + IntToString(nMod) + " = " + IntToString(nRoll+nMod) + " vs Roll(" + IntToString(nCasterRoll) + ") + " + IntToString(nCasterMod) + " = " + IntToString(nCasterRoll+nCasterMod));
    SendMessageToPC(oCaster, GetName(oTarget) + " rolling " + GetAbilityName(nAbilityScore) + ": Roll(" + IntToString(nRoll) + ") + " + IntToString(nMod) + " = " + IntToString(nRoll+nMod) + " vs Roll(" + IntToString(nCasterRoll) + ") + " + IntToString(nCasterMod) + " = " + IntToString(nCasterRoll+nCasterMod));
    if(nRoll + nMod >= nCasterMod + nCasterRoll)
        return 1;
    return 0;
}

// Returns the number of spell targets in the area
// objectType=OBJECT_TYPE_CREATURE
// targetType=SPELL_TARGET_STANDARDHOSTILE
int GetSpellTargetCountInArea(int shape, float radius, location loc, int lineOfSight, object caster, int objectType, int targetType)
{
    int count = 0;
    object oTarget = GetFirstObjectInShape(shape, radius, loc, lineOfSight, objectType);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, targetType, caster))
            count++;
        oTarget = GetNextObjectInShape(shape, radius, loc, lineOfSight, objectType);
    }
    return count;
}

// Check to see if an effect has been created or if it is still blank
int GetIsEffectNull(effect e)
{
    // compare against a blank effect
    effect eUnset;
    if(e == eUnset)
        return TRUE;
    return FALSE;
}

// Does the target have any spell mantles? used mainly for missile code
int TargetHasMantle(object oTarget)
{
	effect eMantle = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eMantle))
    {
        if(GetEffectSpellId(eMantle) == SPELL_LEAST_SPELL_MANTLE ||
		   GetEffectSpellId(eMantle) == SPELL_LESSER_SPELL_MANTLE ||
		   GetEffectSpellId(eMantle) == SPELL_SPELL_MANTLE ||
		   GetEffectSpellId(eMantle) == SPELL_GREATER_SPELL_MANTLE)
            return TRUE;
        eMantle = GetNextEffect(oTarget);
    }
    return FALSE;
}

// Applies the effect as a INSTANT or TEMPORARY effect based on wether fDuration is 0 or not
void ApplyTempOrInstantEffect(object oTarget, effect eEffect, float fDelay, float fDuration=0.0f)
{
    if(fDuration <= 0.0f)
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget));
    else
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration));
}

// Creates a damage effect
// Created to handle some damage piercing stuff by looking at oCaster's feats
// It can also modify & increase the spell damage
// Passes the call to EffectElementalPiercingDamage which handles the creation of the effects
effect GetDamageEffect(object oCaster, int nDamageType, int nDamageAmount, int nDamagePower=DAMAGE_POWER_NORMAL)
{
    int nPiercing = 0;
    // Frostmage isn't in... but this is an example of how to do it
    // int FEAT_FROSTMAGE_PIERCING_COLD = 3285;
    // if(GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD, oCaster) && nDamageType == DAMAGE_TYPE_COLD)
    //     nPiercing = 100;
    return PS_EffectDamagePiercing(nDamageAmount, nDamageType, nDamagePower, nPiercing);
}


