//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Heroics
//:: NW_S2_SngInHero
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/06/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    This spells applies bonuses to a specific ally target.
*/
//:: PKM-OEI 07.13.06 VFX Pass
//:: AFW-OEI 07/14/2006: Check to see if you have bardsong feats left; if you do, execute
//::	script and decrement a bardsong use.
//:: PKM-OEI 07.20.06 Added Perform skill check
//:: AFW-OEI 02/20/2007: Add support for Chorus of Heroism, which applies effects to whole party.

#include "x0_i0_spells"
#include "nwn2_inc_spells"
#include "ps_inc_functions"

void main()
{
	if ( GetCanBardSing( OBJECT_SELF ) == FALSE )
	{
		return; // Awww :(	
	}

    if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,OBJECT_SELF); // no more bardsong uses left
        return;
    }
	
	int		nPerform	= GetSkillRank(SKILL_PERFORM);
	 
	if (nPerform < 18 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}

    //Declare major variables
//  int nLevel      = GetLevelByClass(CLASS_TYPE_BARD);
	int nLevel = GetBardicClassLevelForUses(OBJECT_SELF);
    int nDuration   = ApplySongDurationFeatMods( 5, OBJECT_SELF ); // Rounds
    float fDuration = RoundsToSeconds(nDuration);
    int nDR         = 20;
    int nSave       = 4;
    int nHP         = 4 * nLevel;
    object oTarget  = GetSpellTargetObject();

    effect eDR     = ExtraordinaryEffect( EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, nDR) );
	effect eDR2    = ExtraordinaryEffect( EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, nDR) );
	effect eDR3    = ExtraordinaryEffect( EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, nDR) );
    effect eSave   = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_ALL, nSave) );
    effect eHP     = ExtraordinaryEffect( EffectTemporaryHitpoints(nHP) );
    effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_HEROICS) );
    effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eDR, eSave) );
//    eLink          = ExtraordinaryEffect( EffectLinkEffects(eLink, eHP) );
    eLink          = ExtraordinaryEffect( EffectLinkEffects(eLink, eDur) );
	eLink = ExtraordinaryEffect( EffectLinkEffects(eLink, eDR2) );
	eLink = ExtraordinaryEffect( EffectLinkEffects(eLink, eDR3) );
    //FIX: should not cancel inspirations
    //if(AttemptNewSong(OBJECT_SELF))
    {
        if (GetHasFeat(FEAT_EPIC_CHORUS_OF_HEROISM, OBJECT_SELF, TRUE))
        {   // Apply effects to whole party if you have Chorus of Heroism
            ApplyFriendlySongEffectsToParty( OBJECT_SELF, GetSpellId(), fDuration, eLink);
            ApplyFriendlySongEffectsToParty( OBJECT_SELF, 550, fDuration, eHP); //HACK: 550 is padding, used to trick function to apply two effects
        }
        else
        {
            ApplyFriendlySongEffectsToTarget( OBJECT_SELF, GetSpellId(), fDuration, eLink );
            ApplyFriendlySongEffectsToTarget( OBJECT_SELF, 550, fDuration, eHP); //HACK: 550 is padding, used to trick function to apply two effects
        }
        
    	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
    }
}