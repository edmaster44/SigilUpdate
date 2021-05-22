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
	effect eImpact		= EffectVisualEffect(VFX_HIT_SPELL_FIRE);
		eImpact			= EffectLinkEffects(eImpact, EffectVisualEffect(VFX_HIT_SPELL_HOLY));
	effect eDam			= EffectDamage(d8(2), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, TRUE);
	if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
	{eDam =  EffectDamage(d8(4), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, TRUE);}
		eImpact			= EffectLinkEffects(eImpact, eDam);
	effect eBlind 		= EffectBlindness();
	effect eLink = EffectLinkEffects(eImpact,eBlind);
	
	if (!GetIsObjectValid(oCaster))
    {	DestroyObject(OBJECT_SELF);
        return;		}
		
	oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
		{	int nRace			= GetRacialType(oTarget);
	
			if (oTarget == oCaster) return;
			 if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
			 {  SignalEvent(oTarget, EventSpellCastAt(oCaster, 1656, TRUE));
			 	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget); }
			 															
			if (nRace == RACIAL_TYPE_OUTSIDER || nRace == RACIAL_TYPE_UNDEAD || nRace == RACIAL_TYPE_FEY)
			{	SignalEvent(oTarget, EventSpellCastAt(oCaster, 1656, TRUE));
        		ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);	}
		}
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}