//:: Warlock Lesser Invocation: Curse of Despair
//:: nw_s0_icursedes.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
        5.7.2.4	Curse of Despair
        Complete Arcane, pg. 132
        Spell Level:	4
        Class: 		Misc

        This is the equivalent to the Bestow Curse spell (4th level wizard). 
        But even if the target makes their save, 
        they still suffer a -1 penalty to hit for 10 rounds.

*/
// RPGplayer1 02/04/2009: Made SpellCastAt event pass proper caster, so that caster drops invisibility as he should
/*
rapsam2003 03/16/2018: Remove save against NPCs
	and Hexer feats reduce the AC of the target.
*/

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "srcalc"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	int nMod = 3; // Default mod is 3, a successful save reduces it to 1 
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
	effect eCurse;
	effect eACReduce;
	int nACDebuff = 0;
	int nRoundsLeft = 9; // rapsam2003: Used to track numbers of rounds to have Eldritch Blast dice increased by 1d6
	
	// rapsam2003: For Curse of Despair, these feats
	// reduce the AC of the enemy.
	if (GetHasFeat(2901, oCaster))
		nACDebuff = 3;
	else if (GetHasFeat(2900, oCaster))
		nACDebuff = 2;
	else if (GetHasFeat(2908, oCaster))
		nACDebuff = 1;
	
		
	if (GetHasFeat(2907, oCaster)) 
		nMod = 5;
	else if (GetHasFeat(2902, oCaster)) 
		nMod = 4;

    float fDuration = 0.0f;
    int nDurType = DURATION_TYPE_PERMANENT;

    //Signal spell cast at event.
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BESTOW_CURSE));
     
    // Spell Resist check.
    if (!DoWarlockMyResistSpell(oCaster, oTarget) || GetHasFeat(2907, oCaster))
    {			
		//Get the spell target location as opposed to the spell target.
		location locTarget = GetSpellTargetLocation();
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, locTarget, TRUE, OBJECT_TYPE_CREATURE);
		    
		while (GetIsObjectValid(oTarget))
		{	
		
				//If The Targets are Friendly, it will not do nothing
				if (GetIsReactionTypeFriendly(oTarget,oCaster))
				{
				return;
				}
			else
			// Will Save for PCs.
        	if (GetIsPC(oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
         	{
            	nMod = 1;
				eCurse = EffectAttackDecrease(nMod);
             	fDuration = RoundsToSeconds(10);
             	nDurType = DURATION_TYPE_TEMPORARY;
         	}			
			else // No save for monsters.
			{
			
         		eCurse = EffectCurse(nMod, nMod, nMod, nMod, nMod, nMod);
	
				if (nACDebuff > 0)
				{
					eACReduce = EffectACDecrease(nACDebuff);
					eCurse = EffectLinkEffects(eACReduce, eCurse);
				}
			}
   
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
   			eCurse = SupernaturalEffect(eCurse);

         	//Apply Effect and VFX
         	ApplyEffectToObject(nDurType, eCurse, oTarget, fDuration);
         	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			
			// If no Cursemaster feat, set oTarget to 
			// OBJECT_TYPE_INVALID and cause exit of while loop.
			if (!GetHasFeat(2907, oCaster))
				break;
			else //Select the next target within the spell shape.
		    	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, locTarget, TRUE, OBJECT_TYPE_CREATURE); 
    	}
	
		SendMessageToPC(oCaster, "The curse causes the affected enemy's armor to be slightly less effective.");
	}
}