/*
   ----------------
   Null Psionics Field - OnExit

   psi_pow_npfext
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Null Psionics Field - OnExit

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
    object oCaster = GetAreaOfEffectCreator();
    effect eEff = GetFirstEffect(oObject);
    int nEffID;
    while(GetIsEffectValid(eEff))
    {
        if(GetEffectCreator(eEff) == oCaster)
        {
            nEffID = GetEffectSpellId(eEff);
            if(nEffID == EFFECT_TYPE_SPELL_FAILURE 
            || nEffID == EFFECT_TYPE_SPELL_IMMUNITY)
            {
                RemoveEffect(oObject, eEff);
            }
        }
        eEff = GetNextEffect(oObject);
    }
}
void main()
{
    object oExit = GetExitingObject();
	
    // iterate through all creature's items and if there is one in the chest, replace it with
    // the current one.
    if(GetObjectType(oExit) == OBJECT_TYPE_CREATURE)
    {
        DeleteLocalInt(oExit, "NullPsionicsField");

        RemoveEffectsNPF(oExit);
    }
}