//::///////////////////////////////////////////////
//:: Knock
//:: NW_S0_Knock
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Opens doors not locked by magical means.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg 2003/07/31 - Added signal event and custom door flags
//:: VFX Pass By: Preston W, On: June 22, 2001
#include "nw_i0_spells"

#include "x2_inc_spellhook"


void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

	int nDuration = 2 + PS_GetCasterLevel(OBJECT_SELF); 
	int nBonus = 10;
	
	int nMeta = GetMetaMagicFeat();
	if (nMeta == METAMAGIC_EMPOWER) nBonus += nBonus / 2;
	if (nMeta == METAMAGIC_EXTEND) nDuration *= 2;
	
	effect eOpen = EffectSkillIncrease(SKILL_OPEN_LOCK, nBonus);
	eOpen = SetEffectSpellId(eOpen, SPELL_KNOCK);
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_KNOCK, FALSE));
	PS_RemoveEffects(OBJECT_SELF, SPELL_KNOCK);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOpen, OBJECT_SELF, TurnsToSeconds(nDuration)); 

    object oTarget;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    float fDelay;
    int nResist;

    while(GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId()));
        fDelay = GetRandomDelay(0.5, 2.5);
		
		// a little fix to allow Gith chests to be unlocked with Knock, even though they are set to plot.
        if((!GetPlotFlag(oTarget) || GetTag(oTarget) == "ps_githint_chest") && GetLocked(oTarget))
        {
            nResist =  GetDoorFlag(oTarget,DOOR_FLAG_RESIST_KNOCK);
            if (nResist == 0)
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                AssignCommand(oTarget, ActionUnlockObject(oTarget));
            }
            else if  (nResist == 1)
            {
                FloatingTextStrRefOnCreature(83887,OBJECT_SELF);   //
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}