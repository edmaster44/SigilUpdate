//::///////////////////////////////////////////////
//:: Bestow Curse
//:: NW_S0_BesCurse.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Afflicted creature must save or suffer a -2 penalty
    to all ability scores. This is a supernatural effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Bob McCabe
//:: Created On: March 6, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 20, 2001
//:: AFW-OEI 04/05/2007: Increase curse to -3 to all ability scores (from -2).
//:: RPGplayer1 12/23/2008: Made sure that curse is Supernatural
//:: RPGplayer1 02/04/2009: Made SpellCastAt event pass proper caster, so that caster drops invisibility as he should

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    object oTarget = OBJECT_SELF;
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	// NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BESTOW_CURSE );	// NWN2 VFX
    effect eCurse = EffectCurse(3, 3, 3, 3, 3, 3);
    object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);

    //Make sure that curse is of type supernatural not magical
    //eCurse = SupernaturalEffect(eCurse);
	effect eLink = EffectLinkEffects( eCurse, eVis );
	eLink = SupernaturalEffect(eLink); //FIX: whole link needs to be supernatural
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BESTOW_CURSE));
         //Make SR Check
         if (!OnHitResistSpell(OBJECT_SELF, oTarget))
         {
            //Make Will Save
            if (!OnHitSavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster))
            {
                //Apply Effect and VFX
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
				string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> curses "+GetName(oTarget)+"</color>";
				SendMessageToPC(oCaster, sReport);
            }
        }
    }
	
	DelayCommand(0.5f, ClearOnHitInfo(OBJECT_SELF));
}