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
#include "ps_inc_time"

const string SIMULACRUM_TEMPLATE = "ps_summon_simulacrum";

void BuffSimulacrum(object oClone) {

	AssignCommand(oClone, ActionCastSpellAtObject(SPELL_BLADEWEAVE, oClone, METAMAGIC_EXTEND, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
	AssignCommand(oClone, ActionCastSpellAtObject(SPELL_MIRROR_IMAGE, oClone, METAMAGIC_EXTEND, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
	AssignCommand(oClone, ActionCastSpellAtObject(SPELL_DISPLACEMENT, oClone, METAMAGIC_EXTEND, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
	AssignCommand(oClone, ActionCastSpellAtObject(SPELL_GREATER_INVISIBILITY, oClone, METAMAGIC_EXTEND, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
	AssignCommand(oClone, ActionCastSpellAtObject(SPELL_SHADOW_SHIELD, oClone, METAMAGIC_EXTEND, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));

}

void CreateSimulacrum(object oCaster, location lLoc, float fDur) {

	object oClone = CreateIllusoryClone(oCaster, SIMULACRUM_TEMPLATE, lLoc);
	effect eIce = EffectNWN2SpecialEffectFile("fx_telthor_s");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIce, oClone);
	SetLocalObject(oCaster, "simulacrum", oClone);
	SetLocalObject(oClone, "Caster", oCaster);
	SetLocalFloat(oClone, "Duration", fDur);
	PS_Timestamp_UNIX(oClone, "Simulacrum_Timestamp");
	
	SetFirstName(oClone, GetFirstName(oClone)+"'s");
	SetLastName(oClone, "Simulacrum");
	
	object oOldHench= GetHenchman(oCaster);
	if (GetIsObjectValid(oOldHench)) {
		SendMessageToPC(oCaster, "The Ice Simulacrum acts as a henchman. You cannot have more than one henchman active.");
		RemoveHenchman(oCaster, oOldHench);
		DestroyObject(oOldHench, 0.1f);
	}
	
	DelayCommand(0.3f, AddHenchman(oCaster, oClone));
	
	DelayCommand(1.0f, ForceRest(oClone));
	
	DelayCommand(1.1f, BuffSimulacrum(oClone));
}

void main() {

	//Spellhook script
    if (!X2PreSpellCastCode()) {
        return;
    }

	//debug code to make sure we got here
	object oCaster = OBJECT_SELF;
	
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
	
	//Play vfx, then spawn in clone!
	effect eVis1 = EffectNWN2SpecialEffectFile("fx_shadow_open");
	effect eVis2 = EffectNWN2SpecialEffectFile("fx_spell_creeping_cold");
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis1, lTarget, 3.0f);
	DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis2, lTarget, 2.0f));
    DelayCommand(0.75f, CreateSimulacrum(oCaster, lTarget, HoursToSeconds(nDuration)));
	
}