#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

void main()
{
	if (!PsiPrePowerCastCode())
   	{
   // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
       return;
   	}
	object oManifester = OBJECT_SELF;
   	object oTarget     = oManifester;
   	struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                             GetSpellId(),
                             METAPSIONIC_NONE); //sending metapsionic options
	// object oPC = GetLastSpellCaster();
	if(manif.bCanManifest)
	{
		SendMessageToPC(oManifester, "Manifesting Dimension Door");
		
		
		string sName = GetName(oManifester);
		AssignCommand(oManifester, ClearAllActions());
		location lTarget = GetSpellTargetLocation();
		location lCaster = GetLocation(oManifester);
		effect eVis = EffectNWN2SpecialEffectFile("fx_spell_planar_rift.sef");
	
		
		if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
		if (PS_GetLocalInt(oTarget, "DIMENSIONAL_ACHORED"))
		{
			SendMessageToPC(oTarget, "A Dimensional Anchor makes it impossible to teleport.");
			return;	
		}
		SendMessageToPC(oTarget, "Psionic energies whisk you away to your targeted location.");
		AssignCommand(oTarget, ActionJumpToLocation(lTarget));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lCaster, RoundsToSeconds(4));
	}

}