//::///////////////////////////////////////////////
//:: Ice Simulacrum
//:: [scod_s_ice_simulacrum.nss]
//:://////////////////////////////////////////////
//:: Creates a fake icey copy of the caster and makes
//:: it into your summon
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-17-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "ps_inc_equipment"
#include "x2_inc_spellhook"

const string SIMULACRUM_TEMPLATE = "ps_summon_simulacrum";

void main() {

	//Spellhook script
    if (!X2PreSpellCastCode()) {
        return;
    }

	//debug code to make sure we got here
	object oCaster = GetLastSpellCaster();
	SendMessageToPC(oCaster, "Ice Simulacrum script");
	
    //Declare major variables
    object oTarget = GetSpellTargetObject();
	location lTarget = GetSpellTargetLocation();

	//Extend Metamagic
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    //check meta magic for extend
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration *= 2;
    }
	
	//Generate the clone in another area so we can turn it into a summon!
	object oWP = GetWaypointByTag("DM_WP_Closet");
	object oClone = CreateIllusoryClone(oCaster, SIMULACRUM_TEMPLATE, GetLocation(oWP));
	effect eIce = EffectNWN2SpecialEffectFile("fx_telthor_s");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIce, oClone);
	SendMessageToPC(oCaster, "created clone: "+GetName(oClone));
	
	effect eSummon = EffectSummonCopy(oClone);
	effect eVis1 = EffectNWN2SpecialEffectFile("fx_shadow_open");
	effect eVis2 = EffectNWN2SpecialEffectFile("fx_spell_creeping_cold");
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis1, lTarget, 3.0f);
	DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis2, lTarget, 2.0f));
    DelayCommand(0.75f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, HoursToSeconds(nDuration)));
	
	//Remove the template
	DestroyObject(oClone, 1.0f);
}
//***********************************
	//fx_spell_creeping_cold
	//sp_flamingaura_cold
	//fx_b_shadow_of_void
	//fx_shadow_reaver_form 
	//fx_shadow_open
//***********************************