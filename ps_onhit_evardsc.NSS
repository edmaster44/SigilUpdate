//::///////////////////////////////////////////////
//:: Evards Black Tentacles: Heartbeat
//:: NW_S0_EvardsB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the mass of rubbery tentacles the
    target is struck by 1d4 tentacles.  Each has
    a chance to hit of 5 + 1d20. If it succeeds then
    it does 2d6 damage and the target must make
    a Fortitude Save versus paralysis or be paralyzed
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book
// 10/16/06 - BDF(OEI): fixed an issue with the AC being queried from an uninitialized object.
//	AC was also never being requeried during object iteration.  Good catch, xitooner!

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 
#include "ps_inc_functions"


void main()
{

    object oTarget;
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
	int nSaveDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
    effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eDur, eParal);
    effect eDam;

    int nDamage;
    int nAC;
    int nHits = d4();
    int nRoll;
    float fDelay;
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        nDamage = 0;
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_EVARDS_BLACK_TENTACLES));
            nDamage = 0;
			nAC = GetAC(oTarget);
			
            for (nHits = d4(); nHits > 0; nHits--)
            {
                fDelay = GetRandomDelay(0.75, 1.5);
                nRoll = 32 + d20();
				
                if( ((nRoll >= nAC) || (nRoll == 25)) && (nRoll != 6) )
                {
                    nDamage = d6() + (nCL/2);
					
					eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDamage)+"</color>";
					SendMessageToPC(oCaster, sReport);
		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		            if(!OnHitSavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
		            {
		                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
						string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> paralyzes "+GetName(oTarget)+"</color>";
						SendMessageToPC(oCaster, report);
		            }
                }           
			}
		}
	    oTarget = GetNextInPersistentObject();
    }
}