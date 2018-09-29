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
		SendMessageToPC(oManifester, "Manifesting Psionic Wormhole");
		
		float fDuration = 6.0f * manif.nManifesterLevel; 
		if (GetLocalInt(oManifester, "METAPSI_EXTEND") == 1)
		{
			fDuration = fDuration * 2;
		}
		string sName = GetName(oManifester);
		
		location lTarget = GetSpellTargetLocation();
		location lCaster = GetLocation(oManifester);
		effect eVis = EffectNWN2SpecialEffectFile("psi_wormhole.sef");
		effect eVis2 = EffectNWN2SpecialEffectFile("psi_wormhole_exit.sef");
		
		if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
		if (GetLocalInt(oTarget, "DIMENSIONAL_ACHORED"))
		{
			SendMessageToPC(oTarget, "A Dimensional Anchor makes it impossible to teleport.");
			return;	
		}
		effect ePortal = EffectAreaOfEffect(78);
		object oExit = CreateObject(OBJECT_TYPE_WAYPOINT, "psi_wormhole_wp", lTarget, TRUE);
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, ePortal, lCaster, fDuration);
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lCaster, fDuration);
		DelayCommand(fDuration, DestroyObject(oExit));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis2, lTarget, fDuration);
		SendMessageToPC(OBJECT_SELF, "You bend space-time to create a psionic wormhole for a short time.");	
	}

}