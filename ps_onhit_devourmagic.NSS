//:://///////////////////////////////////////////////
//:: Warlock Greater Invocation: Devour Magic
//:: nw_s0_idevmagic.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
	Devour Magic
	Complete Arcane, pg. 133
	Spell Level:	6
	Class: 		Misc
	
	This invocation functions as a greater dispel
	magic spell (6th level wizard). If a spell 
	effect is successfully removed, then the 
	warlock gains twice their warlock level in 
	temporary hit points (which add to their 
	maximum hit points just like the 2nd 
	level cleric spell aid). These temporary hit 
	points fade after 1 minute. 
	
	[Rules Note] In the rules the warlock gains 5 
	temporary hit points per spell level dispelled, 
	this isn't possible because the spell level 
	in the NWN2 engine isn't stored on a 
	spell effect. So this clean rule mimics that 
	effect.

*/
//: RPGplayer1 04/09/2008: Added gaining temporary HP from dispelling AoE

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "nwn2_inc_spells"
#include "ps_inc_onhit" 

void DispelAoECallback(object oTarget, object oCaster, int nID);

void main()
{

    location lLocal = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nCasterLevel = PS_GetCasterLevel(oCaster);
	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nID = GetOnHitAbilityID(OBJECT_SELF);
    effect    eVis         = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
    effect    eImpact; // vfx now handled by spells.2da (ImpactSEF column), but this effect required for
						// DispelMagic* function
	
    //--------------------------------------------------------------------------
    // Greater Dispel Magic is capped at caster level 15
    //--------------------------------------------------------------------------
    if(nCasterLevel > 10 && nID == SPELL_I_VORACIOUS_DISPELLING)
    {
        nCasterLevel = 10;
    }
    if ( GetIsObjectValid(OBJECT_SELF) )
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
         DispelMagicWithCallback(OBJECT_SELF, oCaster, nCasterLevel, eVis, eImpact, TRUE, nID );
         
    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------

        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                spellsDispelAoE(oTarget, OBJECT_SELF, nCasterLevel);
                DelayCommand(0.1f, DispelAoECallback(oTarget, oCaster, nID));
            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_I_VORACIOUS_DISPELLING) );
            }
            else
            {
                DelayCommand( GetRandomDelay(0.51, 0.93), DispelMagicWithCallback(oTarget, oCaster, nCasterLevel, eVis, eImpact, FALSE, nID ) );
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }

}

//AoE destroyed -> gain temporary hit points
void DispelAoECallback(object oTarget, object oCaster, int nID)
{
    if (!GetIsObjectValid(oTarget) && nID == SPELL_I_DEVOUR_MAGIC)
        DevourDispelCallback(oCaster);
	else
		VoraciousDispelCallback(oTarget, oCaster);
}