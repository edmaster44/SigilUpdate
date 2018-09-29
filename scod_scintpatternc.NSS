//::///////////////////////////////////////////////
//:: Aura of Menace On Enter
//:: NW_S1_AuraMencA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura all those that fail
    a will save are stricken with Doom.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "aaa_constants"

void main()
{
	object oTarget;
	object oCaster		= GetAreaOfEffectCreator();
	effect eUnconsc		= EffectSleep();
	effect eStunned		= EffectStunned();
	effect eConfused	= EffectConfused();
	effect eConfVFX		= EffectNWN2SpecialEffectFile("fx_confusion");
	effect eLink = EffectLinkEffects(eConfused, eConfVFX);
	int nHitDice, nDieRoll1, nDieRoll2, nDieRoll3;
	
	if (!GetIsObjectValid(oCaster))
    {	DestroyObject(OBJECT_SELF);
        return;		}
		
	oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
		{	if (!MyResistSpell(oCaster, oTarget))
			{	SignalEvent(oTarget, EventSpellCastAt(oCaster, 1482, TRUE));
				nHitDice	= GetHitDice(oTarget);
				if (nHitDice >= 17)
				{	nDieRoll1 = d4(1);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDieRoll1));	}
				else if (nHitDice >= 7) 
				{	nDieRoll1 = d4(1);
					nDieRoll2 = d4(1);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStunned, oTarget, RoundsToSeconds(nDieRoll1));
					DelayCommand(RoundsToSeconds(nDieRoll1), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDieRoll2)));	}
				else
				{	nDieRoll1 = d4(1);
					nDieRoll2 = d4(1);
					nDieRoll3 = d4(1);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUnconsc, oTarget, RoundsToSeconds(nDieRoll1));
					DelayCommand(RoundsToSeconds(nDieRoll1), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStunned, oTarget, RoundsToSeconds(nDieRoll2)));
					DelayCommand(RoundsToSeconds(nDieRoll1 + nDieRoll2), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDieRoll3)));	}
			}	
		}
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}