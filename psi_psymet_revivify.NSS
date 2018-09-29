//::///////////////////////////////////////////////
//:: Psionic Revivify
//:: Psychometabolism 5
//:://////////////////////////////////////////////
//:: Brings a character back to life with 10 HP
//:: multiplied by the target's Intelligence modifier.
//:: Restores a minimum of 10 hp.
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: 3/2/2015
//:://////////////////////////////////////////////


#include "x2_inc_spellhook" 
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

   if (!PsiPrePowerCastCode())
   {
   // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
       return;
   }
	object oManifester = OBJECT_SELF;
   	object oTarget     = GetSpellTargetObject();
   	struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                             GetSpellId(), METAPSIONIC_NONE);
// End of Spell Cast Hook

	if(manif.bCanManifest)
	{
    //Declare major variables
    
	    effect eRaise = EffectResurrection();
	    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_CONJURATION );
		int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
		if (nInt < 0)
		{
			nInt == 1;
		}
		effect eHeal = EffectHeal(nInt * 10);
		effect eLink = EffectLinkEffects(eRaise, eHeal);
	    //Fire cast spell at event for the specified target
	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAISE_DEAD, FALSE));
	    if(GetIsDead(oTarget))
	    {
	        //Apply raise dead effect and VFX impact
	        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
	        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	    }
	}
}