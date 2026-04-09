//::///////////////////////////////////////////////
//:: Hezrou Stench On Enter
//:: NW_S1_HezStenchA.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    A hezrou’s skin produces a foul-smelling, 
	toxic liquid whenever it fights. Any living creature 
	(except other demons) within 10 feet must succeed on a DC 24 Fortitude 
	save or be nauseated for as long as it remains within the affected area 
	and for 1d4 rounds afterward. Creatures that successfully save are 
	sickened for as long as they remain in the area. A creature that 
	successfully saves cannot be affected again by the same hezrou’s 
	stench for 24 hours. A delay poison or neutralize poison spell removes 
	either condition from one creature. Creatures that have immunity to poison 
	are unaffected, and creatures resistant to poison receive their 
	normal bonus on their saving throws. The save DC is Constitution-based.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: July 24, 2006
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eNaus= EffectSlow();
    effect eCon= EffectAbilityDecrease( ABILITY_CONSTITUTION, 4 );
    effect eStr= EffectAbilityDecrease( ABILITY_STRENGTH, 4 );
    effect eDex= EffectAbilityDecrease( ABILITY_DEXTERITY, 4 );
    effect eDur1 = EffectVisualEffect( VFX_DUR_NAUSEA );
    effect eDur2 = EffectVisualEffect( VFX_DUR_SICKENED );
    effect eSick1 = EffectLinkEffects( eCon, eStr );
    effect eSick2 = EffectLinkEffects( eSick1, eDex );
    effect eLink1 = EffectLinkEffects( eNaus, eDur1 );
    effect eLink2 = EffectLinkEffects( eSick2, eDur2 ); 
	object oPC = GetAreaOfEffectCreator();
	eLink2 = ExtraordinaryEffect(eLink2); // stop Bar-Lgura dispel from removing.
  
    int iDC = 10 + GetTotalLevels(oPC, TRUE)/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
	int iDur = 2 + GetTotalLevels(oPC, TRUE)/3;
	
    if(!GetHasSpellEffect(SPELLABILITY_HEZROU_STENCH, oTarget))
    {     
        if(GetIsEnemy(oTarget, oPC))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt( oTarget, SPELLABILITY_HEZROU_STENCH ));
                if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                {
                string feedback;
                string sName = GetName(oTarget);
                object oTarget2 = GetFactionLeader(oTarget);
                feedback=sName+" : Immune to Poison";
                SendMessageToPC(oTarget2, feedback);
                return;
                }                
                //Make a saving throw check
                else if(!MySavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_POISON))
                {
                    int nDuration = d4(1) + iDur;
                    //Apply the VFX impact and effects for Nausea
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, RoundsToSeconds( nDuration ));
					ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds( nDuration ));
                }
            }
        
    }
}