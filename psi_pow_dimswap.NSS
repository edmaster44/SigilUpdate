#include "ff_safevar"
/*
   ----------------
   Dimensional Swap

   psi_pow_dimswap
   ----------------

   8/4/05 by Stratovarius
*/ /** @file

    Dimensional Swap

    Psychoportation (Teleportation)
    Level: Nomad 2, psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Targets: You and one ally in range
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: None

    You instantly swap positions between your current position and that of a
    designated ally in range. This power affects creatures of Large or smaller
    size. You can bring along objects, but not other creatures.

    Augment: For every 2 additional power points you spend, this power can
             affect a target one size category larger.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_trans"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
	object oMaster = GetMaster(oTarget);
	location lTarget = GetLocation(oTarget);
	location lManifester = GetLocation(oManifester);
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT
                              );

    if(manif.bCanManifest)
    {
        int nMaxSize = CREATURE_SIZE_LARGE;
		if (manif.bAugment)
			nMaxSize = CREATURE_SIZE_HUGE;
        int nSize    = GetCreatureSize(oTarget);
		effect eVis = EffectNWN2SpecialEffectFile("fx_teleport_new");
		
		if (PS_GetLocalInt(oTarget, "DIMENSIONAL_ACHORED") || PS_GetLocalInt(oManifester, "DIMENSIONAL_ACHORED"))
		{
			SendMessageToPC(oTarget, "A Dimensional Anchor on one or both parties makes it impossible to teleport.");
			return;	
		}
		if (GetIsReactionTypeHostile(oManifester, oTarget))  
		{
			SendMessageToPC(oManifester, "You cannot switch places with an enemy!");
			return;
		}
		if (oMaster == OBJECT_INVALID)
        {
            oMaster = OBJECT_SELF;
		}
		
        if(nSize <= nMaxSize)
        {
			if (GetIsPC(oTarget) || (GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget || GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget || GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget))
			{
				AssignCommand(oManifester, ClearAllActions());
				AssignCommand(oTarget, ClearAllActions());
				ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
				ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lManifester);
	            DelayCommand(0.2f, AssignCommand(oTarget, ActionJumpToLocation(lManifester)));
	            DelayCommand(0.2f, AssignCommand(oManifester, ActionJumpToLocation(lTarget)));
			}
			else
			{
				SendMessageToPC(oManifester, "You cannot switch places with a neutral NPC");
				return;
			}
        }
    }
}