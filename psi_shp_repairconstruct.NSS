//::///////////////////////////////////////////////
//:: Repair Construct
//:: Metacreativity 1
//:://////////////////////////////////////////////
//:: Repairs a friendly construct, healing 
//:: 1d8 + 1(Caster Level) damage. 
//:: Augmenting increases the healing 
//:: to 2d8
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: 3/1/2015
//:://////////////////////////////////////////////


#include "x0_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
                             GetSpellId(), METAPSIONIC_MAXIMIZE | METAPSIONIC_EMPOWER | METAPSIONIC_AUGMENT);
// End of Spell Cast Hook

	if(manif.bCanManifest)
	{
    //Declare major variables
	    
		int nCasterLevel = manif.nManifesterLevel;
	    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
		int nNumberOfDice = 1;
		int nHeal = d8(nNumberOfDice) + nCasterLevel;
		if (manif.bAugment)
			nNumberOfDice += 2;
	    effect eHeal = EffectHeal(nHeal);
		
		if (manif.bMaximize)
		{
			nHeal = 8*nNumberOfDice;
		}
		if (manif.bEmpower)
		{
			nHeal = nHeal + (nHeal/2);
		}
	
	    //Link persistant effects
	    effect eLink = EffectLinkEffects(eVis, eHeal);
	
	
		//Has same SpellId as Charm Person, not an item, but returns no valid class -> it's racial ability
	
	    int nRacial = GetRacialType(oTarget);
	    //Make Metamagic check for extend
	    
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14325, FALSE));
	        //Make SR Check
	        
	            //Verify that the Racial Type is humanoid
	            if  (nRacial == RACIAL_TYPE_CONSTRUCT)
	            {
	                //Make a Will Save check
	                
	                    //Apply impact and linked effects
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	                
	            }
	         
	     }
	 }
}