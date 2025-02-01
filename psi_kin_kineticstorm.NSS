//::///////////////////////////////////////////////
//:: Acid Fog
//:: NW_S0_AcidFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    or their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001


#include "x2_inc_spellhook" 
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"
#include "psi_inc_psifunc"

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

// End of Spell Cast Hook
	
   object oManifester = OBJECT_SELF;
   object oTarget     = GetSpellTargetObject();
   struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                             GetSpellId(),
                             METAPSIONIC_EMPOWER | METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT | METAPSIONIC_MAXIMIZE); //sending metapsionic options
   if(manif.bCanManifest)
   {
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(77);
    location lTarget = GetSpellTargetLocation(); 
	
    int nDuration = manif.nManifesterLevel / 2;
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
	{
		nDuration = nDuration * 2;
	}
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	
   }
}