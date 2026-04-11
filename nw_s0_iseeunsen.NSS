//::///////////////////////////////////////////////
//:: Invocation: See the Unseen
//:: NW_S0_ISeeUnsen.nss
//:://////////////////////////////////////////////
/*
    Caster gains Darkvision & See Invisibility for
    24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
// FlattedFifth june 28, 2024: Former version of this spell granted Darkvision PERMANENTLY 
// 				if caster rests or logs out before duration end. Fixed it.


// JLR - OEI 08/24/05 -- Metamagic changes
#include "ps_inc_invocations"

void main(){
	DoSelfOnlyInvocation(SPELL_I_SEE_THE_UNSEEN);
}
/*
void main()
{

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
	int nFeatDarkvision = 228;
    object oTarget = GetSpellTargetObject();
    float fDuration = HoursToSeconds(24); 

    fDuration = ApplyMetamagicDurationMods(fDuration);
   // int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SEE_INVISIBILITY );
    effect eSight = EffectSeeInvisible();
	effect eBlind = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
    effect eLink = EffectLinkEffects(eSight, eDur);
	eLink = EffectLinkEffects(eBlind, eDur);
  
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	PS_GrantFeatBySpellWithEffect(nFeatDarkvision, oTarget, eLink, fDuration);
}
*/