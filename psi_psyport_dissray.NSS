//::///////////////////////////////////////////////
//:: Dissipating Ray
//:: Psychoportation 1
//::
//:://////////////////////////////////////////////
/*
    If the caster succeeds at a ranged touch attack
    the target takes 1d4 + 1 damage.
	Summoned creatures take double damage.
	
	If augmented, deals 2d4 +1 damage instead.
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: 2/26/2015
//:://////////////////////////////////////////////



#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"
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
                             GetSpellId(), METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE);
// End of Spell Cast Hook
	if(manif.bCanManifest)
	{

    //Declare major variables
	    
		int nTouch      = TouchAttackRanged(oTarget);
		object oMaster = GetMaster(oTarget);
		
		
	
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	    {
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14320));
	
			if (nTouch != TOUCH_ATTACK_RESULT_MISS)
			{	//Make SR Check
		        if(!MyResistSpell(OBJECT_SELF, oTarget))
		        {
		            //Enter Metamagic conditions
		 			int nDam = d4(1)+1;
					
					if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
					{
						nDam = d4(2) + 1;
					}
					
					if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXMIZE") == 1)
		            {
		                nDam = 5; //Damage/Healing is +50%
						if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
						{
							nDam = 8;
						}
		            }
					
					if (GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
		            {
		                nDam = nDam + (nDam/2); //Damage/Healing is +50%
		            }
		    		
					if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
					{
						nDam = nDam*2;
						
					}
					
					if (GetIsObjectValid(oMaster) && GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget)
					{
						nDam = nDam * 2;
					}
					/*int nMetaMagic = GetMetaMagicFeat();
		            if (nMetaMagic == METAMAGIC_MAXIMIZE)
		            {
		                nDam = 5 ;//Damage is at max
		            }
		            else if (nMetaMagic == METAMAGIC_EMPOWER)
		            {
		                nDam = nDam + nDam/2; //Damage/Healing is +50%
		            }*/
			
		            //Set damage effect
		            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
		   	 		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
		
		            //Apply the VFX impact and damage effect
		            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		        }
			}
	    }
		
	    effect eRay = EffectBeam(VFX_BEAM_ABJURATION, OBJECT_SELF, BODY_NODE_HAND);
	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
	}
}