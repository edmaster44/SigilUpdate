//::///////////////////////////////////////////////
//:: Cloudkill: Heartbeat
//:: NW_S0_CloudKillC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d4 CON damage per
	round.  Fortitude reduces damage by half.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 09.18.06: Updated to do CON damage.
//:: RPGplayer1 14/04/2008:
//::  Will stack CON damage (by setting SpellId to -1)
//::  CON damage changed to Extraordinary (to prevent dispelling)

#include "X0_I0_SPELLS"
#include "ps_inc_onhit" 

void main()
{
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
    int nDamage = d4();
    effect eDam;
	
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_POISON );	// NWN2 VFX
    object oTarget;
    float fDelay;
	int nDC = GetOnHitAbilityDC(GetAreaOfEffectCreator());

   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }


    //Set damage effect
    //eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
	eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage);
    //Get the first object in the persistant AOE
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator()) )
        {
			if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
			{
				//return;
			//}
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CLOUDKILL));
            if(!OnHitResistSpell(oCaster, oTarget))
            {
                nDamage = d4();
				
				if (OnHitSavingThrow(SAVING_THROW_FORT, oTarget, GetOnHitAbilityDC(oCaster), SAVING_THROW_TYPE_POISON, oCaster))
				{
					nDamage = nDamage / 2;
					eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage);
					eDam = SetEffectSpellId(eDam, -1);
					eDam = ExtraordinaryEffect(eDam);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDamage)+"</color>";
					SendMessageToPC(oCaster, sReport);
				}
				else
				{
					eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage);
					eDam = SetEffectSpellId(eDam, -1);
					eDam = ExtraordinaryEffect(eDam);
                	//Apply VFX impact and damage
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDamage)+"</color>";
					SendMessageToPC(oCaster, sReport);
				}
            }
			}
        }
        //Get the next target in the AOE
        oTarget = GetNextInPersistentObject();
    }
}