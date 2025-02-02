#include "ff_safevar"

/*
   ----------------
   Null Psionics Field - OnEnter

   psi_pow_npfent
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Null Psionics Field - OnEnter

    Psychokinesis
    Level: Kineticist 6
    Manifesting Time: 1 standard action
    Range: 10 ft.
    Area: 10-ft.-radius emanation centered on you
    Duration: 10 min./level(D)
    Saving Throw: None
    Power Resistance: See text
    Power Points: 11
    Metapsionics: Extend, Widen
    
    An invisible barrier surrounds you and moves with you. The space within this 
    barrier is impervious to most psionic effects, including powers, psi-like 
    abilities, and supernatural abilities. Likewise, it prevents the functioning 
    of any psionic items or powers within its confines. A null psionics field 
    negates any power or psionic effect used within, brought into, or manifested 
    into its area.
    
    Dispel psionics does not remove the field. Two or more null psionics fields 
    sharing any of the same space have no effect on each other. Certain powers 
    may be unaffected by null psionics field (see the individual power 
    descriptions).
    
    
    Implementation note: To dismiss the power, use the control feat again. If 
                         the power is active, that will end it instead of 
                         manifesting it.
*/

//#include "prc_alterations"

void RemoveEffectsNPF(object oObject)
{
    effect eEff = GetFirstEffect(oObject);
    while(GetIsEffectValid(eEff))
    {
        int nType = GetEffectType(eEff);
        if(GetEffectSubType(eEff) != SUBTYPE_EXTRAORDINARY &&
           (nType == EFFECT_TYPE_ABILITY_INCREASE          ||
            nType == EFFECT_TYPE_AC_INCREASE               ||
            nType == EFFECT_TYPE_ATTACK_INCREASE           ||
            nType == EFFECT_TYPE_BLINDNESS                 ||
            nType == EFFECT_TYPE_CHARMED                   ||
            nType == EFFECT_TYPE_CONCEALMENT               ||
            nType == EFFECT_TYPE_CONFUSED                  ||
            nType == EFFECT_TYPE_CURSE                     ||
            nType == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE  ||
            nType == EFFECT_TYPE_DAMAGE_INCREASE           ||
            nType == EFFECT_TYPE_DAMAGE_REDUCTION          ||
            nType == EFFECT_TYPE_DAMAGE_RESISTANCE         ||
            nType == EFFECT_TYPE_DAZED                     ||
            nType == EFFECT_TYPE_DEAF                      ||
            nType == EFFECT_TYPE_DOMINATED                 ||
            nType == EFFECT_TYPE_ELEMENTALSHIELD           ||
            nType == EFFECT_TYPE_ETHEREAL                  ||
            nType == EFFECT_TYPE_FRIGHTENED                ||
            nType == EFFECT_TYPE_HASTE                     ||
            nType == EFFECT_TYPE_IMMUNITY                  ||
            nType == EFFECT_TYPE_GREATERINVISIBILITY      ||
            nType == EFFECT_TYPE_INVISIBILITY              ||
            nType == EFFECT_TYPE_INVULNERABLE              ||
            nType == EFFECT_TYPE_ABILITY_INCREASE          ||
            nType == EFFECT_TYPE_NEGATIVELEVEL             ||
            nType == EFFECT_TYPE_PARALYZE                  ||
            nType == EFFECT_TYPE_POLYMORPH                 ||
            nType == EFFECT_TYPE_REGENERATE                ||
            nType == EFFECT_TYPE_SANCTUARY                 ||
            nType == EFFECT_TYPE_SAVING_THROW_INCREASE     ||
            nType == EFFECT_TYPE_SEEINVISIBLE              ||
            nType == EFFECT_TYPE_SILENCE                   ||
            nType == EFFECT_TYPE_SKILL_INCREASE            ||
            nType == EFFECT_TYPE_SLOW                      ||
            nType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
            nType == EFFECT_TYPE_SPELLLEVELABSORPTION      ||
            nType == EFFECT_TYPE_TEMPORARY_HITPOINTS       ||
            nType == EFFECT_TYPE_TRUESEEING                ||
            nType == EFFECT_TYPE_ULTRAVISION               ||
            nType == EFFECT_TYPE_INVULNERABLE
            )
           )
            RemoveEffect(oObject, eEff);
        
        eEff = GetNextEffect(oObject);
    }
}

void main()
{
    object oEnter = GetEnteringObject();

    if(GetObjectType(oEnter) == OBJECT_TYPE_CREATURE)
    {
	
        // Set the marker variable
        PS_SetLocalInt(oEnter, "NullPsionicsField", TRUE);
        
        // Remove all non-extraordinary effects
        RemoveEffectsNPF(oEnter);
        
        // Apply absolute spell failure
        effect eSpellFailure = EffectSpellFailure(100);
		effect eSpellInvul = EffectSpellImmunity(SPELL_ALL_SPELLS);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpellFailure, oEnter);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpellInvul, oEnter);
		
    }
}