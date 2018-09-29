//::///////////////////////////////////////////////
//:: Astral Caravan
//:: Psychoportation 5
//:://////////////////////////////////////////////
//:: Transports the manifester and nearby allies
//:: to the Astral Plane via a nearby Astral Rift.
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: 3/2/2015
//:://///////////////////////////////////////////


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
	location lTarget = GetLocation(oManifester);
   	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	
   	struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                             GetSpellId(), METAPSIONIC_NONE);
	// object oPC = GetLastSpellCaster();
	
	SendMessageToPC(oManifester, "Manifesting Astral Caravan");
	object oCaster = oManifester;
	
	
	string sName = GetName(oManifester);
	AssignCommand(oManifester, ClearAllActions());
	object oPortLocation = GetWaypointByTag("psi_astral_wpenter");
	object oRiftLocation = GetWaypointByTag("psi_astralrift_wp");
	
	
	float fDistance = GetDistanceToObject(oPortLocation);
	location lCaster = GetLocation(oCaster);
	effect eVis = EffectNWN2SpecialEffectFile("fx_teleport");

	while (GetIsObjectValid(oTarget) && GetDistanceToObject(oRiftLocation) < 2.0) {
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster) && !GetIsInCombat(oTarget)) {
		
			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14322, FALSE));
	
			SendMessageToPC(oTarget, "Psionic energies whisk you away to the Astral Plane.");
			AssignCommand(oTarget, ActionJumpToObject(oPortLocation));
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lCaster, RoundsToSeconds(4));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}	
}