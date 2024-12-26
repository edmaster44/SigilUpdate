//:://///////////////////////////////////////////////
//:: Level 6 Arcane Spell: Stone Body
//:: nw_s0_stonebody.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/15/05
//::////////////////////////////////////////////////
/*
       5.1.6.3.5 Stone Body
       Players Guide to Faern, pg. 113
       School:   Transmutation
       Components:  Verbal, Somatic
       Range:   Personal
       Target:   You
       Duration:  1 minute / level

       You gain damage reduction 10/adamantine and a +4 enhancement bonus to
       Strength, but you take a -4 penalty to Dexterity. You move at half speed.
       You have a 50% arcane failure chance and a -8 armor check penalty. You are
       also immune to blindness, critical hits, ability score damage, deafness,
       disease, electricity, poison, and stunning. You take only half damage from
       acid and fire of all kinds.
       [Art] The PC's model turns gray when this is cast.

       [B] Ideally the player's equipment turns gray, as well. A stone texture
       would be even better. This spell can be restricted to humanoid targets if
       it becomes a problem to apply to other creature types.

*/
//:: RPGplayer1 04/10/2008: Don't apply electricity immunity from two spell sources (it's buggy)

/*
	History of Changes - SCOD

	20MAY2010 - ADnD'R
	1. Added Mass Death Ward clause to Pelhikano's fix which addresses Deathward's 
	and Freedom of Movement's "cheat" to prevent Stonebody from applying the detrimental 
	effects. Note that we DO NOT REAPPLY Mass Death Ward to the individual (since it would
	be, in effect, a free DW for everyone nearby & in the party), but just do another Death 
	Ward. The difference should be invisible to the player. 
	
*/

// Dec 19, 2024 - FlattedFifth.
// Removing Freedom of Movement, Deathward, etc and then reapplying
// isn't balanced because first of all, if a cleric has to cast three spells to get the same 
// effects as a one or two mage spells then how is that OP? Secondly, doing
// so strips all Metamagic duration from the initial casting. Instead, we will allow death ward
// and freedom of movement to prevent negative effects but ALSO have them prevent some of the 
// positive effects. If FoM is on, prevents decreased speed but ALSO prevents crit immunity.
// If Death Ward is on, prevents decreased dex but ALSO prevents stun immunity





// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"

#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;
  

   object oTarget      = GetSpellTargetObject(); // should be the caster
   int nCasterLevel    = PS_GetCasterLevel(OBJECT_SELF);
   float fDuration     = 60.0*nCasterLevel; // seconds  (1 min per level)
   
   	// Freedom of Movement
	int bHasFoM = FALSE;
	if (GetHasSpellEffect(SPELL_FREEDOM_OF_MOVEMENT, oTarget)) bHasFoM = TRUE;

	int bHasDW = FALSE;
	if (GetHasSpellEffect(SPELL_DEATH_WARD, oTarget) || 
	GetHasSpellEffect(SPELL_MASS_DEATH_WARD, oTarget)) bHasDW = TRUE;
   
   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONE_BODY, FALSE));

   fDuration = ApplyMetamagicDurationMods(fDuration);
   int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

   effect eVis      = EffectVisualEffect( VFX_DUR_SPELL_STONEBODY );

   effect eStone       = EffectDamageReduction( 10, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL); // JLR-OEI 02/14/06: NWN2 3.5 -- New Damage Reduction Rules
   effect eStrIncr     = EffectAbilityIncrease( ABILITY_STRENGTH, 4 );
   effect eDexDecr     = EffectAbilityDecrease( ABILITY_DEXTERITY, 4 );
   effect eMovDecr     = EffectMovementSpeedDecrease( 50 );
   effect eSpellFail   = EffectArcaneSpellFailure( 50 ); // AFW-OEI 10/19/2006: Use ASF instead of Spell Failure

   effect eArmorCheck  = EffectArmorCheckPenaltyIncrease( oTarget, 8 );

   effect eBlindI      = EffectImmunity( IMMUNITY_TYPE_BLINDNESS );
   effect eCritI       = EffectImmunity( IMMUNITY_TYPE_CRITICAL_HIT );
   effect eStatDecI    = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );
   effect eDeafI       = EffectImmunity( IMMUNITY_TYPE_DEAFNESS );
   effect eDiseaseI    = EffectImmunity( IMMUNITY_TYPE_DISEASE );
   effect eElectricI   = EffectDamageImmunityIncrease( DAMAGE_TYPE_ELECTRICAL, 100 );  
   effect ePoison      = EffectImmunity( IMMUNITY_TYPE_POISON );
   effect eStunI       = EffectImmunity( IMMUNITY_TYPE_STUN );
   effect eFireI       = EffectDamageImmunityIncrease( DAMAGE_TYPE_FIRE, 50 );
   effect eAcidI       = EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, 50 );  

   // Link the effects together
	effect eLink = EffectLinkEffects(eSpellFail, eStone);
	eLink = EffectLinkEffects(eStrIncr, eLink);
	eLink = EffectLinkEffects(ePoison, eLink);
	eLink = EffectLinkEffects(eFireI, eLink);
	eLink = EffectLinkEffects(eAcidI, eLink);
	eLink = EffectLinkEffects(eVis, eLink);
	eLink = EffectLinkEffects(eArmorCheck, eLink);
	eLink = EffectLinkEffects(eBlindI, eLink);
	eLink = EffectLinkEffects(eDeafI, eLink);
	eLink = EffectLinkEffects(eDiseaseI, eLink);

	if (!GetHasSpellEffect(1106, oTarget)) //SPELLABILITY_IMMUNITY_TO_ELECTRICITY
	{
	   eLink = EffectLinkEffects(eElectricI, eLink);
	}


	if (!bHasDW){
	   eLink = EffectLinkEffects(eStrIncr, eLink);
	   eLink = EffectLinkEffects(eDexDecr, eLink);
	   eLink = EffectLinkEffects(eStatDecI, eLink);
	   eLink = EffectLinkEffects(eStunI, eLink);
	}

	if (!bHasFoM){
		eLink = EffectLinkEffects(eMovDecr, eLink);
		eLink = EffectLinkEffects(eCritI, eLink);
	}
   ApplyEffectToObject(nDurType, eLink, oTarget, fDuration );




}