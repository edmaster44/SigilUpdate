//::///////////////////////////////////////////////
//:: Cloudkill: On Enter
//:: NW_S0_CloudKillA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d4 CON damage
    every round. Fortitude saves for half.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 09.18.06: Modified to make closer to the PHB rules
//:: RPGplayer1 14/04/2008:
//::  Will stack CON damage (by setting SpellId to -1)
//::  CON damage changed to Extraordinary (to prevent dispelling)

#include "X0_I0_SPELLS"
#include "ps_inc_onhit" 

void main()
{
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());

    object oTarget = GetEnteringObject();
    int nHD = GetHitDice(oTarget);
    effect eDeath = EffectDeath();
    effect eVis =   EffectVisualEffect(VFX_IMP_DEATH);
    effect eNeg = EffectVisualEffect( VFX_HIT_SPELL_POISON );	// NWN2 VFX
	int nDC = GetOnHitAbilityDC(GetAreaOfEffectCreator());

    float fDelay= GetRandomDelay(0.5, 1.5);
    effect eDam;
    int nDam = d4();
	
    eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
    eDam = SetEffectSpellId(eDam, -1);
    eDam = ExtraordinaryEffect(eDam);

    if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , oCaster) )
    {
		if(GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
		{
			return;
		}
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CLOUDKILL));
        //Make SR Check
        if(!OnHitResistSpell(oCaster, oTarget))
        {
            //Determine spell effect based on the targets HD
            if (nHD <= 3)
            {
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
					string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> kills "+GetName(oTarget)+"</color>";
					SendMessageToPC(oCaster, report);
                }
            }
            else if (nHD >= 4 && nHD <= 6)
            {
                //Make a save or die
                if(!OnHitSavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, oCaster, fDelay))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> kills "+GetName(oTarget)+"</color>";
					SendMessageToPC(oCaster, report);
                }
                else
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDam)+"</color>";
					SendMessageToPC(oCaster, sReport);
                }
            }
            else
            {
				if (OnHitSavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_POISON, oCaster, fDelay))
				{
					nDam = nDam/2;
					eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
					eDam = SetEffectSpellId(eDam, -1);
					eDam = ExtraordinaryEffect(eDam);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDam)+"</color>";
					SendMessageToPC(oCaster, sReport);

				}
				else
				{	
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDam)+"</color>";
					SendMessageToPC(oCaster, sReport);
				}
            }
        }
    }
}