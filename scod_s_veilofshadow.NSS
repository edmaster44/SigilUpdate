//::///////////////////////////////////////////////
//:: Veil of Shadow 

//:://////////////////////////////////////////////
/*
   Swirling wisps of darkness obscure your form, granting you concealment. 
   The 20% miss chance is in effect even if the attacker has darkvision.


*/
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "aaa_constants"
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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
	effect eVis = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
    effect eConceal = EffectConcealment(20);
    //effect eDur = EffectVisualEffect( VFX_DUR_SPELL_GHOSTLY_VISAGE );
    effect eLink = EffectLinkEffects(eConceal, eVis);
  //  eLink = EffectLinkEffects(eLink, eConceal);
    //eLink = EffectLinkEffects(eLink, eDur);
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = PS_GetCasterLevel(OBJECT_SELF);
	

	
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VEIL_OF_SHADOW, FALSE));

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
    	nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}