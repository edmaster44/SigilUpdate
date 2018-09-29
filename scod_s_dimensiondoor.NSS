#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
	if (!X2PreSpellCastCode())
	{
		return;
	}
	// object oPC = GetLastSpellCaster();
	object oPC = OBJECT_SELF;
	SendMessageToPC(oPC, "Casting Dimension Door");
	object oCaster = oPC;
	object oTarget = oPC;
	string sName = GetName(oPC);
	AssignCommand(oPC, ClearAllActions());
	location lTarget = GetSpellTargetLocation();
	location lCaster = GetLocation(oCaster);
	effect eVis = EffectNWN2SpecialEffectFile("fx_spell_planar_rift.sef");

	
	if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
	if (GetLocalInt(oTarget, "DIMENSIONAL_ACHORED"))
	{
		SendMessageToPC(oTarget, "A Dimensional Anchor makes it impossible to teleport.");
		return;	
	}
	SendMessageToPC(oTarget, "Arcane energies whisk you away to your targeted location.");
	AssignCommand(oTarget, ActionJumpToLocation(lTarget));
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lCaster, RoundsToSeconds(4));

}